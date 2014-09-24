Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaIXQrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:47:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:49699 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608AbaIXQr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:47:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="604749845"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: subhransu.s.prusty@intel.com, vinod.koul@intel.com,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH 24/27] spi: core: use pm_runtime_last_busy_and_autosuspend helper
Date: Wed, 24 Sep 2014 21:45:14 +0530
Message-Id: <1411575342-31048-25-git-send-email-vinod.koul@intel.com>
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
 drivers/spi/spi.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index e0531ba..6ec5330 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -893,10 +893,8 @@ static void spi_pump_messages(struct kthread_work *work)
 		    master->unprepare_transfer_hardware(master))
 			dev_err(&master->dev,
 				"failed to unprepare transfer hardware\n");
-		if (master->auto_runtime_pm) {
-			pm_runtime_mark_last_busy(master->dev.parent);
-			pm_runtime_put_autosuspend(master->dev.parent);
-		}
+		if (master->auto_runtime_pm)
+			pm_runtime_last_busy_and_autosuspend(master->dev.parent);
 		trace_spi_master_idle(master);
 		return;
 	}
-- 
1.7.0.4

