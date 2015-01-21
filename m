Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbbAUDqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:46:07 -0500
Received: from ozlabs.org ([103.22.144.67]:55822 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbbAUDqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:46:05 -0500
Date: Wed, 21 Jan 2015 14:45:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: build failure after merge of the block tree
Message-ID: <20150121144558.79cb2056@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/xTXcvTiRVXiAda2gd6Tm9Jj"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/xTXcvTiRVXiAda2gd6Tm9Jj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/staging/lustre/lustre/llite/llite_lib.c: In function 'll_read_inode=
2':
drivers/staging/lustre/lustre/llite/llite_lib.c:1774:18: error: 'struct add=
ress_space' has no member named 'backing_dev_info'
  inode->i_mapping->backing_dev_info =3D &s2lsi(inode->i_sb)->lsi_bdi;
                  ^

Caused by commit b83ae6d42143 ("fs: remove mapping->backing_dev_info")
not updating the lustre code in the staging tree.

I have disabled the lustre code for today using the following.  Please
let me know if you fix the lustre code so that I can reenable it.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 21 Jan 2015 14:36:21 +1100
Subject: [PATCH] disable the lustre code for now

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/lustre/lustre/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre=
/lustre/Kconfig
index 6725467ef4d0..37dd33f6597e 100644
--- a/drivers/staging/lustre/lustre/Kconfig
+++ b/drivers/staging/lustre/lustre/Kconfig
@@ -1,6 +1,7 @@
 config LUSTRE_FS
 	tristate "Lustre file system client support"
 	depends on INET && m && !MIPS && !XTENSA && !SUPERH
+	depends on BROKEN
 	select LNET
 	select CRYPTO
 	select CRYPTO_CRC32
--=20
2.1.4

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/xTXcvTiRVXiAda2gd6Tm9Jj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUvyD7AAoJEMDTa8Ir7ZwVMZ4P+QGvKVp/QpLbIJg52ORh7rQ6
RJqX0T1aW3dQ41IpqBMBARjztctWxUinr93AwMVHSUPso1I1rA58c6R0r4ivpoAS
+an8UyMAJ67qG4r+ULnL9mnUjpRofPT/itKovR2OFJiLPKN7HAW5sVkFiG7KmogT
Ws8PSQL8JJmL4GNKWYikmiIdsYr2nt55pzdpLVoa9fZcj0yKPiEl2RrHpW8uYQqd
ACNhWHO842StArl8kE4vGtFMbUdtnf3jM2C7+pv+W41cppZMeLYBdlg9bZ5XEebj
nEJMyfILjopBAa+2reKM08NJWLgQT+/Qbn++90YtSKvAT/V1sdCdO9Nap3PT6Ows
2guEdmzM2HZOVuYKy9FOmOnzFIwUjye3rCQ+8lG4QPXNbAT56/Pn5bUKUbTTRQNr
wyjM8BGTmXgMo9fawVBccu+F8jOC6lfWNpcZxuHjLJGXKgJgmnP7Ran6VW9Ir4aB
gqbFOIgMdgMB8wNzGH7Ff3PfcagOR/glFqiR5E8bAT82akyyITiYYEC5Krc+QLfD
BQBE2qE0FlXAa6Ni1eJQt1bHy7G6jlcmhaCVh4usF9T9D+L+8qiqjU9LXPgtRTQu
u9Ljihyzv3DMy/l5tfLOdCGRhiGp0CbhJWLZux2jNA1u3zgwQxROUXeu2vyQaxTm
wbGfxPCJhqiHSfyWcTR2
=5urv
-----END PGP SIGNATURE-----

--Sig_/xTXcvTiRVXiAda2gd6Tm9Jj--
