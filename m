Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbaKSPFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:05:34 -0500
Received: from 9.mo3.mail-out.ovh.net ([87.98.184.141]:49379 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754238AbaKSPFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:05:33 -0500
From: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
To: David Airlie <airlied@linux.ie>, Rob Clark <robdclark@gmail.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Subject: [PATCH v2] drm/tilcdc: add missing clk_put in tilcdc_unload()
Date: Wed, 19 Nov 2014 15:56:46 +0100
Message-Id: <1416409006-16785-1-git-send-email-julien.chauveau@neo-technologies.fr>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416406400-10564-1-git-send-email-julien.chauveau@neo-technologies.fr>
References: <1416406400-10564-1-git-send-email-julien.chauveau@neo-technologies.fr>
X-Ovh-Tracer-Id: 12716476498469191852
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

We need to call clk_put on display clock, in the same way as functional clock.
Also remove the check for priv->clk, since clk_put() is safe against NULL pointers.

Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
---
Changes since v1:
- remove the check for priv->clk, as suggested by Felipe Balbi

 drivers/gpu/drm/tilcdc/tilcdc_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
index 79a34cb..b0c9687 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -136,8 +136,8 @@ static int tilcdc_unload(struct drm_device *dev)
 			CPUFREQ_TRANSITION_NOTIFIER);
 #endif
 
-	if (priv->clk)
-		clk_put(priv->clk);
+	clk_put(priv->disp_clk);
+	clk_put(priv->clk);
 
 	if (priv->mmio)
 		iounmap(priv->mmio);
-- 
2.1.0

