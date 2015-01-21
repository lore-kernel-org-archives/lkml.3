Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbbAUHOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 02:14:33 -0500
Received: from ozlabs.org ([103.22.144.67]:46902 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbbAUHOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 02:14:32 -0500
Date: Wed, 21 Jan 2015 18:14:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the akpm-current tree with the  tree
Message-ID: <20150121181425.18399e35@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/DAAQF6MRW91gbeEGfRLQ4ci"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/DAAQF6MRW91gbeEGfRLQ4ci
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
mm/swap.c between commit 97b713ba3eba ("fs: kill BDI_CAP_SWAP_BACKED")
from the block tree and commit f69ec11fad9f ("rmap: drop support of
non-linear mappings") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/swap.c
index 4e0109a2f37b,5b3087228b99..000000000000
--- a/mm/swap.c
+++ b/mm/swap.c
@@@ -1138,10 -1138,10 +1138,8 @@@ void __init swap_setup(void
  #ifdef CONFIG_SWAP
  	int i;
 =20
- 	for (i =3D 0; i < MAX_SWAPFILES; i++) {
 -	if (bdi_init(swapper_spaces[0].backing_dev_info))
 -		panic("Failed to init swap bdi");
+ 	for (i =3D 0; i < MAX_SWAPFILES; i++)
  		spin_lock_init(&swapper_spaces[i].tree_lock);
- 		INIT_LIST_HEAD(&swapper_spaces[i].i_mmap_nonlinear);
- 	}
  #endif
 =20
  	/* Use a smaller cluster for small-memory machines */

--Sig_/DAAQF6MRW91gbeEGfRLQ4ci
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUv1HWAAoJEMDTa8Ir7ZwVLaYP/0+LIFMnk0d7I272b8IC06I4
mXHocyYOK1tl+29AfDPsnqMS7gD6nO6qEdjAYPcER+D0ovZyFFEJ0b5M8yJ2GsGh
Ga4MRNNM9gFemw4s5xulNy+YE1eFJFbvWdJTIJ9VSFVwoQuHh7E+5f4F23x3Ohvk
dZbgFLwAX/IuPeAwz6wkAAJEYm0Ok3jQEn+wZgiXguBdxUC0+lxcQfHF/r/2pUve
Lv8Rsj5BZtY5TMqKgPqYeHkm/bmDBLYEv2++cbGj6GL0BPPsKIQgRWh483l2qzz5
DhHjpctzl2UEyiSTlhVJkVoveKJSGLz914vG+w/iKjTfriRyAJxCTx2h5vjlFWVU
ID1DUvmMIYFMzOBZ6ukK8nxKZ0vU0P3IFOU3Ll22woPpx4lnVIHGZKTkTKaKk/Ii
/jqu2sMeKnTqIViz0VC8pmjdRi1+UkLaePJIxMhiZZJVrxNyDHjWUC4EoXxG7O98
LvMGW0rGgNXW2wVDHvR3PJimZ1EvlWse37kf0mbWfLw+GuPaxNW21qPTIwhWV5KA
aim89mWLGCEm97V7JIzqBvNDdRiDK3+T8CINs7vRt2YSAbg+RbJmxPhN4mWrV/+m
dzMKnKg8Wk17W7im9ndZfRBr/HXjG/1gynoRIMyWEe7Tt98VA3HGqRVQhbCgEWed
H9bXz6FajvLqIV9DMTmV
=ijYO
-----END PGP SIGNATURE-----

--Sig_/DAAQF6MRW91gbeEGfRLQ4ci--
