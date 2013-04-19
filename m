Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030452Ab3DSNjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 09:39:35 -0400
Received: from mx01.lb01.inode.at ([62.99.145.1]:53884 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030254Ab3DSNje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 09:39:34 -0400
From: Michal Bachraty <michal.bachraty@streamunlimited.com>
To: perex@perex.cz, tiwai@suse.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: lgirdwood@gmail.com, marek.belisko@streamunlimited.com,
        broonie@opensource.wolfsonmicro.com,
        Michal Bachraty <michal.bachraty@streamunlimited.com>
Subject: [PATCH 2/2] ALSA: ASoC: spdif_receiver: Add DT support
Date: Fri, 19 Apr 2013 15:39:19 +0200
Message-Id: <1366378759-14517-1-git-send-email-michal.bachraty@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
X-Authenticated-Sender: michal.bachraty@streamunlimited.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree support for this dummy audio soc driver.

Signed-off-by: Michal Bachraty <michal.bachraty@streamunlimited.com>
---
 sound/soc/codecs/spdif_receiver.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/codecs/spdif_receiver.c b/sound/soc/codecs/spdif_receiver.c
index dd8d856..5d469c7 100644
--- a/sound/soc/codecs/spdif_receiver.c
+++ b/sound/soc/codecs/spdif_receiver.c
@@ -21,6 +21,9 @@
 #include <sound/soc.h>
 #include <sound/pcm.h>
 #include <sound/initval.h>
+#include <linux/of.h>
+
+#define DRV_NAME "spdif-dir"
 
 #define STUB_RATES	SNDRV_PCM_RATE_8000_192000
 #define STUB_FORMATS	(SNDRV_PCM_FMTBIT_S16_LE | \
@@ -51,12 +54,21 @@ static int spdif_dir_remove(struct platform_device *pdev)
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
 static struct platform_driver spdif_dir_driver = {
 	.probe		= spdif_dir_probe,
 	.remove		= spdif_dir_remove,
 	.driver		= {
 		.name	= "spdif-dir",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(spdif_dit_dt_ids),
 	},
 };
 
-- 
1.7.9.5

