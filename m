Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746AbaE2Pf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:35:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59776 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757595AbaE2Pfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:35:31 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] extcon: arizona: Correct typo to disable regulation for button detection
Date: Thu, 29 May 2014 16:27:54 +0100
Message-Id: <1401377274-10249-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1401377274-10249-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1401377274-10249-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use the bypass mode on the MICVDD reg for button detection, as
the comment in the code states, however the code was mistakenly
disabling bypass. This patch corrects this and allows bypass mode during
button detection.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index c1c8647..b2770aa 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -826,7 +826,7 @@ static void arizona_micd_detect(struct work_struct *work)
 				ret);
 
 		/* Don't need to regulate for button detection */
-		ret = regulator_allow_bypass(info->micvdd, false);
+		ret = regulator_allow_bypass(info->micvdd, true);
 		if (ret != 0) {
 			dev_err(arizona->dev, "Failed to bypass MICVDD: %d\n",
 				ret);
-- 
1.7.2.5

