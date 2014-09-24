Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbaIXQrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:47:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:49517 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbaIXQq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:46:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="604749415"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: subhransu.s.prusty@intel.com, vinod.koul@intel.com,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 13/27] mei: use pm_runtime_last_busy_and_autosuspend helper
Date: Wed, 24 Sep 2014 21:45:03 +0530
Message-Id: <1411575342-31048-14-git-send-email-vinod.koul@intel.com>
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
 drivers/misc/mei/client.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 324e1de..e522c01 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -519,8 +519,7 @@ int mei_cl_disconnect(struct mei_cl *cl)
 	mei_io_list_flush(&dev->ctrl_wr_list, cl);
 free:
 	cl_dbg(dev, cl, "rpm: autosuspend\n");
-	pm_runtime_mark_last_busy(&dev->pdev->dev);
-	pm_runtime_put_autosuspend(&dev->pdev->dev);
+	pm_runtime_last_busy_and_autosuspend(&dev->pdev->dev);
 
 	mei_io_cb_free(cb);
 	return rets;
@@ -625,8 +624,7 @@ int mei_cl_connect(struct mei_cl *cl, struct file *file)
 
 out:
 	cl_dbg(dev, cl, "rpm: autosuspend\n");
-	pm_runtime_mark_last_busy(&dev->pdev->dev);
-	pm_runtime_put_autosuspend(&dev->pdev->dev);
+	pm_runtime_last_busy_and_autosuspend(&dev->pdev->dev);
 
 	mei_io_cb_free(cb);
 	return rets;
@@ -779,8 +777,7 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 
 out:
 	cl_dbg(dev, cl, "rpm: autosuspend\n");
-	pm_runtime_mark_last_busy(&dev->pdev->dev);
-	pm_runtime_put_autosuspend(&dev->pdev->dev);
+	pm_runtime_last_busy_and_autosuspend(&dev->pdev->dev);
 
 	if (rets)
 		mei_io_cb_free(cb);
@@ -978,8 +975,7 @@ out:
 	rets = buf->size;
 err:
 	cl_dbg(dev, cl, "rpm: autosuspend\n");
-	pm_runtime_mark_last_busy(&dev->pdev->dev);
-	pm_runtime_put_autosuspend(&dev->pdev->dev);
+	pm_runtime_last_busy_and_autosuspend(&dev->pdev->dev);
 
 	return rets;
 }
-- 
1.7.0.4

