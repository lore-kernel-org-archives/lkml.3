Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbaE2Pf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:35:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59766 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757594AbaE2Pfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:35:31 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] extcon: arizona: Use extcon cable API
Date: Thu, 29 May 2014 16:27:52 +0100
Message-Id: <1401377274-10249-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1401377274-10249-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1401377274-10249-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikesh Oswal <Nikesh.Oswal@wolfsonmicro.com>

Use extcon cable API instead of state API as it is much more
idiomatic.

Signed-off-by: Nikesh Oswal <Nikesh.Oswal@wolfsonmicro.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 21ee055..f2c36b1 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -669,9 +669,8 @@ err:
 			   ARIZONA_ACCDET_MODE_MASK, ARIZONA_ACCDET_MODE_MIC);
 
 	/* Just report headphone */
-	ret = extcon_update_state(info->edev,
-				  1 << ARIZONA_CABLE_HEADPHONE,
-				  1 << ARIZONA_CABLE_HEADPHONE);
+	ret = extcon_set_cable_state_(info->edev,
+				      ARIZONA_CABLE_HEADPHONE, true);
 	if (ret != 0)
 		dev_err(arizona->dev, "Failed to report headphone: %d\n", ret);
 
@@ -728,9 +727,8 @@ err:
 			   ARIZONA_ACCDET_MODE_MASK, ARIZONA_ACCDET_MODE_MIC);
 
 	/* Just report headphone */
-	ret = extcon_update_state(info->edev,
-				  1 << ARIZONA_CABLE_HEADPHONE,
-				  1 << ARIZONA_CABLE_HEADPHONE);
+	ret = extcon_set_cable_state_(info->edev,
+				      ARIZONA_CABLE_HEADPHONE, true);
 	if (ret != 0)
 		dev_err(arizona->dev, "Failed to report headphone: %d\n", ret);
 
@@ -817,9 +815,8 @@ static void arizona_micd_detect(struct work_struct *work)
 	if (info->detecting && (val & ARIZONA_MICD_LVL_8)) {
 		arizona_identify_headphone(info);
 
-		ret = extcon_update_state(info->edev,
-					  1 << ARIZONA_CABLE_MICROPHONE,
-					  1 << ARIZONA_CABLE_MICROPHONE);
+		ret = extcon_set_cable_state_(info->edev,
+					      ARIZONA_CABLE_MICROPHONE, true);
 
 		if (ret != 0)
 			dev_err(arizona->dev, "Headset report failed: %d\n",
-- 
1.7.2.5

