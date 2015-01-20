Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbbATEE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 23:04:28 -0500
Received: from ozlabs.org ([103.22.144.67]:35938 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbbATEE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 23:04:26 -0500
Date: Tue, 20 Jan 2015 15:04:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Drysdale <drysdale@google.com>
Subject: linux-next: manual merge of the audit tree with Linus' tree
Message-ID: <20150120150423.16fb71c8@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/vL8HmUH+FSQCo+Xx3DIHIst"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/vL8HmUH+FSQCo+Xx3DIHIst
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the audit tree got a conflict in fs/exec.c
between commit 51f39a1f0cea ("syscalls: implement execveat() system
call") from Linus' tree and commit 5dc5218840e1 ("fs: create proper
filename objects using getname_kernel()") from the audit tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/exec.c
index ad8798e26be9,d067771af6d4..000000000000
--- a/fs/exec.c
+++ b/fs/exec.c
@@@ -794,8 -789,15 +794,15 @@@ exit
 =20
  struct file *open_exec(const char *name)
  {
- 	struct filename tmp =3D { .name =3D name };
- 	return do_open_execat(AT_FDCWD, &tmp, 0);
+ 	struct file *file;
+ 	struct filename *tmp;
+=20
+ 	tmp =3D getname_kernel(name);
+ 	if (unlikely(IS_ERR(tmp)))
+ 		return (void *)tmp;
 -	file =3D do_open_exec(tmp);
++	file =3D do_open_execat(AT_FDCWD, tmp, 0);
+ 	putname(tmp);
+ 	return file;
  }
  EXPORT_SYMBOL(open_exec);
 =20

--Sig_/vL8HmUH+FSQCo+Xx3DIHIst
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUvdPHAAoJEMDTa8Ir7ZwVW3gP/RAIs0rWe+2NMmBnBxJ6CiZ3
EfFsYSpsDZxv6QkCRsoJZzgMGhiVtr78CWkeekd3Tm3OZEdTJiv5BODZrUQIRn6e
MGJmMEizWnvG5X0D/RdqR6fiTQkDqTbj6azILIiAsoV7IS0mHIIDCTcrDPwEO0ZV
FC1txfTVn47/sdcuRNkhyK4K9dHL9Pa2ZbZgD8tVKwKpgfCKLm5c4vR6Inuwl3Op
5maaWJ7kdP51My86rFTel//WIxW1deIMepkT0bHYChcXrr8SeQCLUIPlLi2hmG/t
cZuvA/EYO6V9lGcMw8VJecCM9iG1bhSuCI+m1BExSl1aYWJapHWRmadr80FosyK1
eoLACE3qGYAEOnjkns8n53R1qpmnoXO+Uc4E6+cuXCMs7ZD4xnv1cOxlNO5mUAIC
5HJCAnLLRLUclCJBoihfkDMip/m9kycBUY2LYwXGZKeBitraRokJSsW46MIxfE0e
kvp+9XMM+iM3d0vwzvENyqRR+kWwWcWYGvaqT38kn7l9aXZ4khs7siZ8QUePs87f
zGT14+VlbWmnPrrzLskfYGeDN31mEre2vCuCK/tQ+/nWdNuKHyXRviyK8sbNgPTI
LmrYUBF6b/pFkRve+pHtDzy/aGsExg5euc/i1emEePw279oC4rtkso3mSMFooUvB
9m1i08nSKWKVAgPlG5Sz
=ooRO
-----END PGP SIGNATURE-----

--Sig_/vL8HmUH+FSQCo+Xx3DIHIst--
