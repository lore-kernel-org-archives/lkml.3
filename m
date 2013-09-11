Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab3IKE6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab3IKE4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:55 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=kk2DYnm9bGUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=LE7sIBoiAygA:10 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=T2h1Z_K7z-JURIdn7sYA:9 a=x2szoZtqnggA:10 a=jZqwMa_AmkcA:10 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042928.851141845@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Holger Freyther <holger@freyther.de>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@linaro.org>
Subject: [220/251] ARM: davinci: nand: specify ecc strength
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0220-ARM-davinci-nand-specify-ecc-strength.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sekhar Nori <nsekhar@ti.com>

[ Upstream commit acd36357edc08649e85ff15dc4ed62353c912eff ]

Starting with kernel v3.5, it is mandatory
to specify ECC strength when using hardware
ECC. Without this, kernel panics with a warning
of the sort:

Driver must set ecc.strength when using hardware ECC
------------[ cut here ]------------
kernel BUG at drivers/mtd/nand/nand_base.c:3519!

Fix this by specifying ECC strength for the boards
which were missing this.

Reported-by: Holger Freyther <holger@freyther.de>
Cc: <stable@vger.kernel.org> #v3.5+
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/mach-davinci/board-dm355-leopard.c |    1 +
 arch/arm/mach-davinci/board-dm644x-evm.c    |    1 +
 arch/arm/mach-davinci/board-dm646x-evm.c    |    1 +
 arch/arm/mach-davinci/board-neuros-osd2.c   |    1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/arm/mach-davinci/board-dm355-leopard.c b/arch/arm/mach-davinci/board-dm355-leopard.c
index 8e77032..eeeb81f 100644
--- a/arch/arm/mach-davinci/board-dm355-leopard.c
+++ b/arch/arm/mach-davinci/board-dm355-leopard.c
@@ -75,6 +75,7 @@ static struct davinci_nand_pdata davinci_nand_data = {
 	.parts			= davinci_nand_partitions,
 	.nr_parts		= ARRAY_SIZE(davinci_nand_partitions),
 	.ecc_mode		= NAND_ECC_HW_SYNDROME,
+	.ecc_bits		= 4,
 	.bbt_options		= NAND_BBT_USE_FLASH,
 };
 
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index d34ed55..87a904f 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -152,6 +152,7 @@ static struct davinci_nand_pdata davinci_evm_nandflash_data = {
 	.parts		= davinci_evm_nandflash_partition,
 	.nr_parts	= ARRAY_SIZE(davinci_evm_nandflash_partition),
 	.ecc_mode	= NAND_ECC_HW,
+	.ecc_bits	= 1,
 	.bbt_options	= NAND_BBT_USE_FLASH,
 	.timing		= &davinci_evm_nandflash_timing,
 };
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index 958679a..5d4b51f 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -89,6 +89,7 @@ static struct davinci_nand_pdata davinci_nand_data = {
 	.parts			= davinci_nand_partitions,
 	.nr_parts		= ARRAY_SIZE(davinci_nand_partitions),
 	.ecc_mode		= NAND_ECC_HW,
+	.ecc_bits		= 1,
 	.options		= 0,
 };
 
diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
index f6b9fc7..58d902a 100644
--- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -88,6 +88,7 @@ static struct davinci_nand_pdata davinci_ntosd2_nandflash_data = {
 	.parts		= davinci_ntosd2_nandflash_partition,
 	.nr_parts	= ARRAY_SIZE(davinci_ntosd2_nandflash_partition),
 	.ecc_mode	= NAND_ECC_HW,
+	.ecc_bits	= 1,
 	.bbt_options	= NAND_BBT_USE_FLASH,
 };
 
-- 
1.7.10.4


