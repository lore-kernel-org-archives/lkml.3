Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbaKSOzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:55:31 -0500
Received: from 19.mo3.mail-out.ovh.net ([178.32.98.231]:44592 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755839AbaKSOz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:55:29 -0500
X-Greylist: delayed 2401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Nov 2014 09:55:29 EST
From: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
To: David Airlie <airlied@linux.ie>, Rob Clark <robdclark@gmail.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Subject: [PATCH] drm/tilcdc: fix check for display clock in tilcdc_load()
Date: Wed, 19 Nov 2014 14:35:29 +0100
Message-Id: <1416404129-903-1-git-send-email-julien.chauveau@neo-technologies.fr>
X-Mailer: git-send-email 2.1.0
X-Ovh-Tracer-Id: 11296998192126165164
X-Ovh-Remote: 193.248.240.88 (laubervilliers-656-1-116-88.w193-248.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrkeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrkeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This appears to be a copy-paste error. We need to check for errors on disp_clk.

Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
---
 drivers/gpu/drm/tilcdc/tilcdc_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
index 79a34cb..9f2bd8a 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -200,7 +200,7 @@ static int tilcdc_load(struct drm_device *dev, unsigned long flags)
 	}
 
 	priv->disp_clk = clk_get(dev->dev, "dpll_disp_ck");
-	if (IS_ERR(priv->clk)) {
+	if (IS_ERR(priv->disp_clk)) {
 		dev_err(dev->dev, "failed to get display clock\n");
 		ret = -ENODEV;
 		goto fail_put_clk;
-- 
2.1.0

