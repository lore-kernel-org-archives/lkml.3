Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaEWOsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:48:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49916 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752945AbaEWOsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:48:17 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, broonie@kernel.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] mfd: arizona: Add missing handling for ISRC3 under/overclocked
Date: Fri, 23 May 2014 15:40:34 +0100
Message-Id: <1400856034-4509-6-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400856034-4509-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1400856034-4509-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some parts have a third ISRC, this patch adds handling for the under and
overclocked interrupts from this ISRC.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index a068748..cabe8f4 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -123,6 +123,8 @@ static irqreturn_t arizona_underclocked(int irq, void *data)
 		dev_err(arizona->dev, "AIF2 underclocked\n");
 	if (val & ARIZONA_AIF1_UNDERCLOCKED_STS)
 		dev_err(arizona->dev, "AIF1 underclocked\n");
+	if (val & ARIZONA_ISRC3_UNDERCLOCKED_STS)
+		dev_err(arizona->dev, "ISRC3 underclocked\n");
 	if (val & ARIZONA_ISRC2_UNDERCLOCKED_STS)
 		dev_err(arizona->dev, "ISRC2 underclocked\n");
 	if (val & ARIZONA_ISRC1_UNDERCLOCKED_STS)
@@ -192,6 +194,8 @@ static irqreturn_t arizona_overclocked(int irq, void *data)
 		dev_err(arizona->dev, "ASRC sync WARP overclocked\n");
 	if (val[1] & ARIZONA_ADSP2_1_OVERCLOCKED_STS)
 		dev_err(arizona->dev, "DSP1 overclocked\n");
+	if (val[1] & ARIZONA_ISRC3_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "ISRC3 overclocked\n");
 	if (val[1] & ARIZONA_ISRC2_OVERCLOCKED_STS)
 		dev_err(arizona->dev, "ISRC2 overclocked\n");
 	if (val[1] & ARIZONA_ISRC1_OVERCLOCKED_STS)
-- 
1.7.2.5

