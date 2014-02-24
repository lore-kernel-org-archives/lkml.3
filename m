Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaBXJaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 04:30:16 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:41059 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaBXJaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 04:30:11 -0500
From: <vladimir.barinov@cogentembedded.com>
To: <linux-sh@vger.kernel.org>
Cc: <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        <magnus.damm@gmail.com>, <horms@verge.net.au>, <gnurou@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kuninori.morimoto.gx@renesas.com>,
        <valentine.barshak@cogentembedded.com>
Subject: [PATCH V5 2/4] ARM: shmobile: r8a7791: Add PCI USB host clock support
Date: Mon, 24 Feb 2014 13:30:02 +0400
Message-Id: <1393234204-24096-3-git-send-email-vladimir.barinov@cogentembedded.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1393234204-24096-1-git-send-email-vladimir.barinov@cogentembedded.com>
References: <1393234204-24096-1-git-send-email-vladimir.barinov@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valentine Barshak <valentine.barshak@cogentembedded.com>

This adds internal PCI USB host clock support to R-Car M2 SoC.

Signed-off-by: Valentine Barshak <valentine.barshak@cogentembedded.com>
Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

Changes in V5:
Changes in V4:
Changes in V3:
* none.

Changes in V2:
* capitalized ARM in the subject;
* rebased on top the latest devel tag.

---
 arch/arm/mach-shmobile/clock-r8a7791.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: build/arch/arm/mach-shmobile/clock-r8a7791.c
===================================================================
--- build.orig/arch/arm/mach-shmobile/clock-r8a7791.c	2014-02-23 21:47:52.582571801 +0400
+++ build/arch/arm/mach-shmobile/clock-r8a7791.c	2014-02-23 21:47:57.446571701 +0400
@@ -177,7 +177,7 @@
 	MSTP811, MSTP810, MSTP809,
 	MSTP726, MSTP724, MSTP723, MSTP721, MSTP720,
 	MSTP719, MSTP718, MSTP715, MSTP714,
-	MSTP704,
+	MSTP704, MSTP703,
 	MSTP522,
 	MSTP314, MSTP312, MSTP311,
 	MSTP216, MSTP207, MSTP206,
@@ -210,6 +210,7 @@
 	[MSTP715] = SH_CLK_MSTP32_STS(&p_clk, SMSTPCR7, 15, MSTPSR7, 0), /* SCIF4 */
 	[MSTP714] = SH_CLK_MSTP32_STS(&p_clk, SMSTPCR7, 14, MSTPSR7, 0), /* SCIF5 */
 	[MSTP704] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR7, 4, MSTPSR7, 0), /* HSUSB */
+	[MSTP703] = SH_CLK_MSTP32_STS(&mp_clk, SMSTPCR7, 3, MSTPSR7, 0), /* EHCI */
 	[MSTP522] = SH_CLK_MSTP32_STS(&extal_clk, SMSTPCR5, 22, MSTPSR5, 0), /* Thermal */
 	[MSTP314] = SH_CLK_MSTP32_STS(&div4_clks[DIV4_SD0], SMSTPCR3, 14, MSTPSR3, 0), /* SDHI0 */
 	[MSTP312] = SH_CLK_MSTP32_STS(&div6_clks[DIV6_SD1], SMSTPCR3, 12, MSTPSR3, 0), /* SDHI1 */
@@ -285,6 +286,8 @@
 	CLKDEV_DEV_ID("sata-r8a7791.1", &mstp_clks[MSTP814]),
 	CLKDEV_DEV_ID("renesas_usbhs", &mstp_clks[MSTP704]),
 	CLKDEV_ICK_ID("usbhs", "usb_phy_rcar_gen2", &mstp_clks[MSTP704]),
+	CLKDEV_DEV_ID("pci-rcar-gen2.0", &mstp_clks[MSTP703]),
+	CLKDEV_DEV_ID("pci-rcar-gen2.1", &mstp_clks[MSTP703]),
 };
 
 #define R8A7791_CLOCK_ROOT(e, m, p0, p1, p30, p31)		\
