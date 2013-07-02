Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab3GBFaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:30:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35821 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3GBFaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:30:07 -0400
Date: Tue, 2 Jul 2013 15:29:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Jackson <mpfj-list@newflow.co.uk>,
        Tony Lindgren <tony@atomide.com>, Pekon Gupta <pekon@ti.com>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: linux-next: manual merge of the arm-soc tree with the l2-mtd tree
Message-Id: <20130702152954.f25bbf51c1a79aa4437e22ee@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Jul_2013_15_29_54_+1000_on4UlqIvDOQ58dV4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Jul_2013_15_29_54_+1000_on4UlqIvDOQ58dV4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
Documentation/devicetree/bindings/mtd/gpmc-nand.txt between commits
6c88058ef927 ("ARM: OMAP2+: cleaned-up DT support of various ECC
schemes") and 212012138deb ("mtd: nand: omap2: updated support for BCH4
ECC scheme") from the l2-mtd tree and commit 496c8a0bbb72 ("ARM: OMAP2+:
Allow NAND transfer mode to be specified in DT") from the arm-soc tree.

I fixed it up (maybe - see below) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/devicetree/bindings/mtd/gpmc-nand.txt
index b3f23df,df338cb..0000000
--- a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
@@@ -17,59 -17,27 +17,66 @@@ Required properties
 =20
  Optional properties:
 =20
 - - nand-bus-width: 		Set this numeric value to 16 if the hardware
 -				is wired that way. If not specified, a bus
 -				width of 8 is assumed.
 + - nand-bus-width: 		Determines data-width of the connected device
 +				x16 =3D "16"
 +				x8  =3D "8" (default)
 =20
 - - ti,nand-ecc-opt:		A string setting the ECC layout to use. One of:
 =20
 -		"sw"		Software method (default)
 -		"hw"		Hardware method
 -		"hw-romcode"	gpmc hamming mode method & romcode layout
 -		"bch4"		4-bit BCH ecc code
 -		"bch8"		8-bit BCH ecc code
 + - ti,nand-ecc-opt:		Determines the ECC scheme used by driver.
 +				It can be any of the following strings:
 +
 +	"hamming_code_sw"		1-bit Hamming ECC
 +					- ECC calculation in software
 +					- Error detection in software
 +					- ECC layout compatible with S/W scheme
 +
 +	"hamming_code_hw"		1-bit Hamming ECC
 +					- ECC calculation in hardware
 +					- Error detection in software
 +					- ECC layout compatible with S/W scheme
 +
 +	"hamming_code_hw_romcode"	1-bit Hamming ECC
 +					- ECC calculation in hardware
 +					- Error detection in software
 +					- ECC layout compatible with ROM code
 +
 +	"bch4_code_hw_detection_sw"	4-bit BCH ECC
 +					- ECC calculation in hardware
 +					- Error detection in software
 +					- ECC layout compatible with S/W scheme
 +					* depends on CONFIG_MTD_NAND_ECC_BCH
 +
 +	"bch4_code_hw"             	4-bit BCH ECC
 +					- ECC calculation in hardware
 +					- Error detection in hardware
 +					- ECC layout compatible with ROM code
 +					* depends on CONFIG_MTD_NAND_OMAP_BCH
 +					* requires <elm_id> to be specified
 +
 +	"bch8_code_hw_detection_sw"	8-bit BCH ECC
 +					- ECC calculation in hardware
 +					- Error detection in software
 +					- ECC layout compatible with S/W scheme
 +					* depends on CONFIG_MTD_NAND_ECC_BCH
 +
 +	"bch8_code_hw"             	8-bit BCH ECC
 +					- ECC calculation in hardware
 +					- Error detection in hardware
 +					- ECC layout compatible with ROM code
 +					* depends on CONFIG_MTD_NAND_OMAP_BCH
 +					* requires <elm_id> to be specified
 =20
+  - ti,nand-xfer-type:		A string setting the data transfer type. One of:
+=20
+ 		"prefetch-polled"	Prefetch polled mode (default)
+ 		"polled"		Polled mode, without prefetch
+ 		"prefetch-dma"		Prefetch enabled sDMA mode
+ 		"prefetch-irq"		Prefetch enabled irq mode
+=20
 - - elm_id:	Specifies elm device node. This is required to support BCH
 - 		error correction using ELM module.
 +
 + - elm_id:			Specifies elm device node. This is required to
 +				support some BCH ECC schemes mentioned above.
 +
 =20
  For inline partiton table parsing (optional):
 =20

--Signature=_Tue__2_Jul_2013_15_29_54_+1000_on4UlqIvDOQ58dV4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR0mVWAAoJEECxmPOUX5FEhl8QAJL1WyZXuPIqUJlTMpNrm68P
tAe3+w9o8zaT1+UtrkUO/zS2KVbL8BM+ychZ7oFlQsLRHSn3t/XsdZ8y0KyCoj69
mRRUKlf0f/g8SYx28AMFrkaYhqTN6jrs2VpGc2irZ4LDfAO1oAz2izB5qg+CeFNP
e/zTLUphC82r2u/wiAwOQgPPFoZfJYSB2xyw4wcM1AWPr8j9FFwOj9ImIPArf3Lx
reTorpfqIipsUX8GlcGKY+r0dRACuCJN/2OHOBfefKHvqFGYGUmS8ePWR7Sx6nCj
XYsKFS00WWxdu/p7fXwBvTr7v3jKad5N9O50GdYruXNwEXbw3DyjxDNSLKSyA8aV
l2GcPpMMg9lNcLmGVjn0uuU34VlV9084hR02Z6u2fZy/JQhGz59MpVNtBxiL/Jg7
JrSRGEf3SnednfNkneuMM9gCs9eQa9utGI/eyz7XRVOg87s/MyI+t0kT3usb/oIa
0FDA/vWOdthyS19Fls+odwtJza61jvrFRD9ws9MsmNt/Cyk9FcFh0WwFMl5cmeuw
Eidv0qjk3JXEswO5YdJKVHwztw/6/zjAcQD5DC2HLLOX4Jx8agTGkvsfjGxjtUia
T5F1U9DRPj/w7GnbozXtoBeYBKv4KAgcSr2tHgnKEfSmOizoUq5iD8Vjn4dVwXeS
Uc2DmUm7Y1yYyIq7Qo9E
=1MuD
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Jul_2013_15_29_54_+1000_on4UlqIvDOQ58dV4--
