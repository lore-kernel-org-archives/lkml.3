Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaE0IRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:17:52 -0400
Received: from ozlabs.org ([103.22.144.67]:34406 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbaE0IJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:09:50 -0400
Date: Tue, 27 May 2014 18:09:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: linux-next: manual merge of the akpm-current tree with the ext4
 tree
Message-ID: <20140527180943.5926e3d5@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/kPG0an8NdimJWSWm7_OT82x"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/kPG0an8NdimJWSWm7_OT82x
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
fs/ext4/page-io.c between commit a3f79014dc44 ("ext4: fix zeroing of
page during writeback") from the ext4 tree and commit 97527831700a
("fs/buffer.c: remove block_write_full_page_endio()") from the
akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext4/page-io.c
index b6a3804a9855,1a64e7a52b84..000000000000
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@@ -422,17 -418,6 +422,17 @@@ int ext4_bio_write_page(struct ext4_io_
  	ClearPageError(page);
 =20
  	/*
- 	 * Comments copied from block_write_full_page_endio:
++	 * Comments copied from block_write_full_page:
 +	 *
 +	 * The page straddles i_size.  It must be zeroed out on each and every
 +	 * writepage invocation because it may be mmapped.  "A file is mapped
 +	 * in multiples of the page size.  For a file that is not a multiple of
 +	 * the page size, the remaining memory is zeroed when mapped, and
 +	 * writes to that region are not written out to the file."
 +	 */
 +	if (len < PAGE_CACHE_SIZE)
 +		zero_user_segment(page, len, PAGE_CACHE_SIZE);
 +	/*
  	 * In the first loop we prepare and mark buffers to submit. We have to
  	 * mark all buffers in the page before submitting so that
  	 * end_page_writeback() cannot be called from ext4_bio_end_io() when IO

--Sig_/kPG0an8NdimJWSWm7_OT82x
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJThEhLAAoJEMDTa8Ir7ZwVOkMQAJO0FESDWM7zO31NqLM41do9
WLR4KnnHoxTXTzVMWAe/6dWQbs/ML8j6fOWb9z8BRw1DSbgwW8r2HWGnr4BcCZtb
dPM48XSrLtkotQmKmzbdK8rBt9febIZMT/G1Lnx6jPVYGaroMH63p5QFqPcE2c/6
ep0XpGfQ3or6zGfnQAUEhdn4aFnp3r9g6VGOnYAIZ4IWRH3m1+H+FxOaIgSf6y57
FHpB/DZIghYcDdjfJUOKHoceqAG7wtQvinbBIsPfI8rGcKXUBL0o0OtBmXeY5Y1F
CEwBKC5ELbu6fgOAZTDhB6eApbMbOEQL36ic0QgxM5dAmS7UVXMQB7Z3dem7ZB1f
ZIF3F65E8O49z32mBQR3Hch8UuAfas3884ooC/FTS9HMNBUp/vIvch4COE3eDrIy
2cqFs3MTE2YspedMMKqleSZEmXSW7NtuuxK86QnnHJp0RNZh5cBPlQZ3x4tYlBUq
7fz3+k5y0eQmCR9vUv8FntgQu3VIiEtbppX7gPNsww7GYBovLgroFtvK7sER7HPc
U2h/spFjEtG9jb3KkBOfA6exrC4PTrINcdbasNmvf4bElUUNzwEvFeiLEwDNmAaa
SNUh29OvxpDZQHsEFf9SKlloGRrucDZl/pLnFsHt9wQ7FqOC+Dh5Yf0AyP0fQhiz
3HHxBWQxuXYkgoGkRiPR
=9oat
-----END PGP SIGNATURE-----

--Sig_/kPG0an8NdimJWSWm7_OT82x--
