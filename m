Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaIUIBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 04:01:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:53795 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbaIUIBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 04:01:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,564,1406617200"; 
   d="scan'208";a="478959591"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/4] mei: trivial: fix errors in prints in comments
Date: Sun, 21 Sep 2014 11:00:13 +0300
Message-Id: <1411286416-15339-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411286416-15339-1-git-send-email-tomas.winkler@intel.com>
References: <1411286416-15339-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Fix misspellings and wrong print texts

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c  | 2 +-
 drivers/misc/mei/debugfs.c | 2 +-
 drivers/misc/mei/hw-txe.c  | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 4b58fce..19f1c7e 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -926,7 +926,7 @@ int mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, bool blocking)
 
 	buf = &cb->request_buffer;
 
-	cl_dbg(dev, cl, "mei_cl_write %d\n", buf->size);
+	cl_dbg(dev, cl, "size=%d\n", buf->size);
 
 	rets = pm_runtime_get(dev->dev);
 	if (rets < 0 && rets != -EINPROGRESS) {
diff --git a/drivers/misc/mei/debugfs.c b/drivers/misc/mei/debugfs.c
index aca7847..b92b8bc 100644
--- a/drivers/misc/mei/debugfs.c
+++ b/drivers/misc/mei/debugfs.c
@@ -105,7 +105,7 @@ static ssize_t mei_dbgfs_read_active(struct file *fp, char __user *ubuf,
 
 	mutex_lock(&dev->device_lock);
 
-	/*  if the driver is not enabled the list won't b consitent */
+	/*  if the driver is not enabled the list won't be consistent */
 	if (dev->dev_state != MEI_DEV_ENABLED)
 		goto out;
 
diff --git a/drivers/misc/mei/hw-txe.c b/drivers/misc/mei/hw-txe.c
index f33fbcb..695d480 100644
--- a/drivers/misc/mei/hw-txe.c
+++ b/drivers/misc/mei/hw-txe.c
@@ -841,7 +841,7 @@ static int mei_txe_hw_reset(struct mei_device *dev, bool intr_enable)
 	}
 
 	/*
-	 * Set rediness RDY_CLR bit
+	 * Set readiness RDY_CLR bit
 	 */
 	mei_txe_readiness_clear(dev);
 
@@ -867,7 +867,7 @@ static int mei_txe_hw_start(struct mei_device *dev)
 
 	ret = mei_txe_readiness_wait(dev);
 	if (ret < 0) {
-		dev_err(dev->dev, "wating for readiness failed\n");
+		dev_err(dev->dev, "waiting for readiness failed\n");
 		return ret;
 	}
 
-- 
1.9.3

