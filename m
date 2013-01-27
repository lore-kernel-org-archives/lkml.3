Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3A0QdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 11:33:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39239 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753220Ab3A0QdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 11:33:21 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: arizona: Clarify mixer underclocking error
Date: Mon, 28 Jan 2013 00:32:53 +0800
Message-Id: <1359304373-10317-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the mixer is underclocked it will drop a sample so log that error
more directly.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 7bea4a7..d71c8fc 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -115,7 +115,7 @@ static irqreturn_t arizona_underclocked(int irq, void *data)
 	if (val & ARIZONA_ADC_UNDERCLOCKED_STS)
 		dev_err(arizona->dev, "ADC underclocked\n");
 	if (val & ARIZONA_MIXER_UNDERCLOCKED_STS)
-		dev_err(arizona->dev, "Mixer underclocked\n");
+		dev_err(arizona->dev, "Mixer dropped sample\n");
 
 	return IRQ_HANDLED;
 }
-- 
1.7.10.4

