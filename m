Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbaAXMyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:54:18 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:39142 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaAXMuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:50:08 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v4 01/15] ARM: shmobile: r7s72100 clock: Add RSPI clocks
Date: Fri, 24 Jan 2014 13:49:37 +0100
Message-Id: <1390567791-8988-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390567791-8988-1-git-send-email-geert@linux-m68k.org>
References: <1390567791-8988-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v4:
  - The platform device basename was changed from "rspi" to "rspi-rz"
v3:
  - No changes
v2:
  - Correct platform device names ("rspi%u" -> "rspi.%u")

 arch/arm/mach-shmobile/clock-r7s72100.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-shmobile/clock-r7s72100.c b/arch/arm/mach-shmobile/clock-r7s72100.c
index 0242ca5f499a..bf15b63c3d5a 100644
--- a/arch/arm/mach-shmobile/clock-r7s72100.c
+++ b/arch/arm/mach-shmobile/clock-r7s72100.c
@@ -22,13 +22,15 @@
 #include <mach/common.h>
 #include <mach/r7s72100.h>
 
-/* registers */
+/* Frequency Control Registers */
 #define FRQCR		0xfcfe0010
 #define FRQCR2		0xfcfe0014
+/* Standby Control Registers */
 #define STBCR3		0xfcfe0420
 #define STBCR4		0xfcfe0424
 #define STBCR7		0xfcfe0430
 #define STBCR9		0xfcfe0438
+#define STBCR10		0xfcfe043c
 
 #define PLL_RATE 30
 
@@ -146,12 +148,20 @@ struct clk div4_clks[DIV4_NR] = {
 					| CLK_ENABLE_ON_INIT),
 };
 
-enum {	MSTP97, MSTP96, MSTP95, MSTP94,
+enum {
+	MSTP107, MSTP106, MSTP105, MSTP104, MSTP103,
+	MSTP97, MSTP96, MSTP95, MSTP94,
 	MSTP74,
 	MSTP47, MSTP46, MSTP45, MSTP44, MSTP43, MSTP42, MSTP41, MSTP40,
-	MSTP33,	MSTP_NR };
+	MSTP33,	MSTP_NR
+};
 
 static struct clk mstp_clks[MSTP_NR] = {
+	[MSTP107] = SH_CLK_MSTP8(&peripheral1_clk, STBCR10, 7, 0), /* RSPI0 */
+	[MSTP106] = SH_CLK_MSTP8(&peripheral1_clk, STBCR10, 6, 0), /* RSPI1 */
+	[MSTP105] = SH_CLK_MSTP8(&peripheral1_clk, STBCR10, 5, 0), /* RSPI2 */
+	[MSTP104] = SH_CLK_MSTP8(&peripheral1_clk, STBCR10, 4, 0), /* RSPI3 */
+	[MSTP103] = SH_CLK_MSTP8(&peripheral1_clk, STBCR10, 3, 0), /* RSPI4 */
 	[MSTP97] = SH_CLK_MSTP8(&peripheral0_clk, STBCR9, 7, 0), /* RIIC0 */
 	[MSTP96] = SH_CLK_MSTP8(&peripheral0_clk, STBCR9, 6, 0), /* RIIC1 */
 	[MSTP95] = SH_CLK_MSTP8(&peripheral0_clk, STBCR9, 5, 0), /* RIIC2 */
@@ -179,6 +189,11 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_CON_ID("cpu_clk", &div4_clks[DIV4_I]),
 
 	/* MSTP clocks */
+	CLKDEV_DEV_ID("rspi-rz.0", &mstp_clks[MSTP107]),
+	CLKDEV_DEV_ID("rspi-rz.1", &mstp_clks[MSTP106]),
+	CLKDEV_DEV_ID("rspi-rz.2", &mstp_clks[MSTP105]),
+	CLKDEV_DEV_ID("rspi-rz.3", &mstp_clks[MSTP104]),
+	CLKDEV_DEV_ID("rspi-rz.4", &mstp_clks[MSTP103]),
 	CLKDEV_DEV_ID("fcfee000.i2c", &mstp_clks[MSTP97]),
 	CLKDEV_DEV_ID("fcfee400.i2c", &mstp_clks[MSTP96]),
 	CLKDEV_DEV_ID("fcfee800.i2c", &mstp_clks[MSTP95]),
-- 
1.7.9.5

