Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaKCC3Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 21:29:25 -0500
Received: from ozlabs.org ([103.22.144.67]:39743 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbaKCC3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 21:29:23 -0500
Date: Mon, 3 Nov 2014 13:29:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: linux-next: manual merge of the staging tree with the vfs tree
Message-ID: <20141103132914.2a86667d@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/npsws6yDWzLHu9nrB.fysRR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/npsws6yDWzLHu9nrB.fysRR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/lustre/lustre/llite/file.c between commit bc281d072ba9
("lustre: opened file can't have negative dentry") from the vfs tree
and commit 57303e76c225 ("staging: lustre: Fix checkpatch.pl
spacing-related errors") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/lustre/lustre/llite/file.c
index a2ae9a68a9a0,a5acc98a1c99..000000000000
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@@ -266,10 -266,6 +266,11 @@@ static int ll_md_close(struct obd_expor
  {
  	struct ll_file_data *fd =3D LUSTRE_FPRIVATE(file);
  	struct ll_inode_info *lli =3D ll_i2info(inode);
 +	int lockmode;
 +	__u64 flags =3D LDLM_FL_BLOCK_GRANTED | LDLM_FL_TEST_LOCK;
 +	struct lustre_handle lockh;
- 	ldlm_policy_data_t policy =3D {.l_inodebits=3D{MDS_INODELOCK_OPEN}};
++	ldlm_policy_data_t policy =3D {
++	.l_inodebits =3D {MDS_INODELOCK_OPEN} };
  	int rc =3D 0;
 =20
  	/* clear group lock, if present */

--Sig_/npsws6yDWzLHu9nrB.fysRR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUVuh+AAoJEMDTa8Ir7ZwVIeIP+gPNYgpImUnKP27jJ8g72Arn
pjvaCRc8GdtP4E/09LfPqJQ15mzp5ebqkj+bkde/xdzRoysXLko4IJ9s/LGzJvvn
PpaNnrC1o9HfcH6yjNIEoSAq82epj5rmiU5mgkZZCbwJp07l8tsX00n2x+GHRb9b
ga6rcGBRSzwgSOesRNlGK22lmAn/iwgmQMNdEJd7iUekftyJK88RaPTHU95nbf4r
B6QGCJoOHJu43pQpA8kz+nd8vbEJOvgYt0yYA16rx/X+zn713hxigamPYzr4jlKb
+8OfZJmhIEY63Xugcet4ivzDBsza3Zz3m4XKslV9NebCTfRgzLWpbsoyyaC5t499
x+cEoW4iyPw4RZF8fPI0/QR/13dGR1JiqB+rrXu7QznH8CMqN+1mDZjuljGSlCvc
Z38zqrIAaeTPn8+fD07dE905Cmx/WUlsHs/7KhlxMUO6gsrQAHvwAX8Idph9nsYN
e3lQ7w/ScHO1i2mmfCe1+DdrJR8hV4zDGe1HC9Q8H+FAS5qRZRc+xhPqocF7//YN
khkqKUT8HWpRRs60LL4vQe+IbICsF/F9tpD2fIWS8WDTv2kQQwpZIFo74FczZBnL
y8vTcRv6NLhpsC54a7mHrLtssrsHgpCsEkNYAwbNnElqDJYUpwO524BHAs1TB6Nb
vTlG8xttdRE4+ls7pS0X
=/qhz
-----END PGP SIGNATURE-----

--Sig_/npsws6yDWzLHu9nrB.fysRR--
