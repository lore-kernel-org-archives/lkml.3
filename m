Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab3GBFdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:33:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34827 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab3GBFdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:33:50 -0400
Date: Tue, 2 Jul 2013 15:33:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pekon Gupta <pekon@ti.com>, Artem Bityutskiy <dedekind1@gmail.com>
Subject: linux-next: manual merge of the arm-soc tree with the l2-mtd tree
Message-Id: <20130702153348.ce27e4a6185c0b403e039e06@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Jul_2013_15_33_48_+1000_bAACq1qmBWAh5kdy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Jul_2013_15_33_48_+1000_bAACq1qmBWAh5kdy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/mtd/nand/Kconfig between commit 212012138deb ("mtd: nand: omap2:
updated support for BCH4 ECC scheme") from the l2-mtd tree and commit
930d800bded7 ("mtd: omap2: allow bulding as a module") from the arm-soc
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mtd/nand/Kconfig
index a6e247c,50543f1..0000000
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@@ -95,13 -95,35 +95,13 @@@ config MTD_NAND_OMAP
 =20
  config MTD_NAND_OMAP_BCH
  	depends on MTD_NAND && MTD_NAND_OMAP2 && ARCH_OMAP3
- 	bool "Support hardware based BCH error correction"
 -	tristate "Enable support for hardware BCH error correction"
++	tristate "Support hardware based BCH error correction"
  	default n
  	select BCH
 -	select BCH_CONST_PARAMS
  	help
 -	 Support for hardware BCH error correction.
 -
 -choice
 -	prompt "BCH error correction capability"
 -	depends on MTD_NAND_OMAP_BCH
 -
 -config MTD_NAND_OMAP_BCH8
 -	bool "8 bits / 512 bytes (recommended)"
 -	help
 -	 Support correcting up to 8 bitflips per 512-byte block.
 -	 This will use 13 bytes of spare area per 512 bytes of page data.
 -	 This is the recommended mode, as 4-bit mode does not work
 -	 on some OMAP3 revisions, due to a hardware bug.
 -
 -config MTD_NAND_OMAP_BCH4
 -	bool "4 bits / 512 bytes"
 -	help
 -	 Support correcting up to 4 bitflips per 512-byte block.
 -	 This will use 7 bytes of spare area per 512 bytes of page data.
 -	 Note that this mode does not work on some OMAP3 revisions, due to a
 -	 hardware bug. Please check your OMAP datasheet before selecting this
 -	 mode.
 -
 -endchoice
 +	  Some devices have built-in ELM hardware engine, which can be used to
 +	  locate and correct errors when using BCH ECC scheme. This enables the
 +	  driver support for same.
 =20
  if MTD_NAND_OMAP_BCH
  config BCH_CONST_M

--Signature=_Tue__2_Jul_2013_15_33_48_+1000_bAACq1qmBWAh5kdy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR0mY8AAoJEECxmPOUX5FEKNEP/3TPLkzb+aXFcyh72uAnqg1X
VOfIU7jWEdEzpdPyojDQqa9NTMEyO44aYftcWtkHy+MbxE1fVsq0g4t9vrgMazcU
vr32joqzXneO1Qqd0UAxTQdlIk4tOLzkguIs6ijW4lGh97oYe6Wuv9KYHxKxdbAn
rJTwPmfyGJtSPYxW6Jr11bbvOjuII2u97izaiQjn7HCOi+h1pxUzpE+Z932Gw2qI
lRGZvHEfEh2lZZkqGE6qeOgSxUK72BRLY18EzvXQsmy7git04lOmelzQS7mzZpC0
dWd01RTCsRmo0N02ixbw4+XzLZ7IteKHxgsyjVgLbmn6qDRuIjv2NL4gJrfRJ1vm
iYDI+tzSP29C0uOcI7CciDZOQH0oEqQSky5LzryqxAAOTZdjq1imDNQv4Zh+cBfC
O5cUm/a5Hu8UMeudskSWvWnCMrwUNmT85TmJ4cxjQmX7qp5njir7Xewp/52OR1xQ
enJB3RFihgGB4NBHKAASBRJmXfvVO5qK3Zo4Fv4NiI+S59dmVy5kSU7RBQVapE/e
qitJL4jzGeD28b28KaBI11QTKG3J3fOkNMHKOfM5e2Wwvm5VUJESAhKyZ88eNq31
G5TgHanWqK+/dZ1NdAPJuTDwNdirn7WbSrQQvkY5jTzVP2LprZduNsrKoZDfK250
HEakA5Gr4CH+v0zrny4F
=Ao/b
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Jul_2013_15_33_48_+1000_bAACq1qmBWAh5kdy--
