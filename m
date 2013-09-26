Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab3IZRVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:21:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61824 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab3IZRVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:21:08 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Simon Horman <horms@verge.net.au>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v2 2/5] ARM: shmobile: r8a7790: add I2C clocks and aliases for the DT mode
Date: Thu, 26 Sep 2013 19:20:57 +0200
Message-Id: <1380216060-14506-3-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1380216060-14506-1-git-send-email-g.liakhovetski@gmx.de>
References: <1380216060-14506-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:/MFYuJ6dtJIPk/KElTTO9I/RoTi1LE9RYsVnzdsKMrN
 h60BYXu3lxRWR1qWW4Kxh/aBXIhu8LTGvx1OZkzIyxXlb1Pic7
 jxH1HF2l3Eob6XWrx6NQuiRcOOr5tQbqmTd5xnJLMBS+wDHpLI
 i2JR38EeRw5j347IGe5oPtaXWT70+l3/PxHMEjlokrjUi9mPfN
 aYd+m5EJ0ZBGGDgbOuSKpHiNdqsxQIFenpTGo8Cz++hn8vNM0c
 wFPR9r/8q10uJ+DcKfo4Y/xJMpJs6F5vQlP50bz4to/8UbzicF
 tm/w9IX3N/gf5qDMZjVeCT4z04rF0WheFmvAYehcSKm904oMp6
 KSwhAX+wVYLsEKu/PUmYLllQ1+Z1RZOXN3DFm+uMM1d6pp9v7M
 pVn5WaSYufDRQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds clock definitions for the 4 I2C interfaces on r8a7790 and
clock aliases, suitable for the DT mode.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---

v2: part one of former [PATCH 2/4]

 arch/arm/mach-shmobile/clock-r8a7790.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-shmobile/clock-r8a7790.c b/arch/arm/mach-shmobile/clock-r8a7790.c
index af088c0..a64f965 100644
--- a/arch/arm/mach-shmobile/clock-r8a7790.c
+++ b/arch/arm/mach-shmobile/clock-r8a7790.c
@@ -52,6 +52,7 @@
 #define SMSTPCR5 0xe6150144
 #define SMSTPCR7 0xe615014c
 #define SMSTPCR8 0xe6150990
+#define SMSTPCR9 0xe6150994
 
 #define SDCKCR		0xE6150074
 #define SD2CKCR		0xE6150078
@@ -181,6 +182,7 @@ static struct clk div6_clks[DIV6_NR] = {
 
 /* MSTP */
 enum {
+	MSTP931, MSTP930, MSTP929, MSTP928,
 	MSTP813,
 	MSTP726, MSTP725, MSTP724, MSTP723, MSTP722, MSTP721, MSTP720,
 	MSTP717, MSTP716,
@@ -192,6 +194,10 @@ enum {
 };
 
 static struct clk mstp_clks[MSTP_NR] = {
+	[MSTP931] = SH_CLK_MSTP32(&hp_clk, SMSTPCR9, 31, 0), /* I2C0 */
+	[MSTP930] = SH_CLK_MSTP32(&hp_clk, SMSTPCR9, 30, 0), /* I2C1 */
+	[MSTP929] = SH_CLK_MSTP32(&hp_clk, SMSTPCR9, 29, 0), /* I2C2 */
+	[MSTP928] = SH_CLK_MSTP32(&hp_clk, SMSTPCR9, 28, 0), /* I2C3 */
 	[MSTP813] = SH_CLK_MSTP32(&p_clk, SMSTPCR8, 13, 0), /* Ether */
 	[MSTP726] = SH_CLK_MSTP32(&zx_clk, SMSTPCR7, 26, 0), /* LVDS0 */
 	[MSTP725] = SH_CLK_MSTP32(&zx_clk, SMSTPCR7, 25, 0), /* LVDS1 */
@@ -271,6 +277,10 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("sh-sci.7", &mstp_clks[MSTP720]),
 	CLKDEV_DEV_ID("sh-sci.8", &mstp_clks[MSTP717]),
 	CLKDEV_DEV_ID("sh-sci.9", &mstp_clks[MSTP716]),
+	CLKDEV_DEV_ID("e6508000.i2c", &mstp_clks[MSTP931]),
+	CLKDEV_DEV_ID("e6518000.i2c", &mstp_clks[MSTP930]),
+	CLKDEV_DEV_ID("e6530000.i2c", &mstp_clks[MSTP929]),
+	CLKDEV_DEV_ID("e6540000.i2c", &mstp_clks[MSTP928]),
 	CLKDEV_DEV_ID("r8a7790-ether", &mstp_clks[MSTP813]),
 	CLKDEV_DEV_ID("rcar_thermal", &mstp_clks[MSTP522]),
 	CLKDEV_DEV_ID("ee200000.mmcif", &mstp_clks[MSTP315]),
-- 
1.7.2.5

