Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965654AbaLLJ0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 04:26:10 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:35668 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934656AbaLLJ0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 04:26:04 -0500
From: Andrew Jackson <andrew.jackson@arm.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] ASoC: dwc: Remove unnecessary debug messages and tests
Date: Fri, 12 Dec 2014 09:25:00 +0000
Message-Id: <97f65b6037b9ac676f6ca7717a230a68cbe81fd1.1418372910.git.Andrew.Jackson@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1418372910.git.Andrew.Jackson@arm.com>
References: <cover.1418372910.git.Andrew.Jackson@arm.com>
In-Reply-To: <cover.1418372910.git.Andrew.Jackson@arm.com>
References: <cover.1418372910.git.Andrew.Jackson@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Jackson <Andrew.Jackson@arm.com>

The devm_XXX allocation functions print a message on failure,
so additional messages are not required.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
 sound/soc/dwc/designware_i2s.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/sound/soc/dwc/designware_i2s.c b/sound/soc/dwc/designware_i2s.c
index d202c7c..ef771ea 100644
--- a/sound/soc/dwc/designware_i2s.c
+++ b/sound/soc/dwc/designware_i2s.c
@@ -345,26 +345,17 @@ static int dw_i2s_probe(struct platform_device *pdev)
 	}
 
 	dw_i2s_dai = devm_kzalloc(&pdev->dev, sizeof(*dw_i2s_dai), GFP_KERNEL);
-	if (!dw_i2s_dai) {
-		dev_err(&pdev->dev, "mem allocation failed for dai driver\n");
+	if (!dw_i2s_dai)
 		return -ENOMEM;
-	}
 
 	dw_i2s_dai->ops = &dw_i2s_dai_ops;
 	dw_i2s_dai->suspend = dw_i2s_suspend;
 	dw_i2s_dai->resume = dw_i2s_resume;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "no i2s resource defined\n");
-		return -ENODEV;
-	}
-
 	dev->i2s_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(dev->i2s_base)) {
-		dev_err(&pdev->dev, "ioremap fail for i2s_region\n");
+	if (IS_ERR(dev->i2s_base))
 		return PTR_ERR(dev->i2s_base);
-	}
 
 	cap = pdata->cap;
 	dev->capability = cap;
-- 
1.7.1

