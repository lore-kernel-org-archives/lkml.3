Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaLSCBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:01:46 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:46968 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbaLSCBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:01:13 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
X-Google-Original-From: Steve Longerbeam <steve_longerbeam@mentor.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Denis Carikli <denis@eukrea.com>,
        Jiada Wang <jiada_wang@mentor.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 7/7] gpu: ipu-di: Switch to DIV_ROUND_CLOSEST for DI clock divider calc
Date: Thu, 18 Dec 2014 18:00:26 -0800
Message-Id: <1418954426-21909-8-git-send-email-steve_longerbeam@mentor.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use the DIV_ROUND_CLOSEST() macro when calculating the DI
clock divider, rounded to nearest int.

Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-di.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-di.c b/drivers/gpu/ipu-v3/ipu-di.c
index d95fbd0..b61d6be 100644
--- a/drivers/gpu/ipu-v3/ipu-di.c
+++ b/drivers/gpu/ipu-v3/ipu-di.c
@@ -440,8 +440,7 @@ static void ipu_di_config_clock(struct ipu_di *di,
 			clk_set_rate(clk, sig->mode.pixelclock);
 
 			in_rate = clk_get_rate(clk);
-			div = (in_rate + sig->mode.pixelclock / 2) /
-				sig->mode.pixelclock;
+			div = DIV_ROUND_CLOSEST(in_rate, sig->mode.pixelclock);
 			if (div == 0)
 				div = 1;
 
@@ -459,8 +458,7 @@ static void ipu_di_config_clock(struct ipu_di *di,
 		unsigned div, error;
 
 		clkrate = clk_get_rate(di->clk_ipu);
-		div = (clkrate + sig->mode.pixelclock / 2) /
-			sig->mode.pixelclock;
+		div = DIV_ROUND_CLOSEST(clkrate, sig->mode.pixelclock);
 		rate = clkrate / div;
 
 		error = rate / (sig->mode.pixelclock / 1000);
@@ -482,8 +480,7 @@ static void ipu_di_config_clock(struct ipu_di *di,
 			clk_set_rate(clk, sig->mode.pixelclock);
 
 			in_rate = clk_get_rate(clk);
-			div = (in_rate + sig->mode.pixelclock / 2) /
-				sig->mode.pixelclock;
+			div = DIV_ROUND_CLOSEST(in_rate, sig->mode.pixelclock);
 			if (div == 0)
 				div = 1;
 
-- 
1.7.9.5

