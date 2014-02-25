Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbaBYKec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:34:32 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:59929 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbaBYKaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:30:24 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v2 02/11] ARM: shmobile: r8a7791: Add MSIOF clocks
Date: Tue, 25 Feb 2014 11:30:10 +0100
Message-Id: <1393324219-3317-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393324219-3317-1-git-send-email-geert@linux-m68k.org>
References: <1393324219-3317-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Yoshii <takasi-y@ops.dti.ne.jp>

Add clocks for MSIOF0, 1, and 2.
DEV_ID is 1-based for compatibility with the BSP, as QSPI uses zero.

Signed-off-by: Takashi Yoshii <takasi-y@ops.dti.ne.jp>
[geert] Updated for change from SH_CLK_MSTP32() to SH_CLK_MSTP32_STS()
[geert] Updated for new platform device name
Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v2:
  - No changes

 arch/arm/mach-shmobile/clock-r8a7791.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-shmobile/clock-r8a7791.c b/arch/arm/mach-shmobile/clock-r8a7791.c
index 605fc778e3e2..8e4c12a752b7 100644
--- a/arch/arm/mach-shmobile/clock-r8a7791.c
+++ b/arch/arm/mach-shmobile/clock-r8a7791.c
@@ -59,6 +59,7 @@
 #define SMSTPCR10	0xE6150998
 #define SMSTPCR11	0xE615099C
 
+#define MSTPSR0		IOMEM(0xe6150030)
 #define MSTPSR1		IOMEM(0xe6150038)
 #define MSTPSR2		IOMEM(0xe6150040)
 #define MSTPSR3		IOMEM(0xe6150048)
@@ -179,9 +180,10 @@ enum {
 	MSTP719, MSTP718, MSTP715, MSTP714,
 	MSTP522,
 	MSTP314, MSTP312, MSTP311,
-	MSTP216, MSTP207, MSTP206,
+	MSTP216, MSTP208, MSTP207, MSTP206, MSTP205,
 	MSTP204, MSTP203, MSTP202, MSTP1105, MSTP1106, MSTP1107,
 	MSTP124,
+	MSTP000,
 	MSTP_NR
 };
 
@@ -213,8 +215,10 @@ static struct clk mstp_clks[MSTP_NR] = {
 	[MSTP312] = SH_CLK_MSTP32_STS(&div6_clks[DIV6_SD1], SMSTPCR3, 12, MSTPSR3, 0), /* SDHI1 */
 	[MSTP311] = SH_CLK_MSTP32_STS(&div6_clks[DIV6_SD2], SMSTPCR3, 11, MSTPSR3, 0), /* SDHI2 */
 	[MSTP216] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR2, 16, MSTPSR2, 0), /* SCIFB2 */
+	[MSTP208] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR2, 8, MSTPSR2, 0), /* MSIOF1 */
 	[MSTP207] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR2, 7, MSTPSR2, 0), /* SCIFB1 */
 	[MSTP206] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR2, 6, MSTPSR2, 0), /* SCIFB0 */
+	[MSTP205] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR2, 5, MSTPSR2, 0), /* MSIOF2 */
 	[MSTP204] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR2, 4, MSTPSR2, 0), /* SCIFA0 */
 	[MSTP203] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR2, 3, MSTPSR2, 0), /* SCIFA1 */
 	[MSTP202] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR2, 2, MSTPSR2, 0), /* SCIFA2 */
@@ -222,6 +226,7 @@ static struct clk mstp_clks[MSTP_NR] = {
 	[MSTP1106] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR11, 6, MSTPSR11, 0), /* SCIFA4 */
 	[MSTP1107] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR11, 7, MSTPSR11, 0), /* SCIFA5 */
 	[MSTP124] = SH_CLK_MSTP32_STS(&rclk_clk, SMSTPCR1, 24, MSTPSR1, 0), /* CMT0 */
+	[MSTP000] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR0, 0, MSTPSR0, 0), /* MSIOF0 */
 };
 
 static struct clk_lookup lookups[] = {
@@ -267,6 +272,9 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("sh_mobile_sdhi.2", &mstp_clks[MSTP311]),
 	CLKDEV_DEV_ID("sh_cmt.0", &mstp_clks[MSTP124]),
 	CLKDEV_DEV_ID("qspi.0", &mstp_clks[MSTP917]),
+	CLKDEV_DEV_ID("spi_r8a7791_msiof.1", &mstp_clks[MSTP000]),
+	CLKDEV_DEV_ID("spi_r8a7791_msiof.2", &mstp_clks[MSTP208]),
+	CLKDEV_DEV_ID("spi_r8a7791_msiof.3", &mstp_clks[MSTP205]),
 	CLKDEV_DEV_ID("rcar_thermal", &mstp_clks[MSTP522]),
 	CLKDEV_DEV_ID("i2c-rcar_gen2.0", &mstp_clks[MSTP931]),
 	CLKDEV_DEV_ID("i2c-rcar_gen2.1", &mstp_clks[MSTP930]),
-- 
1.7.9.5

