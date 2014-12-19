Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaLSCBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:01:10 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:45550 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaLSCBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:01:06 -0500
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
Subject: [PATCH v2 2/7] gpu: ipu-di: remove some non-functional code
Date: Thu, 18 Dec 2014 18:00:21 -0800
Message-Id: <1418954426-21909-3-git-send-email-steve_longerbeam@mentor.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

h_total and v_total were calculated in ipu_di_init_sync_panel()
but never actually used. Remove.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-di.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-di.c b/drivers/gpu/ipu-v3/ipu-di.c
index 46f9570..41df8d7 100644
--- a/drivers/gpu/ipu-v3/ipu-di.c
+++ b/drivers/gpu/ipu-v3/ipu-di.c
@@ -545,7 +545,6 @@ int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
 	u32 reg;
 	u32 di_gen, vsync_cnt;
 	u32 div;
-	u32 h_total, v_total;
 
 	dev_dbg(di->ipu->dev, "disp %d: panel size = %d x %d\n",
 		di->id, sig->width, sig->height);
@@ -553,11 +552,6 @@ int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
 	if ((sig->v_sync_width == 0) || (sig->h_sync_width == 0))
 		return -EINVAL;
 
-	h_total = sig->width + sig->h_sync_width + sig->h_start_width +
-		sig->h_end_width;
-	v_total = sig->height + sig->v_sync_width + sig->v_start_width +
-		sig->v_end_width;
-
 	dev_dbg(di->ipu->dev, "Clocks: IPU %luHz DI %luHz Needed %luHz\n",
 		clk_get_rate(di->clk_ipu),
 		clk_get_rate(di->clk_di),
-- 
1.7.9.5

