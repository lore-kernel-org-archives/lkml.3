Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab3KTNbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:31:03 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37506 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3KTNbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:31:00 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: David Howells <dhowells@redhat.com>
Subject: [PATCH] afs: proc cells and rootcell are writeable
Date: Wed, 20 Nov 2013 14:30:55 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.2; x86_64; ; )
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart57709678.k529xufkBf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311201430.56135@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart57709678.k529xufkBf
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Both proc files are writeable and used for configuring cells. But
there is missing correct mode flag for writeable files. Without
this patch both proc files are read only.

diff --git a/fs/afs/proc.c b/fs/afs/proc.c
index 526e4bb..276cb6e 100644
=2D-- a/fs/afs/proc.c
+++ b/fs/afs/proc.c
@@ -147,11 +147,11 @@ int afs_proc_init(void)
 	if (!proc_afs)
 		goto error_dir;
=20
=2D	p =3D proc_create("cells", 0, proc_afs, &afs_proc_cells_fops);
+	p =3D proc_create("cells", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_pr=
oc_cells_fops);
 	if (!p)
 		goto error_cells;
=20
=2D	p =3D proc_create("rootcell", 0, proc_afs, &afs_proc_rootcell_fops);
+	p =3D proc_create("rootcell", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs=
_proc_rootcell_fops);
 	if (!p)
 		goto error_rootcell;
=20
=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart57709678.k529xufkBf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKMuZAACgkQi/DJPQPkQ1KxIACgxeceQXHMOv0r0V+Ob0t+QPFX
hWEAni09eRci0Ux+Q40TAj0oFsPtcN5l
=u+Up
-----END PGP SIGNATURE-----

--nextPart57709678.k529xufkBf--
