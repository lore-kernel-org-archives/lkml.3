Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbaKSQOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:14:37 -0500
Received: from mout.web.de ([212.227.17.12]:61936 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182AbaKSQOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:14:35 -0500
Message-ID: <546CC1DE.3020105@users.sourceforge.net>
Date: Wed, 19 Nov 2014 17:14:22 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] DRM-tilcdc: Deletion of an unnecessary check before the
 function call "drm_fbdev_cma_hotplug_event"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:utBNDBXKvV9wspJ4mSly6uQ6J4EdbGD+iFHetT7K46KDF8PTxnY
 W3DvF0n+tB1Ch4FHrpA0jUieVzEZd+6RBQU3tLXrsm//JKn0PfYah6ExpJMUP+iWYOhBKgr
 c9Q1fHpXiYUkxcKk6LUy6q5++gQ/M03mt7K5OYMCrIJ7xSrADu9DupaQmzK4cXKfVLUOUie
 MhlTpBGZUkMWgU/vqInsw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 19 Nov 2014 17:05:20 +0100

The drm_fbdev_cma_hotplug_event() function tests whether its argument is NULL
and then returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/gpu/drm/tilcdc/tilcdc_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
index 000428e..335b1dc 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -58,8 +58,7 @@ static struct drm_framebuffer *tilcdc_fb_create(struct drm_device *dev,
 static void tilcdc_fb_output_poll_changed(struct drm_device *dev)
 {
 	struct tilcdc_drm_private *priv = dev->dev_private;
-	if (priv->fbdev)
-		drm_fbdev_cma_hotplug_event(priv->fbdev);
+	drm_fbdev_cma_hotplug_event(priv->fbdev);
 }
 
 static const struct drm_mode_config_funcs mode_config_funcs = {
-- 
2.1.3

