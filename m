Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab3BRF2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:28:09 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46137 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab3BRF2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:28:08 -0500
Date: Mon, 18 Feb 2013 16:27:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: linux-next: manual merge of the userns tree with the nfsd tree
Message-Id: <20130218162758.2e71a4fe0676ed701d44e85e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Feb_2013_16_27_58_+1100_llrxzoTygRPtep9b"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Feb_2013_16_27_58_+1100_llrxzoTygRPtep9b
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got a conflict in
net/sunrpc/svcauth_unix.c between commit 2d4383383b0b ("SUNRPC: rework
cache upcall logic") from the nfsd tree and commit 7eaf040b720b ("sunrpc:
Use kuid_t and kgid_t where appropriate") from the userns tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/sunrpc/svcauth_unix.c
index 5085804,a1852e1..0000000
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@@ -465,7 -475,12 +470,7 @@@ static void unix_gid_request(struct cac
  	(*bpp)[-1] =3D '\n';
  }
 =20
- static struct unix_gid *unix_gid_lookup(struct cache_detail *cd, uid_t ui=
d);
 -static int unix_gid_upcall(struct cache_detail *cd, struct cache_head *h)
 -{
 -	return sunrpc_cache_pipe_upcall(cd, h, unix_gid_request);
 -}
 -
+ static struct unix_gid *unix_gid_lookup(struct cache_detail *cd, kuid_t u=
id);
 =20
  static int unix_gid_parse(struct cache_detail *cd,
  			char *mesg, int mlen)

--Signature=_Mon__18_Feb_2013_16_27_58_+1100_llrxzoTygRPtep9b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRIbveAAoJEECxmPOUX5FE+H0QAJh4HeHujPhcXp9Dt4BmXGpC
5onp9xggnUHmAIEpFTkl+1Yqs9aXOw0fwHm7tXMSjXEp+U+35tFEZELYOEGJM5jt
OeSfJAP+O9RoqTIfCVxRpecNIuxq4CdnxJ1bT6ovAR2lbdOAAdL993AGvycNAE2A
j5I2SdPEfOevAtRwWEz/ePMSeQoyvrAB4fdbx2sUYkurZbc/l3li+d0LqAeU6jvB
Phw08NeQuJgNgxyefmv86tAIuwyIYep/WHegMwxTzSDSHpsCv6+Aq9xdjJEU2YbG
hD0xHbb9Ee5dF2K+4W+xuZuDKNtSLkyc6bBL5BpAuRJPV1ZwmivTGU6VV3Tt6M2R
xzVWiP5Jy+fxdjwZ2qB6YHPuepnbTV1QTtfsE5AXZd4Pt8BnBS9Ith5cTvZiy5Ug
KlwyBWXg4EdgZylulq0gnl0jEE0knEblbf0vvkyrOgZnVsRn3NhBdqkyzMseOYTH
5pWXUvZPLl2KAPxvSnGfdtdmBkBsAgvny2jnkPJN4X7AXGkzFifUdrKL8sBI5M0P
UAPYtDa8o3UTqTzC/oPO3cqunXdyu+eYSYeFJfn2WUmiPYoAZfdD3thxmre6sGPz
IbQRvcO4RljcL2BEf9iDHYsTJIM+73/eptXG7HFCyTEgLhxn7kfhXy+42IRL3vGP
QKlVDXQ/dSaRpQLendXR
=fFaR
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Feb_2013_16_27_58_+1100_llrxzoTygRPtep9b--
