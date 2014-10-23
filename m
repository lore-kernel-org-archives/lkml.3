Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbaJWIRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:17:15 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8340 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaJWIRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:17:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 23 Oct 2014 01:16:35 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] drm/panel: s6e8aa0: Update calls to gpiod_get*()
Date: Thu, 23 Oct 2014 17:16:57 +0900
Message-ID: <1414052218-20157-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new flags argument to calls of (devm_)gpiod_get*() and
remove any direction setting code afterwards.

Currently both forms (with or without the flags argument)
are valid thanks to transitional macros in
<linux/gpio/consumer.h>. These macros will be removed once
all consumers are updated and the flags argument will become
compulsary.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/panel/panel-s6e8aa0.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-s6e8aa0.c b/drivers/gpu/drm/panel/panel-s6e8aa0.c
index b5217fe37f02..6427aa187735 100644
--- a/drivers/gpu/drm/panel/panel-s6e8aa0.c
+++ b/drivers/gpu/drm/panel/panel-s6e8aa0.c
@@ -1019,17 +1019,12 @@ static int s6e8aa0_probe(struct mipi_dsi_device *dsi)
 		return ret;
 	}
 
-	ctx->reset_gpio = devm_gpiod_get(dev, "reset");
+	ctx->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(ctx->reset_gpio)) {
 		dev_err(dev, "cannot get reset-gpios %ld\n",
 			PTR_ERR(ctx->reset_gpio));
 		return PTR_ERR(ctx->reset_gpio);
 	}
-	ret = gpiod_direction_output(ctx->reset_gpio, 1);
-	if (ret < 0) {
-		dev_err(dev, "cannot configure reset-gpios %d\n", ret);
-		return ret;
-	}
 
 	ctx->brightness = GAMMA_LEVEL_NUM - 1;
 
-- 
2.1.2

