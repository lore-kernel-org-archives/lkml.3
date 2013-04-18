Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936629Ab3DRU7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 16:59:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936593Ab3DRU73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 16:59:29 -0400
From: Bill Nottingham <notting@redhat.com>
To: tomas.winkler@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mei: reseting -> resetting
Date: Thu, 18 Apr 2013 16:59:51 -0400
Message-Id: <1366318791-10509-1-git-send-email-notting@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enum leaks out to userspace via error messages, so fix the spelling.

Signed-off-by: Bill Nottingham <notting@redhat.com>
---
 drivers/misc/mei/hbm.c     | 8 ++++----
 drivers/misc/mei/hw-me.c   | 2 +-
 drivers/misc/mei/init.c    | 4 ++--
 drivers/misc/mei/mei_dev.h | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index fb9e63b..e02d4cf 100644
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
@@ -146,7 +146,7 @@ void mei_hbm_start_req(struct mei_device *dev)
 	dev->recvd_msg = false;
 	if (mei_write_message(dev, mei_hdr, dev->wr_msg.data)) {
 		dev_dbg(&dev->pdev->dev, "write send version message to FW fail.\n");
-		dev->dev_state = MEI_DEV_RESETING;
+		dev->dev_state = MEI_DEV_RESETTING;
 		mei_reset(dev, 1);
 	}
 	dev->init_clients_state = MEI_START_MESSAGE;
@@ -174,7 +174,7 @@ static void mei_hbm_enum_clients_req(struct mei_device *dev)
 	enum_req->hbm_cmd = HOST_ENUM_REQ_CMD;
 
 	if (mei_write_message(dev, mei_hdr, dev->wr_msg.data)) {
-		dev->dev_state = MEI_DEV_RESETING;
+		dev->dev_state = MEI_DEV_RESETTING;
 		dev_dbg(&dev->pdev->dev, "write send enumeration request message to FW fail.\n");
 		mei_reset(dev, 1);
 	}
@@ -226,7 +226,7 @@ static int mei_hbm_prop_req(struct mei_device *dev)
 	prop_req->address = next_client_index;
 
 	if (mei_write_message(dev, mei_hdr, dev->wr_msg.data)) {
-		dev->dev_state = MEI_DEV_RESETING;
+		dev->dev_state = MEI_DEV_RESETTING;
 		dev_err(&dev->pdev->dev, "Properties request command failed\n");
 		mei_reset(dev, 1);
 
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 642c622..4460a3e 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -452,7 +452,7 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 
 	/* check if ME wants a reset */
 	if (!mei_hw_is_ready(dev) &&
-	    dev->dev_state != MEI_DEV_RESETING &&
+	    dev->dev_state != MEI_DEV_RESETTING &&
 	    dev->dev_state != MEI_DEV_INITIALIZING) {
 		dev_dbg(&dev->pdev->dev, "FW not ready.\n");
 		mei_reset(dev, 1);
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 3561799..cb58f72 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -31,7 +31,7 @@ const char *mei_dev_state_str(int state)
 	MEI_DEV_STATE(INITIALIZING);
 	MEI_DEV_STATE(INIT_CLIENTS);
 	MEI_DEV_STATE(ENABLED);
-	MEI_DEV_STATE(RESETING);
+	MEI_DEV_STATE(RESETTING);
 	MEI_DEV_STATE(DISABLED);
 	MEI_DEV_STATE(RECOVERING_FROM_RESET);
 	MEI_DEV_STATE(POWER_DOWN);
@@ -151,7 +151,7 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 	if (dev->dev_state != MEI_DEV_INITIALIZING) {
 		if (dev->dev_state != MEI_DEV_DISABLED &&
 		    dev->dev_state != MEI_DEV_POWER_DOWN)
-			dev->dev_state = MEI_DEV_RESETING;
+			dev->dev_state = MEI_DEV_RESETTING;
 
 		mei_cl_all_disconnect(dev);
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 9787381..77a584b 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -95,7 +95,7 @@ enum mei_dev_state {
 	MEI_DEV_INITIALIZING = 0,
 	MEI_DEV_INIT_CLIENTS,
 	MEI_DEV_ENABLED,
-	MEI_DEV_RESETING,
+	MEI_DEV_RESETTING,
 	MEI_DEV_DISABLED,
 	MEI_DEV_RECOVERING_FROM_RESET,
 	MEI_DEV_POWER_DOWN,
-- 
1.8.1.4

