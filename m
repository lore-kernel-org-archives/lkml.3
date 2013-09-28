Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab3I1OqK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 10:46:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44855 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753576Ab3I1OqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 10:46:07 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: myungjoo.ham@samsung.com, cw00.choi@samsung.com
Cc: broonie@kernel.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH] extcon: arizona: Get pdata from arizona structure not device
Date: Sat, 28 Sep 2013 15:34:57 +0100
Message-Id: <1380378897-7164-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of a device tree system there will be no pdata attached to
the device, causing us to deference a NULL pointer. Better to take the
pdata from the Arizona structure as this will always exist and we know
will have been populated since it is populated by the MFD device which
binds in the extcon driver.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index ec9a14e..178454d 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -1079,7 +1079,7 @@ static void arizona_micd_set_level(struct arizona *arizona, int index,
 static int arizona_extcon_probe(struct platform_device *pdev)
 {
 	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
-	struct arizona_pdata *pdata;
+	struct arizona_pdata *pdata = &arizona->pdata;
 	struct arizona_extcon_info *info;
 	unsigned int val;
 	int jack_irq_fall, jack_irq_rise;
@@ -1088,8 +1088,6 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	if (!arizona->dapm || !arizona->dapm->card)
 		return -EPROBE_DEFER;
 
-	pdata = dev_get_platdata(arizona->dev);
-
 	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
 	if (!info) {
 		dev_err(&pdev->dev, "Failed to allocate memory\n");
-- 
1.7.2.5

