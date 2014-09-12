Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaILNP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:15:27 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:35297 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbaILNPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:15:24 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 3/4] ARM: shmobile: r8a7740 legacy: Add missing INTCA clock for irqpin module
Date: Fri, 12 Sep 2014 15:15:19 +0200
Message-Id: <1410527720-18061-4-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410527720-18061-1-git-send-email-geert+renesas@glider.be>
References: <1410527720-18061-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This clock drives the irqpin controller modules.
Before, it was assumed enabled by the bootloader or reset state.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm/mach-shmobile/clock-r8a7740.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-shmobile/clock-r8a7740.c b/arch/arm/mach-shmobile/clock-r8a7740.c
index 0794f0426e70..6cb1de220612 100644
--- a/arch/arm/mach-shmobile/clock-r8a7740.c
+++ b/arch/arm/mach-shmobile/clock-r8a7740.c
@@ -455,7 +455,7 @@ enum {
 	MSTP128, MSTP127, MSTP125,
 	MSTP116, MSTP111, MSTP100, MSTP117,
 
-	MSTP230,
+	MSTP230, MSTP229,
 	MSTP222,
 	MSTP218, MSTP217, MSTP216, MSTP214,
 	MSTP207, MSTP206, MSTP204, MSTP203, MSTP202, MSTP201, MSTP200,
@@ -479,6 +479,7 @@ static struct clk mstp_clks[MSTP_NR] = {
 	[MSTP100] = SH_CLK_MSTP32(&div4_clks[DIV4_B],	SMSTPCR1,  0, 0), /* LCDC0 */
 
 	[MSTP230] = SH_CLK_MSTP32(&div6_clks[DIV6_SUB],	SMSTPCR2, 30, 0), /* SCIFA6 */
+	[MSTP229] = SH_CLK_MSTP32(&div6_clks[DIV4_HP],	SMSTPCR2, 29, 0), /* INTCA */
 	[MSTP222] = SH_CLK_MSTP32(&div6_clks[DIV6_SUB],	SMSTPCR2, 22, 0), /* SCIFA7 */
 	[MSTP218] = SH_CLK_MSTP32(&div4_clks[DIV4_HP],  SMSTPCR2, 18, 0), /* DMAC1 */
 	[MSTP217] = SH_CLK_MSTP32(&div4_clks[DIV4_HP],  SMSTPCR2, 17, 0), /* DMAC2 */
@@ -575,6 +576,10 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("sh-dma-engine.0",	&mstp_clks[MSTP218]),
 	CLKDEV_DEV_ID("sh-sci.7",		&mstp_clks[MSTP222]),
 	CLKDEV_DEV_ID("e6cd0000.serial",	&mstp_clks[MSTP222]),
+	CLKDEV_DEV_ID("renesas_intc_irqpin.0",	&mstp_clks[MSTP229]),
+	CLKDEV_DEV_ID("renesas_intc_irqpin.1",	&mstp_clks[MSTP229]),
+	CLKDEV_DEV_ID("renesas_intc_irqpin.2",	&mstp_clks[MSTP229]),
+	CLKDEV_DEV_ID("renesas_intc_irqpin.3",	&mstp_clks[MSTP229]),
 	CLKDEV_DEV_ID("sh-sci.6",		&mstp_clks[MSTP230]),
 	CLKDEV_DEV_ID("e6cc0000.serial",	&mstp_clks[MSTP230]),
 
-- 
1.9.1

