Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab3DSSSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 14:18:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:1876 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092Ab3DSSSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 14:18:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,510,1363158000"; 
   d="scan'208";a="297630516"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Bill Nottingham <notting@redhat.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/3 V2] mei: reseting -> resetting
Date: Fri, 19 Apr 2013 21:16:55 +0300
Message-Id: <1366395415-13031-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366395415-13031-1-git-send-email-tomas.winkler@intel.com>
References: <1366395415-13031-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bill Nottingham <notting@redhat.com>

This enum leaks out to userspace via error messages, so fix the spelling.

Signed-off-by: Bill Nottingham <notting@redhat.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: rebased

 drivers/misc/mei/hbm.c     | 8 ++++----
 drivers/misc/mei/hw-me.c   | 2 +-
 drivers/misc/mei/init.c    | 4 ++--
 drivers/misc/mei/mei_dev.h | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 4de80d9..db605f5 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -52,7 +52,7 @@ static void mei_hbm_me_cl_allocate(struct mei_device *dev)
 			sizeof(struct mei_me_client), GFP_KERNEL);
 	if (!clients) {
 		dev_err(&dev->pdev->dev, "memory allocation for ME clients failed.\n");
-		dev->dev_state = MEI_DEV_RESETING;
+		dev->dev_state = MEI_DEV_RESETTING;
 		mei_reset(dev, 1);
 		return;
 	}
@@ -167,7 +167,7 @@ int mei_hbm_start_req(struct mei_device *dev)
 	dev->hbm_state = MEI_HBM_IDLE;
 	if (mei_write_message(dev, mei_hdr, dev->wr_msg.data)) {
 		dev_err(&dev->pdev->dev, "version message writet failed\n");
-		dev->dev_state = MEI_DEV_RESETING;
+		dev->dev_state = MEI_DEV_RESETTING;
 		mei_reset(dev, 1);
 		return -ENODEV;
 	}
@@ -196,7 +196,7 @@ static void mei_hbm_enum_clients_req(struct mei_device *dev)
 	enum_req->hbm_cmd = HOST_ENUM_REQ_CMD;
 
 	if (mei_write_message(dev, mei_hdr, dev->wr_msg.data)) {
-		dev->dev_state = MEI_DEV_RESETING;
+		dev->dev_state = MEI_DEV_RESETTING;
 		dev_err(&dev->pdev->dev, "enumeration request write failed.\n");
 		mei_reset(dev, 1);
 	}
@@ -249,7 +249,7 @@ static int mei_hbm_prop_req(struct mei_device *dev)
 	prop_req->address = next_client_index;
 
 	if (mei_write_message(dev, mei_hdr, dev->wr_msg.data)) {
-		dev->dev_state = MEI_DEV_RESETING;
+		dev->dev_state = MEI_DEV_RESETTING;
 		dev_err(&dev->pdev->dev, "properties request write failed\n");
 		mei_reset(dev, 1);
 
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 3d6dfa3..fc03227 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -481,7 +481,7 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 
 	/* check if ME wants a reset */
 	if (!mei_hw_is_ready(dev) &&
-	    dev->dev_state != MEI_DEV_RESETING &&
+	    dev->dev_state != MEI_DEV_RESETTING &&
 	    dev->dev_state != MEI_DEV_INITIALIZING) {
 		dev_dbg(&dev->pdev->dev, "FW not ready.\n");
 		mei_reset(dev, 1);
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 59159e0..713d89f 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -33,7 +33,7 @@ const char *mei_dev_state_str(int state)
 	MEI_DEV_STATE(INITIALIZING);
 	MEI_DEV_STATE(INIT_CLIENTS);
 	MEI_DEV_STATE(ENABLED);
-	MEI_DEV_STATE(RESETING);
+	MEI_DEV_STATE(RESETTING);
 	MEI_DEV_STATE(DISABLED);
 	MEI_DEV_STATE(POWER_DOWN);
 	MEI_DEV_STATE(POWER_UP);
@@ -146,7 +146,7 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 	if (dev->dev_state != MEI_DEV_INITIALIZING) {
 		if (dev->dev_state != MEI_DEV_DISABLED &&
 		    dev->dev_state != MEI_DEV_POWER_DOWN)
-			dev->dev_state = MEI_DEV_RESETING;
+			dev->dev_state = MEI_DEV_RESETTING;
 
 		mei_cl_all_disconnect(dev);
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index c91c492..4de5140 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -97,7 +97,7 @@ enum mei_dev_state {
 	MEI_DEV_INITIALIZING = 0,
 	MEI_DEV_INIT_CLIENTS,
 	MEI_DEV_ENABLED,
-	MEI_DEV_RESETING,
+	MEI_DEV_RESETTING,
 	MEI_DEV_DISABLED,
 	MEI_DEV_POWER_DOWN,
 	MEI_DEV_POWER_UP
-- 
1.8.1.2

