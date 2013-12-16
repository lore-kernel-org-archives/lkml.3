Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab3LPLVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:21:53 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:38691 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab3LPLVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:21:51 -0500
Date: Mon, 16 Dec 2013 16:51:10 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH] drivers: video: Remove unused function
 genericbl_limit_intensity() in generic_bl.c
Message-ID: <20131216112110.GA4849@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes unused function genericbl_limit_intensity() in
backlight/generic_bl.c.

This eliminates the following warning in backlight/generic_bl.c:
drivers/video/backlight/generic_bl.c:59:6: warning: no previous prototype for ‘genericbl_limit_intensity’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/video/backlight/generic_bl.c |   18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
index 5d8d652..67dfb93 100644
--- a/drivers/video/backlight/generic_bl.c
+++ b/drivers/video/backlight/generic_bl.c
@@ -52,24 +52,6 @@ static int genericbl_get_intensity(struct backlight_device *bd)
 	return genericbl_intensity;
 }
 
-/*
- * Called when the battery is low to limit the backlight intensity.
- * If limit==0 clear any limit, otherwise limit the intensity
- */
-void genericbl_limit_intensity(int limit)
-{
-	struct backlight_device *bd = generic_backlight_device;
-
-	mutex_lock(&bd->ops_lock);
-	if (limit)
-		bd->props.state |= GENERICBL_BATTLOW;
-	else
-		bd->props.state &= ~GENERICBL_BATTLOW;
-	backlight_update_status(generic_backlight_device);
-	mutex_unlock(&bd->ops_lock);
-}
-EXPORT_SYMBOL(genericbl_limit_intensity);
-
 static const struct backlight_ops genericbl_ops = {
 	.options = BL_CORE_SUSPENDRESUME,
 	.get_brightness = genericbl_get_intensity,
-- 
1.7.9.5

