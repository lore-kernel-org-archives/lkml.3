Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbaIXQq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:46:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:49517 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbaIXQqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:46:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="604749384"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: subhransu.s.prusty@intel.com, vinod.koul@intel.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 11/27] mfd: ab8500-gpadc: use pm_runtime_last_busy_and_autosuspend helper
Date: Wed, 24 Sep 2014 21:45:01 +0530
Message-Id: <1411575342-31048-12-git-send-email-vinod.koul@intel.com>
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
 drivers/mfd/ab8500-gpadc.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 36000f9..46bea3a 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -571,8 +571,7 @@ int ab8500_gpadc_double_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
 	}
 
 	/* Disable VTVout LDO this is required for GPADC */
-	pm_runtime_mark_last_busy(gpadc->dev);
-	pm_runtime_put_autosuspend(gpadc->dev);
+	pm_runtime_last_busy_and_autosuspend(gpadc->dev);
 
 	mutex_unlock(&gpadc->ab8500_gpadc_lock);
 
@@ -910,8 +909,7 @@ static int ab8500_gpadc_resume(struct device *dev)
 	if (ret)
 		dev_err(dev, "Failed to enable vtvout LDO: %d\n", ret);
 
-	pm_runtime_mark_last_busy(gpadc->dev);
-	pm_runtime_put_autosuspend(gpadc->dev);
+	pm_runtime_last_busy_and_autosuspend(gpadc->dev);
 
 	mutex_unlock(&gpadc->ab8500_gpadc_lock);
 	return ret;
-- 
1.7.0.4

