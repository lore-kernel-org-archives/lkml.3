Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaAXMxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:53:03 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:59477 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbaAXMuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:50:09 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v3 08/15] ARM: shmobile: r8a7791 clock: add QSPI clocks
Date: Fri, 24 Jan 2014 13:49:44 +0100
Message-Id: <1390567791-8988-9-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390567791-8988-1-git-send-email-geert@linux-m68k.org>
References: <1390567791-8988-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

The QSPI clock divider value depends on the MD1, MD2, and MD3 mode
switches.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
v3:
  - No changes
v2:
  - No changes

 arch/arm/mach-shmobile/clock-r8a7791.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/mach-shmobile/clock-r8a7791.c b/arch/arm/mach-shmobile/clock-r8a7791.c
index 0f4f500e6e1c..fc9248d0b9d0 100644
--- a/arch/arm/mach-shmobile/clock-r8a7791.c
+++ b/arch/arm/mach-shmobile/clock-r8a7791.c
@@ -101,6 +101,7 @@ static struct clk main_clk = {
  */
 SH_FIXED_RATIO_CLK_SET(pll1_clk,		main_clk,	1, 1);
 SH_FIXED_RATIO_CLK_SET(pll3_clk,		main_clk,	1, 1);
+SH_FIXED_RATIO_CLK_SET(qspi_clk,		pll1_clk,	1, 1);
 
 /* fixed ratio clock */
 SH_FIXED_RATIO_CLK_SET(extal_div2_clk,		extal_clk,	1, 2);
@@ -124,6 +125,7 @@ static struct clk *main_clks[] = {
 	&pll3_clk,
 	&hp_clk,
 	&p_clk,
+	&qspi_clk,
 	&rclk_clk,
 	&mp_clk,
 	&cp_clk,
@@ -135,6 +137,7 @@ static struct clk *main_clks[] = {
 /* MSTP */
 enum {
 	MSTP931, MSTP930, MSTP929, MSTP928, MSTP927, MSTP925,
+	MSTP917,
 	MSTP815, MSTP814,
 	MSTP813,
 	MSTP811, MSTP810, MSTP809,
@@ -154,6 +157,7 @@ static struct clk mstp_clks[MSTP_NR] = {
 	[MSTP928] = SH_CLK_MSTP32_STS(&p_clk, SMSTPCR9, 28, MSTPSR9, 0), /* I2C3 */
 	[MSTP927] = SH_CLK_MSTP32_STS(&p_clk, SMSTPCR9, 27, MSTPSR9, 0), /* I2C4 */
 	[MSTP925] = SH_CLK_MSTP32_STS(&p_clk, SMSTPCR9, 25, MSTPSR9, 0), /* I2C5 */
+	[MSTP917] = SH_CLK_MSTP32_STS(&qspi_clk, SMSTPCR9, 17, MSTPSR9, 0), /* QSPI */
 	[MSTP815] = SH_CLK_MSTP32_STS(&zs_clk, SMSTPCR8, 15, MSTPSR8, 0), /* SATA0 */
 	[MSTP814] = SH_CLK_MSTP32_STS(&zs_clk, SMSTPCR8, 14, MSTPSR8, 0), /* SATA1 */
 	[MSTP813] = SH_CLK_MSTP32_STS(&p_clk, SMSTPCR8, 13, MSTPSR8, 0), /* Ether */
@@ -195,6 +199,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_CON_ID("zs",		&zs_clk),
 	CLKDEV_CON_ID("hp",		&hp_clk),
 	CLKDEV_CON_ID("p",		&p_clk),
+	CLKDEV_CON_ID("qspi",		&qspi_clk),
 	CLKDEV_CON_ID("rclk",		&rclk_clk),
 	CLKDEV_CON_ID("mp",		&mp_clk),
 	CLKDEV_CON_ID("cp",		&cp_clk),
@@ -220,6 +225,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("sh-sci.13", &mstp_clks[MSTP1106]), /* SCIFA4 */
 	CLKDEV_DEV_ID("sh-sci.14", &mstp_clks[MSTP1107]), /* SCIFA5 */
 	CLKDEV_DEV_ID("sh_cmt.0", &mstp_clks[MSTP124]),
+	CLKDEV_DEV_ID("qspi.0", &mstp_clks[MSTP917]),
 	CLKDEV_DEV_ID("e61f0000.thermal", &mstp_clks[MSTP522]),
 	CLKDEV_DEV_ID("rcar_thermal", &mstp_clks[MSTP522]),
 	CLKDEV_DEV_ID("i2c-rcar_gen2.0", &mstp_clks[MSTP931]),
@@ -271,6 +277,11 @@ void __init r8a7791_clock_init(void)
 		break;
 	}
 
+	if ((mode & (MD(3) | MD(2) | MD(1))) == MD(2))
+		SH_CLK_SET_RATIO(&qspi_clk_ratio, 1, 16);
+	else
+		SH_CLK_SET_RATIO(&qspi_clk_ratio, 1, 20);
+
 	for (k = 0; !ret && (k < ARRAY_SIZE(main_clks)); k++)
 		ret = clk_register(main_clks[k]);
 
-- 
1.7.9.5

