Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3H0BQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:16:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab3H0BHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Holger Freyther <holger@freyther.de>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@linaro.org>
Subject: [ 43/74] ARM: davinci: nand: specify ecc strength
Date: Mon, 26 Aug 2013 18:08:41 -0700
Message-Id: <20130827010433.413365317@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-davinci/board-dm355-leopard.c |    1 +
 arch/arm/mach-davinci/board-dm644x-evm.c    |    1 +
 arch/arm/mach-davinci/board-dm646x-evm.c    |    1 +
 arch/arm/mach-davinci/board-neuros-osd2.c   |    1 +
 4 files changed, 4 insertions(+)

--- a/arch/arm/mach-davinci/board-dm355-leopard.c
+++ b/arch/arm/mach-davinci/board-dm355-leopard.c
@@ -75,6 +75,7 @@ static struct davinci_nand_pdata davinci
 	.parts			= davinci_nand_partitions,
 	.nr_parts		= ARRAY_SIZE(davinci_nand_partitions),
 	.ecc_mode		= NAND_ECC_HW_SYNDROME,
+	.ecc_bits		= 4,
 	.bbt_options		= NAND_BBT_USE_FLASH,
 };
 
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -153,6 +153,7 @@ static struct davinci_nand_pdata davinci
 	.parts		= davinci_evm_nandflash_partition,
 	.nr_parts	= ARRAY_SIZE(davinci_evm_nandflash_partition),
 	.ecc_mode	= NAND_ECC_HW,
+	.ecc_bits	= 1,
 	.bbt_options	= NAND_BBT_USE_FLASH,
 	.timing		= &davinci_evm_nandflash_timing,
 };
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -90,6 +90,7 @@ static struct davinci_nand_pdata davinci
 	.parts			= davinci_nand_partitions,
 	.nr_parts		= ARRAY_SIZE(davinci_nand_partitions),
 	.ecc_mode		= NAND_ECC_HW,
+	.ecc_bits		= 1,
 	.options		= 0,
 };
 
--- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -88,6 +88,7 @@ static struct davinci_nand_pdata davinci
 	.parts		= davinci_ntosd2_nandflash_partition,
 	.nr_parts	= ARRAY_SIZE(davinci_ntosd2_nandflash_partition),
 	.ecc_mode	= NAND_ECC_HW,
+	.ecc_bits	= 1,
 	.bbt_options	= NAND_BBT_USE_FLASH,
 };
 


