Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbbATEEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 23:04:23 -0500
Received: from ozlabs.org ([103.22.144.67]:33749 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbbATEEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 23:04:22 -0500
Date: Tue, 20 Jan 2015 15:04:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: linux-next: manual merge of the audit tree with Linus' tree
Message-ID: <20150120150419.46c6d430@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/To.dFSFr3inhj+8GE=zL6LR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/To.dFSFr3inhj+8GE=zL6LR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the audit tree got a conflict in
include/linux/audit.h between commit 041d7b98ffe5 ("audit: restore
AUDIT_LOGINUID unset ABI") from Linus' tree and commit e80da768eae4
("audit: remove vestiges of vers_ops") from the audit tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/audit.h
index af84234e1f6e,26710c5b9443..000000000000
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@@ -46,8 -46,6 +46,7 @@@ struct audit_tree
  struct sk_buff;
 =20
  struct audit_krule {
- 	int			vers_ops;
 +	u32			pflags;
  	u32			flags;
  	u32			listnr;
  	u32			action;

--Sig_/To.dFSFr3inhj+8GE=zL6LR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUvdPDAAoJEMDTa8Ir7ZwViBcP/2QhpGrklpQtgLELwyZY/CBh
2uzSSEbBbwUwDhs6KIcXq3+4Pd3c/Ri3MQJiPtCF0PG55TuE/9liNK6y0CMGGWmc
dhWfyOu7irmJBDEf1X9zxZZSsLYC5xoLVk8PnNIQQjVpbecktHN2qZKKe+BO3XNj
VYdmpJQ0U3FTBYkBHDy7ceOESHpV4HcK5EDlWEU5b9AE+ec4T4EO6AG+PLjJXNE5
e0bFKSfTtl3mXvT7V/7ltU+zH1aBZ9ZU+5wm+KjAj0DQ4kX1EhJKf3n2gcNJ2Jpj
wErPulItalmf9w6mAiH+iWVrt6+FFPLqZauATsw2yGIXtI6OW4V5ONhZMm4/kKCZ
I7sAJ+JfvdbWeppHYz9CzQXCNZOuoVXoEGp/QuyaeatGtQ0prgIXK1wynPc6JfEc
eXNRPv2IFxko+MknGmbeOtHAMAWgtiV1mVMxynZ2/RDK2P1dUlGpH1daw0E2XGOs
aO33NGgS27jQKXgzC4fJSfEf8wSkNobVtxxBb4238UsH1ovWUHJ2NvxHlPaL5Gp/
lh5XG21wbyZmCqD6gpy318tMqXw8DEumgTrQfcBryUGCJFDfkOrHpLr/KZMEI9Qf
vW6LXm2wV4NdlrTaYDzhK4JfXxr3/HEDKOPbrmwgEjxdmnhG0OkNIPkIwq4X1cJm
tY8Fq/M40dDBqDBgxGil
=y91o
-----END PGP SIGNATURE-----

--Sig_/To.dFSFr3inhj+8GE=zL6LR--
