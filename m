Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab3KWPg2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 10:36:28 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:37862 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab3KWPgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 10:36:23 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, tomas.winkler@intel.com
Cc: rdunlap@infradead.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 3/3] [trivial] mei: Fix typo in mei drivers
Date: Sun, 24 Nov 2013 00:36:14 +0900
Message-Id: <1385220974-3469-3-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.5.rc1.28.g7061504
In-Reply-To: <1385220974-3469-1-git-send-email-standby24x7@gmail.com>
References: <1385220974-3469-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in comments within mei.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/misc/mei/amthif.c  |  4 ++--
 drivers/misc/mei/debugfs.c |  2 +-
 drivers/misc/mei/hbm.c     | 12 ++++++------
 drivers/misc/mei/mei_dev.h |  2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index d22c686..71971ef 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -177,7 +177,7 @@ int mei_amthif_read(struct mei_device *dev, struct file *file,
 	unsigned long timeout;
 	int i;
 
-	/* Only Posible if we are in timeout */
+	/* Only Possible if we are in timeout */
 	if (!cl || cl != &dev->iamthif_cl) {
 		dev_dbg(&dev->pdev->dev, "bad file ext.\n");
 		return -ETIMEDOUT;
@@ -249,7 +249,7 @@ int mei_amthif_read(struct mei_device *dev, struct file *file,
 	    cb->response_buffer.size);
 	dev_dbg(&dev->pdev->dev, "amthif cb->buf_idx - %lu\n", cb->buf_idx);
 
-	/* length is being turncated to PAGE_SIZE, however,
+	/* length is being truncated to PAGE_SIZE, however,
 	 * the buf_idx may point beyond */
 	length = min_t(size_t, length, (cb->buf_idx - *offset));
 
diff --git a/drivers/misc/mei/debugfs.c b/drivers/misc/mei/debugfs.c
index e3870f2..10b172a 100644
--- a/drivers/misc/mei/debugfs.c
+++ b/drivers/misc/mei/debugfs.c
@@ -43,7 +43,7 @@ static ssize_t mei_dbgfs_read_meclients(struct file *fp, char __user *ubuf,
 
 	mutex_lock(&dev->device_lock);
 
-	/*  if the driver is not enabled the list won't b consitent */
+	/*  if the driver is not enabled the list won't b consistent */
 	if (dev->dev_state != MEI_DEV_ENABLED)
 		goto out;
 
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 9b3a0fb..96fed82 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -90,7 +90,7 @@ void mei_hbm_cl_hdr(struct mei_cl *cl, u8 hbm_cmd, void *buf, size_t len)
  * @file: private data of the file object.
  * @disconn: disconnection request.
  *
- * returns true if addres are same
+ * returns true if address are same
  */
 static inline
 bool mei_hbm_cl_addr_equal(struct mei_cl *cl, void *buf)
@@ -268,7 +268,7 @@ static int mei_hbm_prop_req(struct mei_device *dev)
 }
 
 /**
- * mei_hbm_stop_req_prepare - perpare stop request message
+ * mei_hbm_stop_req_prepare - prepare stop request message
  *
  * @dev - mei device
  * @mei_hdr - mei message header
@@ -289,7 +289,7 @@ static void mei_hbm_stop_req_prepare(struct mei_device *dev,
 }
 
 /**
- * mei_hbm_cl_flow_control_req - sends flow control requst.
+ * mei_hbm_cl_flow_control_req - sends flow control request.
  *
  * @dev: the device structure
  * @cl: client info
@@ -451,7 +451,7 @@ int mei_hbm_cl_connect_req(struct mei_device *dev, struct mei_cl *cl)
 }
 
 /**
- * mei_hbm_cl_connect_res - connect resposne from the ME
+ * mei_hbm_cl_connect_res - connect response from the ME
  *
  * @dev: the device structure
  * @rs: connect response bus message
@@ -506,7 +506,7 @@ static void mei_hbm_cl_connect_res(struct mei_device *dev,
 
 /**
  * mei_hbm_fw_disconnect_req - disconnect request initiated by me
- *  host sends disoconnect response
+ *  host sends disconnect response
  *
  * @dev: the device structure.
  * @disconnect_req: disconnect request bus message from the me
@@ -687,7 +687,7 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 				mei_hbm_me_cl_allocate(dev);
 				dev->hbm_state = MEI_HBM_CLIENT_PROPERTIES;
 
-				/* first property reqeust */
+				/* first property request */
 				mei_hbm_prop_req(dev);
 		} else {
 			dev_err(&dev->pdev->dev, "reset: unexpected enumeration response hbm.\n");
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 406f68e..a994190 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -65,7 +65,7 @@ extern const uuid_le mei_wd_guid;
  * that can be opened to the driver.
  *
  * Limit to 255: 256 Total Clients
- * minus internal client for MEI Bus Messags
+ * minus internal client for MEI Bus Messages
  */
 #define  MEI_MAX_OPEN_HANDLE_COUNT (MEI_CLIENTS_MAX - 1)
 
-- 
1.8.5.rc1.28.g7061504

