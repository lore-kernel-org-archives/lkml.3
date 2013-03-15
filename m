Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab3COAxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 20:53:17 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44072 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3COAxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 20:53:14 -0400
Date: Fri, 15 Mar 2013 11:53:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: linux-next: manual merge of the l2-mtd tree with the mtd tree
Message-Id: <20130315115304.7445e641bfa1b2babcf35bfc@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Mar_2013_11_53_04_+1100_1RbheZF3LGH+_SyU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Mar_2013_11_53_04_+1100_1RbheZF3LGH+_SyU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

Today's linux-next merge of the l2-mtd tree got a conflict in
drivers/mtd/nand/nand_ids.c between commit 5bc7c33ca93a ("mtd: nand:
reintroduce NAND_NO_READRDY as NAND_NEED_READRDY") from the mtd tree and
commits a4c121db7e85 ("mtd: nand_ids: minor clean-ups"), c11138000b6d
("mtd: decommission the NAND museum"), edac3311879c ("mtd: nand: remove
AG-AND support") and 663793025e57 ("mtd: nand_ids: introduce helper
macros") from the l2-mtd tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mtd/nand/nand_ids.c
index 9c61238,625bc89..0000000
--- a/drivers/mtd/nand/nand_ids.c
+++ b/drivers/mtd/nand/nand_ids.c
@@@ -10,163 -10,131 +10,134 @@@
   */
  #include <linux/module.h>
  #include <linux/mtd/nand.h>
- /*
- *	Chip ID list
- *
- *	Name. ID code, pagesize, chipsize in MegaByte, eraseblock size,
- *	options
- *
- *	Pagesize; 0, 256, 512
- *	0	get this information from the extended chip ID
- +	256	256 Byte page size
- *	512	512 Byte page size
- */
- struct nand_flash_dev nand_flash_ids[] =3D {
+=20
+ #define LP_OPTIONS NAND_SAMSUNG_LP_OPTIONS
+ #define LP_OPTIONS16 (LP_OPTIONS | NAND_BUSWIDTH_16)
+=20
 +#define SP_OPTIONS NAND_NEED_READRDY
 +#define SP_OPTIONS16 (SP_OPTIONS | NAND_BUSWIDTH_16)
 +
- #ifdef CONFIG_MTD_NAND_MUSEUM_IDS
- 	{"NAND 1MiB 5V 8-bit",		0x6e, 256, 1, 0x1000, SP_OPTIONS},
- 	{"NAND 2MiB 5V 8-bit",		0x64, 256, 2, 0x1000, SP_OPTIONS},
- 	{"NAND 4MiB 5V 8-bit",		0x6b, 512, 4, 0x2000, SP_OPTIONS},
- 	{"NAND 1MiB 3,3V 8-bit",	0xe8, 256, 1, 0x1000, SP_OPTIONS},
- 	{"NAND 1MiB 3,3V 8-bit",	0xec, 256, 1, 0x1000, SP_OPTIONS},
- 	{"NAND 2MiB 3,3V 8-bit",	0xea, 256, 2, 0x1000, SP_OPTIONS},
- 	{"NAND 4MiB 3,3V 8-bit",	0xd5, 512, 4, 0x2000, SP_OPTIONS},
- 	{"NAND 4MiB 3,3V 8-bit",	0xe3, 512, 4, 0x2000, SP_OPTIONS},
- 	{"NAND 4MiB 3,3V 8-bit",	0xe5, 512, 4, 0x2000, SP_OPTIONS},
- 	{"NAND 8MiB 3,3V 8-bit",	0xd6, 512, 8, 0x2000, SP_OPTIONS},
-=20
- 	{"NAND 8MiB 1,8V 8-bit",	0x39, 512, 8, 0x2000, SP_OPTIONS},
- 	{"NAND 8MiB 3,3V 8-bit",	0xe6, 512, 8, 0x2000, SP_OPTIONS},
- 	{"NAND 8MiB 1,8V 16-bit",	0x49, 512, 8, 0x2000, SP_OPTIONS16},
- 	{"NAND 8MiB 3,3V 16-bit",	0x59, 512, 8, 0x2000, SP_OPTIONS16},
- #endif
-=20
- 	{"NAND 16MiB 1,8V 8-bit",	0x33, 512, 16, 0x4000, SP_OPTIONS},
- 	{"NAND 16MiB 3,3V 8-bit",	0x73, 512, 16, 0x4000, SP_OPTIONS},
- 	{"NAND 16MiB 1,8V 16-bit",	0x43, 512, 16, 0x4000, SP_OPTIONS16},
- 	{"NAND 16MiB 3,3V 16-bit",	0x53, 512, 16, 0x4000, SP_OPTIONS16},
-=20
- 	{"NAND 32MiB 1,8V 8-bit",	0x35, 512, 32, 0x4000, SP_OPTIONS},
- 	{"NAND 32MiB 3,3V 8-bit",	0x75, 512, 32, 0x4000, SP_OPTIONS},
- 	{"NAND 32MiB 1,8V 16-bit",	0x45, 512, 32, 0x4000, SP_OPTIONS16},
- 	{"NAND 32MiB 3,3V 16-bit",	0x55, 512, 32, 0x4000, SP_OPTIONS16},
-=20
- 	{"NAND 64MiB 1,8V 8-bit",	0x36, 512, 64, 0x4000, SP_OPTIONS},
- 	{"NAND 64MiB 3,3V 8-bit",	0x76, 512, 64, 0x4000, SP_OPTIONS},
- 	{"NAND 64MiB 1,8V 16-bit",	0x46, 512, 64, 0x4000, SP_OPTIONS16},
- 	{"NAND 64MiB 3,3V 16-bit",	0x56, 512, 64, 0x4000, SP_OPTIONS16},
-=20
- 	{"NAND 128MiB 1,8V 8-bit",	0x78, 512, 128, 0x4000, SP_OPTIONS},
- 	{"NAND 128MiB 1,8V 8-bit",	0x39, 512, 128, 0x4000, SP_OPTIONS},
- 	{"NAND 128MiB 3,3V 8-bit",	0x79, 512, 128, 0x4000, SP_OPTIONS},
- 	{"NAND 128MiB 1,8V 16-bit",	0x72, 512, 128, 0x4000, SP_OPTIONS16},
- 	{"NAND 128MiB 1,8V 16-bit",	0x49, 512, 128, 0x4000, SP_OPTIONS16},
- 	{"NAND 128MiB 3,3V 16-bit",	0x74, 512, 128, 0x4000, SP_OPTIONS16},
- 	{"NAND 128MiB 3,3V 16-bit",	0x59, 512, 128, 0x4000, SP_OPTIONS16},
-=20
- 	{"NAND 256MiB 3,3V 8-bit",	0x71, 512, 256, 0x4000, SP_OPTIONS},
+ /*
+  * The chip ID list:
+  *    name, device ID, page size, chip size in MiB, eraseblock size, opti=
ons
+  *
+  * If page size and eraseblock size are 0, the sizes are taken from the
+  * extended chip ID.
+  */
+ struct nand_flash_dev nand_flash_ids[] =3D {
 -	LEGACY_ID_NAND("NAND 4MiB 5V 8-bit",   0x6B, 512, 4, 0x2000, 0),
 -	LEGACY_ID_NAND("NAND 4MiB 3,3V 8-bit", 0xE3, 512, 4, 0x2000, 0),
 -	LEGACY_ID_NAND("NAND 4MiB 3,3V 8-bit", 0xE5, 512, 4, 0x2000, 0),
 -	LEGACY_ID_NAND("NAND 8MiB 3,3V 8-bit", 0xD6, 512, 8, 0x2000, 0),
 -	LEGACY_ID_NAND("NAND 8MiB 3,3V 8-bit", 0xE6, 512, 8, 0x2000, 0),
++	LEGACY_ID_NAND("NAND 4MiB 5V 8-bit",   0x6B, 512, 4, 0x2000, SP_OPTIONS),
++	LEGACY_ID_NAND("NAND 4MiB 3,3V 8-bit", 0xE3, 512, 4, 0x2000, SP_OPTIONS),
++	LEGACY_ID_NAND("NAND 4MiB 3,3V 8-bit", 0xE5, 512, 4, 0x2000, SP_OPTIONS),
++	LEGACY_ID_NAND("NAND 8MiB 3,3V 8-bit", 0xD6, 512, 8, 0x2000, SP_OPTIONS),
++	LEGACY_ID_NAND("NAND 8MiB 3,3V 8-bit", 0xE6, 512, 8, 0x2000, SP_OPTIONS),
+=20
 -	LEGACY_ID_NAND("NAND 16MiB 1,8V 8-bit",  0x33, 512, 16, 0x4000, 0),
 -	LEGACY_ID_NAND("NAND 16MiB 3,3V 8-bit",  0x73, 512, 16, 0x4000, 0),
 -	LEGACY_ID_NAND("NAND 16MiB 1,8V 16-bit", 0x43, 512, 16, 0x4000, NAND_BUS=
WIDTH_16),
 -	LEGACY_ID_NAND("NAND 16MiB 3,3V 16-bit", 0x53, 512, 16, 0x4000, NAND_BUS=
WIDTH_16),
++	LEGACY_ID_NAND("NAND 16MiB 1,8V 8-bit",  0x33, 512, 16, 0x4000, SP_OPTIO=
NS),
++	LEGACY_ID_NAND("NAND 16MiB 3,3V 8-bit",  0x73, 512, 16, 0x4000, SP_OPTIO=
NS),
++	LEGACY_ID_NAND("NAND 16MiB 1,8V 16-bit", 0x43, 512, 16, 0x4000, SP_OPTIO=
NS16),
++	LEGACY_ID_NAND("NAND 16MiB 3,3V 16-bit", 0x53, 512, 16, 0x4000, SP_OPTIO=
NS16),
+=20
 -	LEGACY_ID_NAND("NAND 32MiB 1,8V 8-bit",  0x35, 512, 32, 0x4000, 0),
 -	LEGACY_ID_NAND("NAND 32MiB 3,3V 8-bit",  0x75, 512, 32, 0x4000, 0),
 -	LEGACY_ID_NAND("NAND 32MiB 1,8V 16-bit", 0x45, 512, 32, 0x4000, NAND_BUS=
WIDTH_16),
 -	LEGACY_ID_NAND("NAND 32MiB 3,3V 16-bit", 0x55, 512, 32, 0x4000, NAND_BUS=
WIDTH_16),
++	LEGACY_ID_NAND("NAND 32MiB 1,8V 8-bit",  0x35, 512, 32, 0x4000, SP_OPTIO=
NS),
++	LEGACY_ID_NAND("NAND 32MiB 3,3V 8-bit",  0x75, 512, 32, 0x4000, SP_OPTIO=
NS),
++	LEGACY_ID_NAND("NAND 32MiB 1,8V 16-bit", 0x45, 512, 32, 0x4000, SP_OPTIO=
NS16),
++	LEGACY_ID_NAND("NAND 32MiB 3,3V 16-bit", 0x55, 512, 32, 0x4000, SP_OPTIO=
NS16),
+=20
 -	LEGACY_ID_NAND("NAND 64MiB 1,8V 8-bit",  0x36, 512, 64, 0x4000, 0),
 -	LEGACY_ID_NAND("NAND 64MiB 3,3V 8-bit",  0x76, 512, 64, 0x4000, 0),
 -	LEGACY_ID_NAND("NAND 64MiB 1,8V 16-bit", 0x46, 512, 64, 0x4000, NAND_BUS=
WIDTH_16),
 -	LEGACY_ID_NAND("NAND 64MiB 3,3V 16-bit", 0x56, 512, 64, 0x4000, NAND_BUS=
WIDTH_16),
++	LEGACY_ID_NAND("NAND 64MiB 1,8V 8-bit",  0x36, 512, 64, 0x4000, SP_OPTIO=
NS),
++	LEGACY_ID_NAND("NAND 64MiB 3,3V 8-bit",  0x76, 512, 64, 0x4000, SP_OPTIO=
NS),
++	LEGACY_ID_NAND("NAND 64MiB 1,8V 16-bit", 0x46, 512, 64, 0x4000, SP_OPTIO=
NS16),
++	LEGACY_ID_NAND("NAND 64MiB 3,3V 16-bit", 0x56, 512, 64, 0x4000, SP_OPTIO=
NS16),
+=20
 -	LEGACY_ID_NAND("NAND 128MiB 1,8V 8-bit",  0x78, 512, 128, 0x4000, 0),
 -	LEGACY_ID_NAND("NAND 128MiB 1,8V 8-bit",  0x39, 512, 128, 0x4000, 0),
 -	LEGACY_ID_NAND("NAND 128MiB 3,3V 8-bit",  0x79, 512, 128, 0x4000, 0),
 -	LEGACY_ID_NAND("NAND 128MiB 1,8V 16-bit", 0x72, 512, 128, 0x4000, NAND_B=
USWIDTH_16),
 -	LEGACY_ID_NAND("NAND 128MiB 1,8V 16-bit", 0x49, 512, 128, 0x4000, NAND_B=
USWIDTH_16),
 -	LEGACY_ID_NAND("NAND 128MiB 3,3V 16-bit", 0x74, 512, 128, 0x4000, NAND_B=
USWIDTH_16),
 -	LEGACY_ID_NAND("NAND 128MiB 3,3V 16-bit", 0x59, 512, 128, 0x4000, NAND_B=
USWIDTH_16),
++	LEGACY_ID_NAND("NAND 128MiB 1,8V 8-bit",  0x78, 512, 128, 0x4000, SP_OPT=
IONS),
++	LEGACY_ID_NAND("NAND 128MiB 1,8V 8-bit",  0x39, 512, 128, 0x4000, SP_OPT=
IONS),
++	LEGACY_ID_NAND("NAND 128MiB 3,3V 8-bit",  0x79, 512, 128, 0x4000, SP_OPT=
IONS),
++	LEGACY_ID_NAND("NAND 128MiB 1,8V 16-bit", 0x72, 512, 128, 0x4000, SP_OPT=
IONS16),
++	LEGACY_ID_NAND("NAND 128MiB 1,8V 16-bit", 0x49, 512, 128, 0x4000, SP_OPT=
IONS16),
++	LEGACY_ID_NAND("NAND 128MiB 3,3V 16-bit", 0x74, 512, 128, 0x4000, SP_OPT=
IONS16),
++	LEGACY_ID_NAND("NAND 128MiB 3,3V 16-bit", 0x59, 512, 128, 0x4000, SP_OPT=
IONS16),
+=20
 -	LEGACY_ID_NAND("NAND 256MiB 3,3V 8-bit", 0x71, 512, 256, 0x4000, 0),
++	LEGACY_ID_NAND("NAND 256MiB 3,3V 8-bit", 0x71, 512, 256, 0x4000, SP_OPTI=
ONS),
 =20
  	/*
- 	 * These are the new chips with large page size. The pagesize and the
- 	 * erasesize is determined from the extended id bytes
+ 	 * These are the new chips with large page size. Their page size and
+ 	 * eraseblock size are determined from the extended ID bytes.
  	 */
- #define LP_OPTIONS NAND_SAMSUNG_LP_OPTIONS
- #define LP_OPTIONS16 (LP_OPTIONS | NAND_BUSWIDTH_16)
 =20
  	/* 512 Megabit */
- 	{"NAND 64MiB 1,8V 8-bit",	0xA2, 0,  64, 0, LP_OPTIONS},
- 	{"NAND 64MiB 1,8V 8-bit",	0xA0, 0,  64, 0, LP_OPTIONS},
- 	{"NAND 64MiB 3,3V 8-bit",	0xF2, 0,  64, 0, LP_OPTIONS},
- 	{"NAND 64MiB 3,3V 8-bit",	0xD0, 0,  64, 0, LP_OPTIONS},
- 	{"NAND 64MiB 3,3V 8-bit",	0xF0, 0,  64, 0, LP_OPTIONS},
- 	{"NAND 64MiB 1,8V 16-bit",	0xB2, 0,  64, 0, LP_OPTIONS16},
- 	{"NAND 64MiB 1,8V 16-bit",	0xB0, 0,  64, 0, LP_OPTIONS16},
- 	{"NAND 64MiB 3,3V 16-bit",	0xC2, 0,  64, 0, LP_OPTIONS16},
- 	{"NAND 64MiB 3,3V 16-bit",	0xC0, 0,  64, 0, LP_OPTIONS16},
+ 	EXTENDED_ID_NAND("NAND 64MiB 1,8V 8-bit",  0xA2,  64, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 64MiB 1,8V 8-bit",  0xA0,  64, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 64MiB 3,3V 8-bit",  0xF2,  64, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 64MiB 3,3V 8-bit",  0xD0,  64, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 64MiB 3,3V 8-bit",  0xF0,  64, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 64MiB 1,8V 16-bit", 0xB2,  64, LP_OPTIONS16),
+ 	EXTENDED_ID_NAND("NAND 64MiB 1,8V 16-bit", 0xB0,  64, LP_OPTIONS16),
+ 	EXTENDED_ID_NAND("NAND 64MiB 3,3V 16-bit", 0xC2,  64, LP_OPTIONS16),
+ 	EXTENDED_ID_NAND("NAND 64MiB 3,3V 16-bit", 0xC0,  64, LP_OPTIONS16),
 =20
  	/* 1 Gigabit */
- 	{"NAND 128MiB 1,8V 8-bit",	0xA1, 0, 128, 0, LP_OPTIONS},
- 	{"NAND 128MiB 3,3V 8-bit",	0xF1, 0, 128, 0, LP_OPTIONS},
- 	{"NAND 128MiB 3,3V 8-bit",	0xD1, 0, 128, 0, LP_OPTIONS},
- 	{"NAND 128MiB 1,8V 16-bit",	0xB1, 0, 128, 0, LP_OPTIONS16},
- 	{"NAND 128MiB 3,3V 16-bit",	0xC1, 0, 128, 0, LP_OPTIONS16},
- 	{"NAND 128MiB 1,8V 16-bit",     0xAD, 0, 128, 0, LP_OPTIONS16},
+ 	EXTENDED_ID_NAND("NAND 128MiB 1,8V 8-bit",  0xA1, 128, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 128MiB 3,3V 8-bit",  0xF1, 128, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 128MiB 3,3V 8-bit",  0xD1, 128, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 128MiB 1,8V 16-bit", 0xB1, 128, LP_OPTIONS16),
+ 	EXTENDED_ID_NAND("NAND 128MiB 3,3V 16-bit", 0xC1, 128, LP_OPTIONS16),
+ 	EXTENDED_ID_NAND("NAND 128MiB 1,8V 16-bit", 0xAD, 128, LP_OPTIONS16),
 =20
  	/* 2 Gigabit */
- 	{"NAND 256MiB 1,8V 8-bit",	0xAA, 0, 256, 0, LP_OPTIONS},
- 	{"NAND 256MiB 3,3V 8-bit",	0xDA, 0, 256, 0, LP_OPTIONS},
- 	{"NAND 256MiB 1,8V 16-bit",	0xBA, 0, 256, 0, LP_OPTIONS16},
- 	{"NAND 256MiB 3,3V 16-bit",	0xCA, 0, 256, 0, LP_OPTIONS16},
+ 	EXTENDED_ID_NAND("NAND 256MiB 1,8V 8-bit",  0xAA, 256, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 256MiB 3,3V 8-bit",  0xDA, 256, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 256MiB 1,8V 16-bit", 0xBA, 256, LP_OPTIONS16),
+ 	EXTENDED_ID_NAND("NAND 256MiB 3,3V 16-bit", 0xCA, 256, LP_OPTIONS16),
 =20
  	/* 4 Gigabit */
- 	{"NAND 512MiB 1,8V 8-bit",	0xAC, 0, 512, 0, LP_OPTIONS},
- 	{"NAND 512MiB 3,3V 8-bit",	0xDC, 0, 512, 0, LP_OPTIONS},
- 	{"NAND 512MiB 1,8V 16-bit",	0xBC, 0, 512, 0, LP_OPTIONS16},
- 	{"NAND 512MiB 3,3V 16-bit",	0xCC, 0, 512, 0, LP_OPTIONS16},
+ 	EXTENDED_ID_NAND("NAND 512MiB 1,8V 8-bit",  0xAC, 512, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 512MiB 3,3V 8-bit",  0xDC, 512, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 512MiB 1,8V 16-bit", 0xBC, 512, LP_OPTIONS16),
+ 	EXTENDED_ID_NAND("NAND 512MiB 3,3V 16-bit", 0xCC, 512, LP_OPTIONS16),
 =20
  	/* 8 Gigabit */
- 	{"NAND 1GiB 1,8V 8-bit",	0xA3, 0, 1024, 0, LP_OPTIONS},
- 	{"NAND 1GiB 3,3V 8-bit",	0xD3, 0, 1024, 0, LP_OPTIONS},
- 	{"NAND 1GiB 1,8V 16-bit",	0xB3, 0, 1024, 0, LP_OPTIONS16},
- 	{"NAND 1GiB 3,3V 16-bit",	0xC3, 0, 1024, 0, LP_OPTIONS16},
+ 	EXTENDED_ID_NAND("NAND 1GiB 1,8V 8-bit",  0xA3, 1024, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 1GiB 3,3V 8-bit",  0xD3, 1024, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 1GiB 1,8V 16-bit", 0xB3, 1024, LP_OPTIONS16),
+ 	EXTENDED_ID_NAND("NAND 1GiB 3,3V 16-bit", 0xC3, 1024, LP_OPTIONS16),
 =20
  	/* 16 Gigabit */
- 	{"NAND 2GiB 1,8V 8-bit",	0xA5, 0, 2048, 0, LP_OPTIONS},
- 	{"NAND 2GiB 3,3V 8-bit",	0xD5, 0, 2048, 0, LP_OPTIONS},
- 	{"NAND 2GiB 1,8V 16-bit",	0xB5, 0, 2048, 0, LP_OPTIONS16},
- 	{"NAND 2GiB 3,3V 16-bit",	0xC5, 0, 2048, 0, LP_OPTIONS16},
+ 	EXTENDED_ID_NAND("NAND 2GiB 1,8V 8-bit",  0xA5, 2048, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 2GiB 3,3V 8-bit",  0xD5, 2048, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 2GiB 1,8V 16-bit", 0xB5, 2048, LP_OPTIONS16),
+ 	EXTENDED_ID_NAND("NAND 2GiB 3,3V 16-bit", 0xC5, 2048, LP_OPTIONS16),
 =20
  	/* 32 Gigabit */
- 	{"NAND 4GiB 1,8V 8-bit",	0xA7, 0, 4096, 0, LP_OPTIONS},
- 	{"NAND 4GiB 3,3V 8-bit",	0xD7, 0, 4096, 0, LP_OPTIONS},
- 	{"NAND 4GiB 1,8V 16-bit",	0xB7, 0, 4096, 0, LP_OPTIONS16},
- 	{"NAND 4GiB 3,3V 16-bit",	0xC7, 0, 4096, 0, LP_OPTIONS16},
+ 	EXTENDED_ID_NAND("NAND 4GiB 1,8V 8-bit",  0xA7, 4096, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 4GiB 3,3V 8-bit",  0xD7, 4096, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 4GiB 1,8V 16-bit", 0xB7, 4096, LP_OPTIONS16),
+ 	EXTENDED_ID_NAND("NAND 4GiB 3,3V 16-bit", 0xC7, 4096, LP_OPTIONS16),
 =20
  	/* 64 Gigabit */
- 	{"NAND 8GiB 1,8V 8-bit",	0xAE, 0, 8192, 0, LP_OPTIONS},
- 	{"NAND 8GiB 3,3V 8-bit",	0xDE, 0, 8192, 0, LP_OPTIONS},
- 	{"NAND 8GiB 1,8V 16-bit",	0xBE, 0, 8192, 0, LP_OPTIONS16},
- 	{"NAND 8GiB 3,3V 16-bit",	0xCE, 0, 8192, 0, LP_OPTIONS16},
+ 	EXTENDED_ID_NAND("NAND 8GiB 1,8V 8-bit",  0xAE, 8192, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 8GiB 3,3V 8-bit",  0xDE, 8192, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 8GiB 1,8V 16-bit", 0xBE, 8192, LP_OPTIONS16),
+ 	EXTENDED_ID_NAND("NAND 8GiB 3,3V 16-bit", 0xCE, 8192, LP_OPTIONS16),
 =20
  	/* 128 Gigabit */
- 	{"NAND 16GiB 1,8V 8-bit",	0x1A, 0, 16384, 0, LP_OPTIONS},
- 	{"NAND 16GiB 3,3V 8-bit",	0x3A, 0, 16384, 0, LP_OPTIONS},
- 	{"NAND 16GiB 1,8V 16-bit",	0x2A, 0, 16384, 0, LP_OPTIONS16},
- 	{"NAND 16GiB 3,3V 16-bit",	0x4A, 0, 16384, 0, LP_OPTIONS16},
+ 	EXTENDED_ID_NAND("NAND 16GiB 1,8V 8-bit",  0x1A, 16384, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 16GiB 3,3V 8-bit",  0x3A, 16384, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 16GiB 1,8V 16-bit", 0x2A, 16384, LP_OPTIONS16),
+ 	EXTENDED_ID_NAND("NAND 16GiB 3,3V 16-bit", 0x4A, 16384, LP_OPTIONS16),
 =20
  	/* 256 Gigabit */
- 	{"NAND 32GiB 1,8V 8-bit",	0x1C, 0, 32768, 0, LP_OPTIONS},
- 	{"NAND 32GiB 3,3V 8-bit",	0x3C, 0, 32768, 0, LP_OPTIONS},
- 	{"NAND 32GiB 1,8V 16-bit",	0x2C, 0, 32768, 0, LP_OPTIONS16},
- 	{"NAND 32GiB 3,3V 16-bit",	0x4C, 0, 32768, 0, LP_OPTIONS16},
+ 	EXTENDED_ID_NAND("NAND 32GiB 1,8V 8-bit",  0x1C, 32768, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 32GiB 3,3V 8-bit",  0x3C, 32768, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 32GiB 1,8V 16-bit", 0x2C, 32768, LP_OPTIONS16),
+ 	EXTENDED_ID_NAND("NAND 32GiB 3,3V 16-bit", 0x4C, 32768, LP_OPTIONS16),
 =20
  	/* 512 Gigabit */
- 	{"NAND 64GiB 1,8V 8-bit",	0x1E, 0, 65536, 0, LP_OPTIONS},
- 	{"NAND 64GiB 3,3V 8-bit",	0x3E, 0, 65536, 0, LP_OPTIONS},
- 	{"NAND 64GiB 1,8V 16-bit",	0x2E, 0, 65536, 0, LP_OPTIONS16},
- 	{"NAND 64GiB 3,3V 16-bit",	0x4E, 0, 65536, 0, LP_OPTIONS16},
+ 	EXTENDED_ID_NAND("NAND 64GiB 1,8V 8-bit",  0x1E, 65536, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 64GiB 3,3V 8-bit",  0x3E, 65536, LP_OPTIONS),
+ 	EXTENDED_ID_NAND("NAND 64GiB 1,8V 16-bit", 0x2E, 65536, LP_OPTIONS16),
+ 	EXTENDED_ID_NAND("NAND 64GiB 3,3V 16-bit", 0x4E, 65536, LP_OPTIONS16),
 =20
- 	/*
- 	 * Renesas AND 1 Gigabit. Those chips do not support extended id and
- 	 * have a strange page/block layout !  The chosen minimum erasesize is
- 	 * 4 * 2 * 2048 =3D 16384 Byte, as those chips have an array of 4 page
- 	 * planes 1 block =3D 2 pages, but due to plane arrangement the blocks
- 	 * 0-3 consists of page 0 + 4,1 + 5, 2 + 6, 3 + 7 Anyway JFFS2 would
- 	 * increase the eraseblock size so we chose a combined one which can be
- 	 * erased in one go There are more speed improvements for reads and
- 	 * writes possible, but not implemented now
- 	 */
- 	{"AND 128MiB 3,3V 8-bit",	0x01, 2048, 128, 0x4000,
- 	 NAND_IS_AND | NAND_4PAGE_ARRAY | BBT_AUTO_REFRESH},
-=20
- 	{NULL,}
+ 	{NULL}
  };
 =20
- /*
- *	Manufacturer ID list
- */
+ /* Manufacturer IDs */
  struct nand_manufacturers nand_manuf_ids[] =3D {
  	{NAND_MFR_TOSHIBA, "Toshiba"},
  	{NAND_MFR_SAMSUNG, "Samsung"},

--Signature=_Fri__15_Mar_2013_11_53_04_+1100_1RbheZF3LGH+_SyU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRQnDwAAoJEECxmPOUX5FEtPAP/2QkkDonba9Oxt/CgDJdbBKe
Wc5kB4FYLg+GBIGU7Ew10Grt4a4mthenU0ckX4d8h1Ps0oilcJaLK5e4IhzQiJoz
4VrPKWz8t0U9JlyQSQXdyV1rcU07eSVFqSv/qXLjDynLbSx9mqxulaaX10dI4EwZ
5/bdYq081OK4NJVSMMDz8+uH+fcsnaTUtvTLTsQzpbhXFnbcuGDdDNhII0biiufA
Qhgs+e6DGoqI1k1woFP0em18/hbcnHF+WmRyzNqulNY+lNfBvn70js7j6m+rheN9
+EBoyTU0/c7KUJejuzU+q8Tuq7rtYtWS68tRHmgK81YXb1Db787PNxOH3s0s3O5e
SIIwVURqg7ksLTC+MuiKJR04BOUmzvxPlyJhUC2aBQV6zFvM2LSy+z2No48f/1JS
mb/CtIcSSxCWrLNp041DAXlglaR6jpmxookGutb2sHib7fVSz/giQa3E/918Dujx
exdMCzkvEDYaoR7SRF+iA2CBgQ9s+BpIPr2aghhsrgoZfqi65XaeK96hJO9b15bK
EkBrNJdME9ZmCz9CtaBTPDFCF0kr5uLfzAmlMkOp8EPJOIPuEO+2rSseSfJQAnhc
1P06RQvW8iVyWQGMIlblCIOljKiYDGWCBCVMCWV6mTCeJlN6b+2zew0ivf6HKAtU
7bZuGhuktPEwyGErK057
=EFQG
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Mar_2013_11_53_04_+1100_1RbheZF3LGH+_SyU--
