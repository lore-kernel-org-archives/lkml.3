Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbaBRNAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:00:10 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:38143 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbaBRNAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:00:08 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: airlied@linux.ie, robdclark@gmail.com, daniel.vetter@ffwll.ch
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH] drm: ti: lcdc: Fixed an error check in the clock initialization
Date: Tue, 18 Feb 2014 13:56:55 +0100
Message-Id: <1392728215-8521-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
Hi,

this is a simple patch to fix a copy/paste error in the init code of the driver.
The problem is also present in the v3.10 stable tree
cheers,

Jean-Jacques

drivers/gpu/drm/tilcdc/tilcdc_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
index 171a820..f10bc56 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -200,7 +200,7 @@ static int tilcdc_load(struct drm_device *dev, unsigned long flags)
 	}
 
 	priv->disp_clk = clk_get(dev->dev, "dpll_disp_ck");
-	if (IS_ERR(priv->clk)) {
+	if (IS_ERR(priv->disp_clk)) {
 		dev_err(dev->dev, "failed to get display clock\n");
 		ret = -ENODEV;
 		goto fail;
-- 
1.9.0

