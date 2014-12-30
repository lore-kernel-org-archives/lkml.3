Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaL3K4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 05:56:51 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:46449 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752073AbaL3K4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 05:56:45 -0500
From: Andrew Jackson <andrew.jackson@arm.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 4/6] ASoC: dwc: Register components with managed interface
Date: Tue, 30 Dec 2014 10:55:46 +0000
Message-Id: <6bd7d7cfd48fedccd8730ddbbae39f92dd0069c7.1419936132.git.Andrew.Jackson@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1419936132.git.Andrew.Jackson@arm.com>
References: <cover.1419936132.git.Andrew.Jackson@arm.com>
In-Reply-To: <cover.1419936132.git.Andrew.Jackson@arm.com>
References: <cover.1419936132.git.Andrew.Jackson@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Jackson <Andrew.Jackson@arm.com>

Register SOC component using managed interface to
simplify error handling and future introduction of
device tree.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
 sound/soc/dwc/designware_i2s.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/sound/soc/dwc/designware_i2s.c b/sound/soc/dwc/designware_i2s.c
index b3e7567..e1c0e2c 100644
--- a/sound/soc/dwc/designware_i2s.c
+++ b/sound/soc/dwc/designware_i2s.c
@@ -492,7 +492,7 @@ static int dw_i2s_probe(struct platform_device *pdev)
 		return ret;
 
 	dev_set_drvdata(&pdev->dev, dev);
-	ret = snd_soc_register_component(&pdev->dev, &dw_i2s_component,
+	ret = devm_snd_soc_register_component(&pdev->dev, &dw_i2s_component,
 					 dw_i2s_dai, 1);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "not able to register dai\n");
@@ -510,7 +510,6 @@ static int dw_i2s_remove(struct platform_device *pdev)
 {
 	struct dw_i2s_dev *dev = dev_get_drvdata(&pdev->dev);
 
-	snd_soc_unregister_component(&pdev->dev);
 	clk_disable_unprepare(dev->clk);
 
 	return 0;
-- 
1.7.1

