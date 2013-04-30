Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab3D3GDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 02:03:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38682 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3D3GDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 02:03:09 -0400
Date: Tue, 30 Apr 2013 16:02:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Sam Bradshaw <sbradshaw@micron.com>, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <koverstreet@google.com>
Subject: linux-next: manual merge of the akpm tree with the block tree
Message-Id: <20130430160258.fb07daf91f2542552d5cde6d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__30_Apr_2013_16_02_58_+1000_TuXakFpKGql6_/SI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Apr_2013_16_02_58_+1000_TuXakFpKGql6_/SI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/block/mtip32xx/mtip32xx.c between commit 2077d947260c ("mtip32xx:
Workaround for unaligned writes") from the block tree and commit
"mtip32xx: convert to batch completion" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/block/mtip32xx/mtip32xx.c
index 847107e,4b9603e..0000000
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@@ -2561,8 -2574,8 +2577,8 @@@ static int mtip_hw_ioctl(struct driver_
   *	None
   */
  static void mtip_hw_submit_io(struct driver_data *dd, sector_t sector,
- 			      int nsect, int nents, int tag, void *callback,
- 			      void *data, int dir, int unaligned)
+ 			      int nsect, int nents, int tag,
 -			      struct bio *bio, int dir)
++			      struct bio *bio, int dir, int unaligned)
  {
  	struct host_to_dev_fis	*fis;
  	struct mtip_port *port =3D dd->port;
@@@ -3934,10 -3911,8 +3945,9 @@@ static void mtip_make_request(struct re
  				bio_sectors(bio),
  				nents,
  				tag,
- 				bio_endio,
  				bio,
 -				bio_data_dir(bio));
 +				bio_data_dir(bio),
 +				unaligned);
  	} else
  		bio_io_error(bio);
  }

--Signature=_Tue__30_Apr_2013_16_02_58_+1000_TuXakFpKGql6_/SI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRf16SAAoJEECxmPOUX5FEupgP/A/FPAUdS5i55Sai8ChBX1tA
8MoFyMWLRMR7Dms1BDhO/uUrrsEcB++2D9uqXAhwHdUDPoiEQekEyEO+d8peBLJE
i//a3DHR6SCq68MgvEdTSBt+FwWGBdH1875Ff5IoFy+9CZEAW91Y5Bcip8vB7k46
lytEIe69QD++JQWME3AD5mA8BWS12L94E+dyn3wn49OxgE4P+K3rG68oUHxvHLpi
r4/u1X8L/HRJBvOzebb8KxGB/R0CPaWQScThR60vUnDkv/wy2XM5c9n/5wygUIvG
eg/HqpDD6JLqtUpmnBwb1g3pIS++u/pk1t2CZ+9O9ic5M4eKbD0wMDXyvbf+j7hv
E921VDCbVfwnFC5AoookUgaDXRdJkLLgcLTqxp5bS0OdPbsu91xoQa2HGMRpCXCZ
6fgMlCE9C3EMgP282+e0TIXp/VYabwz7HWNUDwlXzVfxNhOuPUN7h5Tkp8cH167f
xvwcsvJ4zPKprluCMQkOhh5RRmq0Ke2Ozz2ET4obFS2OHsAXcDiu1ZKc9MJ9HJeu
N+wUTQeb6nEGPLCXoTcJ57UcMYB/BibGuFhTx7PKU+noeeMThTGnLubHP43hPBUJ
KZoB8BX2aAfQJYIFicve6fAQ3xHCq8ufcZ95tLDmYF7Hrx7xfp/F6tfyF5j7PSJg
hwthr21xmcv8cQElFQlg
=5wVG
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Apr_2013_16_02_58_+1000_TuXakFpKGql6_/SI--
