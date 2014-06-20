Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967539AbaFTMiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 08:38:21 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:39403 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967236AbaFTMhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 08:37:46 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-sh@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 3/4] sh: dma: Use defines instead of hardcoded numbers
Date: Fri, 20 Jun 2014 14:37:40 +0200
Message-Id: <1403267861-15609-4-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403267861-15609-1-git-send-email-geert+renesas@glider.be>
References: <1403267861-15609-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/sh/drivers/dma/dma-sh.c           |  2 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c | 24 ++++++-------
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c | 48 ++++++++++++-------------
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c | 64 +++++++++++++++++-----------------
 4 files changed, 69 insertions(+), 69 deletions(-)

diff --git a/arch/sh/drivers/dma/dma-sh.c b/arch/sh/drivers/dma/dma-sh.c
index b22565623142..afde2a7d3eb3 100644
--- a/arch/sh/drivers/dma/dma-sh.c
+++ b/arch/sh/drivers/dma/dma-sh.c
@@ -25,7 +25,7 @@
  * Define the default configuration for dual address memory-memory transfer.
  * The 0x400 value represents auto-request, external->external.
  */
-#define RS_DUAL	(DM_INC | SM_INC | 0x400 | TS_INDEX2VAL(XMIT_SZ_32BIT))
+#define RS_DUAL	(DM_INC | SM_INC | RS_AUTO | TS_INDEX2VAL(XMIT_SZ_32BIT))
 
 static unsigned long dma_find_base(unsigned int chan)
 {
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c b/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
index 57f83a92a505..7aa733307afc 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
@@ -30,62 +30,62 @@ static const struct sh_dmae_slave_config sh7722_dmae_slaves[] = {
 	{
 		.slave_id	= SHDMA_SLAVE_SCIF0_TX,
 		.addr		= 0xffe0000c,
-		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.chcr		= DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x21,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SCIF0_RX,
 		.addr		= 0xffe00014,
-		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.chcr		= DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x22,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SCIF1_TX,
 		.addr		= 0xffe1000c,
-		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.chcr		= DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x25,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SCIF1_RX,
 		.addr		= 0xffe10014,
-		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.chcr		= DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x26,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SCIF2_TX,
 		.addr		= 0xffe2000c,
-		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.chcr		= DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x29,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SCIF2_RX,
 		.addr		= 0xffe20014,
-		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.chcr		= DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x2a,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SIUA_TX,
 		.addr		= 0xa454c098,
-		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_32BIT),
+		.chcr		= DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL(XMIT_SZ_32BIT),
 		.mid_rid	= 0xb1,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SIUA_RX,
 		.addr		= 0xa454c090,
-		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_32BIT),
+		.chcr		= DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL(XMIT_SZ_32BIT),
 		.mid_rid	= 0xb2,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SIUB_TX,
 		.addr		= 0xa454c09c,
-		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_32BIT),
+		.chcr		= DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL(XMIT_SZ_32BIT),
 		.mid_rid	= 0xb5,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SIUB_RX,
 		.addr		= 0xa454c094,
-		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_32BIT),
+		.chcr		= DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL(XMIT_SZ_32BIT),
 		.mid_rid	= 0xb6,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SDHI0_TX,
 		.addr		= 0x04ce0030,
-		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_16BIT),
+		.chcr		= DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL(XMIT_SZ_16BIT),
 		.mid_rid	= 0xc1,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SDHI0_RX,
 		.addr		= 0x04ce0030,
-		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_16BIT),
+		.chcr		= DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL(XMIT_SZ_16BIT),
 		.mid_rid	= 0xc2,
 	},
 };
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7724.c b/arch/sh/kernel/cpu/sh4a/setup-sh7724.c
index b9e84b1d3aa7..ea5780b3c7f6 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7724.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7724.c
@@ -36,122 +36,122 @@ static const struct sh_dmae_slave_config sh7724_dmae_slaves[] = {
 	{
 		.slave_id	= SHDMA_SLAVE_SCIF0_TX,
 		.addr		= 0xffe0000c,
-		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.chcr		= DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x21,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SCIF0_RX,
 		.addr		= 0xffe00014,
-		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.chcr		= DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x22,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SCIF1_TX,
 		.addr		= 0xffe1000c,
-		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.chcr		= DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x25,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SCIF1_RX,
 		.addr		= 0xffe10014,
-		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.chcr		= DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x26,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SCIF2_TX,
 		.addr		= 0xffe2000c,
-		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.chcr		= DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x29,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SCIF2_RX,
 		.addr		= 0xffe20014,
-		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.chcr		= DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x2a,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SCIF3_TX,
 		.addr		= 0xa4e30020,
-		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.chcr		= DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x2d,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SCIF3_RX,
 		.addr		= 0xa4e30024,
-		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.chcr		= DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x2e,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SCIF4_TX,
 		.addr		= 0xa4e40020,
-		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.chcr		= DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x31,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SCIF4_RX,
 		.addr		= 0xa4e40024,
-		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.chcr		= DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x32,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SCIF5_TX,
 		.addr		= 0xa4e50020,
-		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.chcr		= DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x35,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SCIF5_RX,
 		.addr		= 0xa4e50024,
-		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_8BIT),
+		.chcr		= DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x36,
 	}, {
 		.slave_id	= SHDMA_SLAVE_USB0D0_TX,
 		.addr		= 0xA4D80100,
-		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_32BIT),
+		.chcr		= DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL(XMIT_SZ_32BIT),
 		.mid_rid	= 0x73,
 	}, {
 		.slave_id	= SHDMA_SLAVE_USB0D0_RX,
 		.addr		= 0xA4D80100,
-		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_32BIT),
+		.chcr		= DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL(XMIT_SZ_32BIT),
 		.mid_rid	= 0x73,
 	}, {
 		.slave_id	= SHDMA_SLAVE_USB0D1_TX,
 		.addr		= 0xA4D80120,
-		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_32BIT),
+		.chcr		= DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL(XMIT_SZ_32BIT),
 		.mid_rid	= 0x77,
 	}, {
 		.slave_id	= SHDMA_SLAVE_USB0D1_RX,
 		.addr		= 0xA4D80120,
-		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_32BIT),
+		.chcr		= DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL(XMIT_SZ_32BIT),
 		.mid_rid	= 0x77,
 	}, {
 		.slave_id	= SHDMA_SLAVE_USB1D0_TX,
 		.addr		= 0xA4D90100,
-		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_32BIT),
+		.chcr		= DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL(XMIT_SZ_32BIT),
 		.mid_rid	= 0xab,
 	}, {
 		.slave_id	= SHDMA_SLAVE_USB1D0_RX,
 		.addr		= 0xA4D90100,
-		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_32BIT),
+		.chcr		= DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL(XMIT_SZ_32BIT),
 		.mid_rid	= 0xab,
 	}, {
 		.slave_id	= SHDMA_SLAVE_USB1D1_TX,
 		.addr		= 0xA4D90120,
-		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_32BIT),
+		.chcr		= DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL(XMIT_SZ_32BIT),
 		.mid_rid	= 0xaf,
 	}, {
 		.slave_id	= SHDMA_SLAVE_USB1D1_RX,
 		.addr		= 0xA4D90120,
-		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_32BIT),
+		.chcr		= DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL(XMIT_SZ_32BIT),
 		.mid_rid	= 0xaf,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SDHI0_TX,
 		.addr		= 0x04ce0030,
-		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_16BIT),
+		.chcr		= DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL(XMIT_SZ_16BIT),
 		.mid_rid	= 0xc1,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SDHI0_RX,
 		.addr		= 0x04ce0030,
-		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_16BIT),
+		.chcr		= DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL(XMIT_SZ_16BIT),
 		.mid_rid	= 0xc2,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SDHI1_TX,
 		.addr		= 0x04cf0030,
-		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_16BIT),
+		.chcr		= DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL(XMIT_SZ_16BIT),
 		.mid_rid	= 0xc9,
 	}, {
 		.slave_id	= SHDMA_SLAVE_SDHI1_RX,
 		.addr		= 0x04cf0030,
-		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_16BIT),
+		.chcr		= DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL(XMIT_SZ_16BIT),
 		.mid_rid	= 0xca,
 	},
 };
diff --git a/arch/sh/kernel/cpu/sh4a/setup-sh7757.c b/arch/sh/kernel/cpu/sh4a/setup-sh7757.c
index 7b24ec4b409a..18bcd70cd813 100644
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7757.c
+++ b/arch/sh/kernel/cpu/sh4a/setup-sh7757.c
@@ -123,28 +123,28 @@ static const struct sh_dmae_slave_config sh7757_dmae0_slaves[] = {
 	{
 		.slave_id	= SHDMA_SLAVE_SDHI_TX,
 		.addr		= 0x1fe50030,
-		.chcr		= SM_INC | 0x800 | 0x40000000 |
+		.chcr		= SM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_16BIT),
 		.mid_rid	= 0xc5,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_SDHI_RX,
 		.addr		= 0x1fe50030,
-		.chcr		= DM_INC | 0x800 | 0x40000000 |
+		.chcr		= DM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_16BIT),
 		.mid_rid	= 0xc6,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_MMCIF_TX,
 		.addr		= 0x1fcb0034,
-		.chcr		= SM_INC | 0x800 | 0x40000000 |
+		.chcr		= SM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_32BIT),
 		.mid_rid	= 0xd3,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_MMCIF_RX,
 		.addr		= 0x1fcb0034,
-		.chcr		= DM_INC | 0x800 | 0x40000000 |
+		.chcr		= DM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_32BIT),
 		.mid_rid	= 0xd7,
 	},
@@ -154,56 +154,56 @@ static const struct sh_dmae_slave_config sh7757_dmae1_slaves[] = {
 	{
 		.slave_id	= SHDMA_SLAVE_SCIF2_TX,
 		.addr		= 0x1f4b000c,
-		.chcr		= SM_INC | 0x800 | 0x40000000 |
+		.chcr		= SM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x21,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_SCIF2_RX,
 		.addr		= 0x1f4b0014,
-		.chcr		= DM_INC | 0x800 | 0x40000000 |
+		.chcr		= DM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x22,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_SCIF3_TX,
 		.addr		= 0x1f4c000c,
-		.chcr		= SM_INC | 0x800 | 0x40000000 |
+		.chcr		= SM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x29,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_SCIF3_RX,
 		.addr		= 0x1f4c0014,
-		.chcr		= DM_INC | 0x800 | 0x40000000 |
+		.chcr		= DM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x2a,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_SCIF4_TX,
 		.addr		= 0x1f4d000c,
-		.chcr		= SM_INC | 0x800 | 0x40000000 |
+		.chcr		= SM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x41,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_SCIF4_RX,
 		.addr		= 0x1f4d0014,
-		.chcr		= DM_INC | 0x800 | 0x40000000 |
+		.chcr		= DM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x42,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RSPI_TX,
 		.addr		= 0xfe480004,
-		.chcr		= SM_INC | 0x800 | 0x40000000 |
+		.chcr		= SM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_16BIT),
 		.mid_rid	= 0xc1,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RSPI_RX,
 		.addr		= 0xfe480004,
-		.chcr		= DM_INC | 0x800 | 0x40000000 |
+		.chcr		= DM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_16BIT),
 		.mid_rid	= 0xc2,
 	},
@@ -213,70 +213,70 @@ static const struct sh_dmae_slave_config sh7757_dmae2_slaves[] = {
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC0_TX,
 		.addr		= 0x1e500012,
-		.chcr		= SM_INC | 0x800 | 0x40000000 |
+		.chcr		= SM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x21,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC0_RX,
 		.addr		= 0x1e500013,
-		.chcr		= DM_INC | 0x800 | 0x40000000 |
+		.chcr		= DM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x22,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC1_TX,
 		.addr		= 0x1e510012,
-		.chcr		= SM_INC | 0x800 | 0x40000000 |
+		.chcr		= SM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x29,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC1_RX,
 		.addr		= 0x1e510013,
-		.chcr		= DM_INC | 0x800 | 0x40000000 |
+		.chcr		= DM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x2a,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC2_TX,
 		.addr		= 0x1e520012,
-		.chcr		= SM_INC | 0x800 | 0x40000000 |
+		.chcr		= SM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0xa1,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC2_RX,
 		.addr		= 0x1e520013,
-		.chcr		= DM_INC | 0x800 | 0x40000000 |
+		.chcr		= DM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0xa2,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC3_TX,
 		.addr		= 0x1e530012,
-		.chcr		= SM_INC | 0x800 | 0x40000000 |
+		.chcr		= SM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0xa9,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC3_RX,
 		.addr		= 0x1e530013,
-		.chcr		= DM_INC | 0x800 | 0x40000000 |
+		.chcr		= DM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0xaf,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC4_TX,
 		.addr		= 0x1e540012,
-		.chcr		= SM_INC | 0x800 | 0x40000000 |
+		.chcr		= SM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0xc5,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC4_RX,
 		.addr		= 0x1e540013,
-		.chcr		= DM_INC | 0x800 | 0x40000000 |
+		.chcr		= DM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0xc6,
 	},
@@ -286,70 +286,70 @@ static const struct sh_dmae_slave_config sh7757_dmae3_slaves[] = {
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC5_TX,
 		.addr		= 0x1e550012,
-		.chcr		= SM_INC | 0x800 | 0x40000000 |
+		.chcr		= SM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x21,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC5_RX,
 		.addr		= 0x1e550013,
-		.chcr		= DM_INC | 0x800 | 0x40000000 |
+		.chcr		= DM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x22,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC6_TX,
 		.addr		= 0x1e560012,
-		.chcr		= SM_INC | 0x800 | 0x40000000 |
+		.chcr		= SM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x29,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC6_RX,
 		.addr		= 0x1e560013,
-		.chcr		= DM_INC | 0x800 | 0x40000000 |
+		.chcr		= DM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x2a,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC7_TX,
 		.addr		= 0x1e570012,
-		.chcr		= SM_INC | 0x800 | 0x40000000 |
+		.chcr		= SM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x41,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC7_RX,
 		.addr		= 0x1e570013,
-		.chcr		= DM_INC | 0x800 | 0x40000000 |
+		.chcr		= DM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x42,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC8_TX,
 		.addr		= 0x1e580012,
-		.chcr		= SM_INC | 0x800 | 0x40000000 |
+		.chcr		= SM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x45,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC8_RX,
 		.addr		= 0x1e580013,
-		.chcr		= DM_INC | 0x800 | 0x40000000 |
+		.chcr		= DM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x46,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC9_TX,
 		.addr		= 0x1e590012,
-		.chcr		= SM_INC | 0x800 | 0x40000000 |
+		.chcr		= SM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x51,
 	},
 	{
 		.slave_id	= SHDMA_SLAVE_RIIC9_RX,
 		.addr		= 0x1e590013,
-		.chcr		= DM_INC | 0x800 | 0x40000000 |
+		.chcr		= DM_INC | RS_ERS | 0x40000000 |
 				  TS_INDEX2VAL(XMIT_SZ_8BIT),
 		.mid_rid	= 0x52,
 	},
-- 
1.9.1

