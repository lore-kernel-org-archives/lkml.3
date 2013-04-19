Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030438Ab3DSNjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 09:39:00 -0400
Received: from mx03.lb01.inode.at ([62.99.145.3]:27293 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030254Ab3DSNi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 09:38:59 -0400
From: Michal Bachraty <michal.bachraty@streamunlimited.com>
To: perex@perex.cz, tiwai@suse.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: lgirdwood@gmail.com, marek.belisko@streamunlimited.com,
        broonie@opensource.wolfsonmicro.com,
        Michal Bachraty <michal.bachraty@streamunlimited.com>
Subject: [PATCH 1/2] ALSA: ASoc: spdif_transciever: Add DT support
Date: Fri, 19 Apr 2013 15:38:45 +0200
Message-Id: <1366378725-14471-1-git-send-email-michal.bachraty@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
X-Authenticated-Sender: michal.bachraty@streamunlimited.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree support for this dummy audio soc driver.

Signed-off-by: Michal Bachraty <michal.bachraty@streamunlimited.com>
---
 sound/soc/codecs/spdif_transciever.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/codecs/spdif_transciever.c b/sound/soc/codecs/spdif_transciever.c
index 112a49d..4c8c295 100644
--- a/sound/soc/codecs/spdif_transciever.c
+++ b/sound/soc/codecs/spdif_transciever.c
@@ -20,6 +20,7 @@
 #include <sound/soc.h>
 #include <sound/pcm.h>
 #include <sound/initval.h>
+#include <linux/of.h>
 
 #define DRV_NAME "spdif-dit"
 
@@ -52,12 +53,21 @@ static int spdif_dit_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id spdif_dit_dt_ids[] = {
+	{ .compatible = DRV_NAME, },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, spdif_dits_dt_ids);
+#endif
+
 static struct platform_driver spdif_dit_driver = {
 	.probe		= spdif_dit_probe,
 	.remove		= spdif_dit_remove,
 	.driver		= {
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(spdif_dit_dt_ids),
 	},
 };
 
-- 
1.7.9.5

