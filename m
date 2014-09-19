Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbaISDNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 23:13:51 -0400
Received: from ozlabs.org ([103.22.144.67]:34672 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584AbaISDNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 23:13:50 -0400
Date: Fri, 19 Sep 2014 13:13:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>, Jeff Layton <jlayton@poochiereds.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Subject: linux-next: manual merge of the security tree with the file-locks
 tree
Message-ID: <20140919131336.75ee47d6@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/qdo9zEVPfTZWudI9=heCl8B"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qdo9zEVPfTZWudI9=heCl8B
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the security tree got a conflict in
security/smack/smack_lsm.c between commit 1f5a9ba7910c ("security: make
security_file_set_fowner, f_setown and __f_setown void return") from
the file-locks tree and commit 21c7eae21a21 ("Make Smack operate on
smack_known struct where it still used char*") from the security tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc security/smack/smack_lsm.c
index 69e5635d89e5,93dc876734a4..000000000000
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@@ -1394,7 -1574,8 +1574,7 @@@ static void smack_file_set_fowner(struc
  {
  	struct smack_known *skp =3D smk_of_current();
 =20
- 	file->f_security =3D skp->smk_known;
+ 	file->f_security =3D skp;
 -	return 0;
  }
 =20
  /**

--Sig_/qdo9zEVPfTZWudI9=heCl8B
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUG59mAAoJEMDTa8Ir7ZwVuaUP/13QtoQPNJ51kQS1H4S1GInW
l213TEVrObBOaOCuZmoYVpynYexYpZXK5QqMKKqEpp0G0HMz4i6nybfURRj9gknp
mKk1MSPeLTPVrVbwdQ3DcZOQqpvjnUbmc9Tk/VZsOEdwdeNVAzyJP5rs2mEwn/67
tsaCOS8MKnyolnPp5IqtuHYUUfZ5LZz4F+gj5n0JhvqRSlD73GIVj3FRg4BFzbXl
wuAoUMBtNx1gEYUNDg5NjDf/5FdCDYPeHuC4cosAQodoOkPA+5rKqyxE95WSwJBu
zANEkUHdQuhTBPXjyA4R/EuEQ/pmRKbKyXPAoBV1mkHT+V5HZYiXiw51SjErXJww
18hROoy3siUx1fIUv3FsYgrQuTWxoSpt92NOQ5ivvUo/XRN0AN3b2FvfEyRRg+28
xwPVeNUw+LMW/kycfucbTKqyuqzx/jCfyfkLAx0W1jQSMMxewyzQ6s45DzyZGajt
4raoSgseNVve3niyYEY97A2I4atm4S5GbLPfFKaj24n2sc779RfrXKe6FMV+NPUk
U1pnqE3xjQEWAP/MmxMKwP0P+Bc+jDlybibe/MOTopLn6yCk0fB6NnPPbS1MRp4u
lpNkwV8r2Jc7qC+tsg3SgA4Az7olnfkCGfWcye/C2nXwDL5vm/lqQoFHCRJAN5Ni
VWACTojTN2EQuWAtkxwQ
=GXP5
-----END PGP SIGNATURE-----

--Sig_/qdo9zEVPfTZWudI9=heCl8B--
