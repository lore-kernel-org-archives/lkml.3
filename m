Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab3BKQ1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:27:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35467 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757955Ab3BKQ1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:27:12 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 04/11] extcon: arizona: Support additional configuration of microphone detection
Date: Mon, 11 Feb 2013 16:26:59 +0000
Message-Id: <1360600026-16878-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360600026-16878-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130211162614.GH4607@opensource.wolfsonmicro.com>
 <1360600026-16878-1-git-send-email-broonie@opensource.wolfsonmicro.com>
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

