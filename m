Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab3COA63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 20:58:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50769 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3COA61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 20:58:27 -0400
Date: Fri, 15 Mar 2013 11:58:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: linux-next: manual merge of the l2-mtd tree with the mtd tree
Message-Id: <20130315115825.6c2b7ad9c48c82640ff9f3b8@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Mar_2013_11_58_25_+1100_6/afGELbzltNfTBa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Mar_2013_11_58_25_+1100_6/afGELbzltNfTBa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

Today's linux-next merge of the l2-mtd tree got a conflict in
include/linux/mtd/nand.h between commit 5bc7c33ca93a ("mtd: nand:
reintroduce NAND_NO_READRDY as NAND_NEED_READRDY") from the mtd tree and
commit edac3311879c ("mtd: nand: remove AG-AND support") from the l2-mtd
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/mtd/nand.h
index ef52d9c,33516eb..0000000
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@@ -165,35 -145,8 +145,15 @@@ typedef enum=20
   */
  /* Buswidth is 16 bit */
  #define NAND_BUSWIDTH_16	0x00000002
- /* Device supports partial programming without padding */
- #define NAND_NO_PADDING		0x00000004
  /* Chip has cache program function */
  #define NAND_CACHEPRG		0x00000008
- /* Chip has copy back function */
- #define NAND_COPYBACK		0x00000010
- /*
-  * AND Chip which has 4 banks and a confusing page / block
-  * assignment. See Renesas datasheet for further information.
-  */
- #define NAND_IS_AND		0x00000020
- /*
-  * Chip has a array of 4 pages which can be read without
-  * additional ready /busy waits.
-  */
- #define NAND_4PAGE_ARRAY	0x00000040
- /*
-  * Chip requires that BBT is periodically rewritten to prevent
-  * bits from adjacent blocks from 'leaking' in altering data.
-  * This happens with the Renesas AG-AND chips, possibly others.
-  */
- #define BBT_AUTO_REFRESH	0x00000080
 +/*
 + * Chip requires ready check on read (for auto-incremented sequential rea=
d).
 + * True only for small page devices; large page devices do not support
 + * autoincrement.
 + */
 +#define NAND_NEED_READRDY	0x00000100
 +
  /* Chip does not allow subpage writes */
  #define NAND_NO_SUBPAGE_WRITE	0x00000200
 =20

--Signature=_Fri__15_Mar_2013_11_58_25_+1100_6/afGELbzltNfTBa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRQnIxAAoJEECxmPOUX5FEje8P/jxyNugx+o8ZzbIS34zayVwB
SXXv/z3U7Cxfs61+sPfei5JalX22eEuNyngAmaY6GuTBml7huY+4/s7CRfQy2fct
S0uBBFcbI2QmIX0fwTJoC9v3/xpJwgtIvYGDwF/b5+7f6p/CqtenJ+EhP/rVZuBB
idDZHVKCngacqQlpPq8eb2ZyRsFOKnRY6IQvBCKlUI9PCzwYSdIUcAaU321FQWsE
nbclNCuZ3Uc535Oy3Y3kL7KzbC2s8h1y44TRvMsQ3Uexdj7dxUHlq3cf23ljAdOH
jwQG7H/zfK58uC+J1NBxZp5eTGeaLwovPpVhyUgfTXRqRBTVJCQmIHN04T35q7jN
nMN1JY6tYvKR2YtU1CMM7M+Xu7pcjVPA/VuOj9YTh+n6qYpA9mVp35VzgsGeGFT1
1HHvFOUtcdRpZ/iDOC1FKZowYkzguY/ERD2kZEbzfVmmb2Dho89BRe8zNwMyQD0l
rwtZBQaaV6b4UY7RjTgFYdsQp8Y9WwDn5J2Z6G79viJAFdfHi9+zWliunsg2YCqE
fLZJOmG1guqqeTIPhfbNZCpdXU1w5topTx8tTrUqRm2CZC0DRTrFxopTVCRFaRPp
zamJ7D08Uyl6rvDVCYp6u0I9iT35nUI1J3WzurtkLzT58qNFtqdOSq+JQO1KG6sh
LyHhC3nAKKK2AFJyplSW
=wxd9
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Mar_2013_11_58_25_+1100_6/afGELbzltNfTBa--
