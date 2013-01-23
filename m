Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab3AWQEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:04:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44464 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755511Ab3AWQEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:04:01 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/5] extcon: arizona: Support additional configuration of microphone detection
Date: Thu, 24 Jan 2013 00:03:48 +0800
Message-Id: <1358957029-5421-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358957029-5421-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1358957029-5421-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow systems to tune detection rate and debounce suitably for their
mechanical parameters.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c   |   12 ++++++++++++
 include/linux/mfd/arizona/pdata.h |    6 ++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index ab8b9c7..d7e1047 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -907,6 +907,18 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 				   arizona->pdata.micd_bias_start_time
 				   << ARIZONA_MICD_BIAS_STARTTIME_SHIFT);
 
+	if (arizona->pdata.micd_rate)
+		regmap_update_bits(arizona->regmap, ARIZONA_MIC_DETECT_1,
+				   ARIZONA_MICD_RATE_MASK,
+				   arizona->pdata.micd_rate
+				   << ARIZONA_MICD_RATE_SHIFT);
+
+	if (arizona->pdata.micd_dbtime)
+		regmap_update_bits(arizona->regmap, ARIZONA_MIC_DETECT_1,
+				   ARIZONA_MICD_DBTIME_MASK,
+				   arizona->pdata.micd_dbtime
+				   << ARIZONA_MICD_DBTIME_SHIFT);
+
 	/*
 	 * If we have a clamp use it, activating in conjunction with
 	 * GPIO5 if that is connected for jack detect operation.
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index bcbe4fd..2f5f08e 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -111,6 +111,12 @@ struct arizona_pdata {
 	/** Mic detect ramp rate */
 	int micd_bias_start_time;
 
+	/** Mic detect sample rate */
+	int micd_rate;
+
+	/** Mic detect debounce level */
+	int micd_dbtime;
+
 	/** Headset polarity configurations */
 	struct arizona_micd_config *micd_configs;
 	int num_micd_configs;
-- 
1.7.10.4

