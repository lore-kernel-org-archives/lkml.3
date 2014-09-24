Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaIXQq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:46:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:56509 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbaIXQqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:46:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="604749224"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: subhransu.s.prusty@intel.com, vinod.koul@intel.com,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        patches@opensource.wolfsonmicro.com
Subject: [PATCH 03/27] extcon: arizona: use pm_runtime_last_busy_and_autosuspend helper
Date: Wed, 24 Sep 2014 21:44:53 +0530
Message-Id: <1411575342-31048-4-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
coding the same code

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/extcon/extcon-arizona.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index ba51588..7774e80 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -323,8 +323,7 @@ static void arizona_stop_mic(struct arizona_extcon_info *info)
 
 	if (change) {
 		regulator_disable(info->micvdd);
-		pm_runtime_mark_last_busy(info->dev);
-		pm_runtime_put_autosuspend(info->dev);
+		pm_runtime_last_busy_and_autosuspend(info->dev);
 	}
 }
 
@@ -1077,8 +1076,7 @@ out:
 
 	mutex_unlock(&info->lock);
 
-	pm_runtime_mark_last_busy(info->dev);
-	pm_runtime_put_autosuspend(info->dev);
+	pm_runtime_last_busy_and_autosuspend(info->dev);
 
 	return IRQ_HANDLED;
 }
-- 
1.7.0.4

