Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219Ab3ICQbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:31:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46627 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933041Ab3ICQ2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:28:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 43/58] ARM: davinci: nand: specify ecc strength
Date: Tue,  3 Sep 2013 09:23:47 -0700
Message-Id: <1378225442-20654-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sekhar Nori <nsekhar@ti.com>

commit acd36357edc08649e85ff15dc4ed62353c912eff upstream.

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
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-davinci/board-dm355-leopard.c | 1 +
 arch/arm/mach-davinci/board-dm644x-evm.c    | 1 +
 arch/arm/mach-davinci/board-dm646x-evm.c    | 1 +
 arch/arm/mach-davinci/board-neuros-osd2.c   | 1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/arm/mach-davinci/board-dm355-leopard.c b/arch/arm/mach-davinci/board-dm355-leopard.c
index d419545..25cf931 100644
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
index f5e018d..9033279 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -153,6 +153,7 @@ static struct davinci_nand_pdata davinci_evm_nandflash_data = {
 	.parts		= davinci_evm_nandflash_partition,
 	.nr_parts	= ARRAY_SIZE(davinci_evm_nandflash_partition),
 	.ecc_mode	= NAND_ECC_HW,
+	.ecc_bits	= 1,
 	.bbt_options	= NAND_BBT_USE_FLASH,
 	.timing		= &davinci_evm_nandflash_timing,
 };
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index 6e2f163..1331b09 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -90,6 +90,7 @@ static struct davinci_nand_pdata davinci_nand_data = {
 	.parts			= davinci_nand_partitions,
 	.nr_parts		= ARRAY_SIZE(davinci_nand_partitions),
 	.ecc_mode		= NAND_ECC_HW,
+	.ecc_bits		= 1,
 	.options		= 0,
 };
 
diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
index 3e3e3af..c9a2fc5 100644
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
1.8.1.2

