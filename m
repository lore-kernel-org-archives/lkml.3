Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab3HMRA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:00:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54690 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756891Ab3HMRAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:00:24 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: myungjoo.ham@samsung.com, cw00.choi@samsung.com
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH] extcon: arizona: Correct typo in headphone detect range transitions
Date: Tue, 13 Aug 2013 17:51:20 +0100
Message-Id: <1376412680-13748-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should move range when the measured value is greater than or equal to
the max value not when greater than.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 4696df0..e680bc2 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -388,7 +388,7 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
 			   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;
 
 		if (range < ARRAY_SIZE(arizona_hpdet_b_ranges) - 1 &&
-		    (val < 100 || val > 0x3fb)) {
+		    (val < 100 || val >= 0x3fb)) {
 			range++;
 			dev_dbg(arizona->dev, "Moving to HPDET range %d\n",
 				range);
@@ -401,7 +401,7 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
 		}
 
 		/* If we go out of range report top of range */
-		if (val < 100 || val > 0x3fb) {
+		if (val < 100 || val >= 0x3fb) {
 			dev_dbg(arizona->dev, "Measurement out of range\n");
 			return ARIZONA_HPDET_MAX;
 		}
-- 
1.7.2.5

