Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaBYKb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:31:58 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:44283 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbaBYKa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:30:28 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v2 01/11] ARM: shmobile: r8a7790: Add MSIOF clocks
Date: Tue, 25 Feb 2014 11:30:09 +0100
Message-Id: <1393324219-3317-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393324219-3317-1-git-send-email-geert@linux-m68k.org>
References: <1393324219-3317-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Add clocks for MSIOF0, 1, 2, and 3.
DEV_ID is 1-based for compatibility with the BSP, as QSPI uses zero.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v2:
  - No changes

 arch/arm/mach-shmobile/clock-r8a7790.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-shmobile/clock-r8a7790.c b/arch/arm/mach-shmobile/clock-r8a7790.c
index 3f93503f5b96..a6089a6ceabd 100644
--- a/arch/arm/mach-shmobile/clock-r8a7790.c
+++ b/arch/arm/mach-shmobile/clock-r8a7790.c
@@ -46,6 +46,7 @@
 #define CPG_BASE	0xe6150000
 #define CPG_LEN		0x1000
 
+#define SMSTPCR0	0xe6150130
 #define SMSTPCR1	0xe6150134
 #define SMSTPCR2	0xe6150138
 #define SMSTPCR3	0xe615013c
@@ -55,6 +56,7 @@
 #define SMSTPCR9	0xe6150994
 #define SMSTPCR10	0xe6150998
 
+#define MSTPSR0		IOMEM(0xe6150030)
 #define MSTPSR1		IOMEM(0xe6150038)
 #define MSTPSR2		IOMEM(0xe6150040)
 #define MSTPSR3		IOMEM(0xe6150048)
@@ -221,8 +223,10 @@ enum {
 	MSTP522,
 	MSTP502, MSTP501,
 	MSTP315, MSTP314, MSTP313, MSTP312, MSTP311, MSTP305, MSTP304,
-	MSTP216, MSTP207, MSTP206, MSTP204, MSTP203, MSTP202,
+	MSTP216, MSTP215, MSTP208, MSTP207, MSTP206, MSTP205, MSTP204, MSTP203,
+	MSTP202,
 	MSTP124,
+	MSTP000,
 	MSTP_NR
 };
 
@@ -283,12 +287,16 @@ static struct clk mstp_clks[MSTP_NR] = {
 	[MSTP305] = SH_CLK_MSTP32_STS(&div6_clks[DIV6_MMC1], SMSTPCR3, 5, MSTPSR3, 0), /* MMC1 */
 	[MSTP304] = SH_CLK_MSTP32_STS(&cp_clk, SMSTPCR3, 4, MSTPSR3, 0), /* TPU0 */
 	[MSTP216] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR2, 16, MSTPSR2, 0), /* SCIFB2 */
+	[MSTP215] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR2, 15, MSTPSR2, 0), /* MSIOF3 */
+	[MSTP208] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR2, 8, MSTPSR2, 0), /* MSIOF1 */
 	[MSTP207] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR2, 7, MSTPSR2, 0), /* SCIFB1 */
 	[MSTP206] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR2, 6, MSTPSR2, 0), /* SCIFB0 */
+	[MSTP205] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR2, 5, MSTPSR2, 0), /* MSIOF2 */
 	[MSTP204] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR2, 4, MSTPSR2, 0), /* SCIFA0 */
 	[MSTP203] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR2, 3, MSTPSR2, 0), /* SCIFA1 */
 	[MSTP202] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR2, 2, MSTPSR2, 0), /* SCIFA2 */
 	[MSTP124] = SH_CLK_MSTP32_STS(&rclk_clk, SMSTPCR1, 24, MSTPSR1, 0), /* CMT0 */
+	[MSTP000] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR0, 0, MSTPSR0, 0), /* MSIOF0 */
 };
 
 static struct clk_lookup lookups[] = {
@@ -363,6 +371,10 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("sh_mmcif.1", &mstp_clks[MSTP305]),
 	CLKDEV_DEV_ID("sh_cmt.0", &mstp_clks[MSTP124]),
 	CLKDEV_DEV_ID("qspi.0", &mstp_clks[MSTP917]),
+	CLKDEV_DEV_ID("spi_r8a7790_msiof.1", &mstp_clks[MSTP000]),
+	CLKDEV_DEV_ID("spi_r8a7790_msiof.2", &mstp_clks[MSTP208]),
+	CLKDEV_DEV_ID("spi_r8a7790_msiof.3", &mstp_clks[MSTP205]),
+	CLKDEV_DEV_ID("spi_r8a7790_msiof.4", &mstp_clks[MSTP215]),
 	CLKDEV_DEV_ID("renesas_usbhs", &mstp_clks[MSTP704]),
 	CLKDEV_DEV_ID("pci-rcar-gen2.0", &mstp_clks[MSTP703]),
 	CLKDEV_DEV_ID("pci-rcar-gen2.1", &mstp_clks[MSTP703]),
-- 
1.7.9.5

