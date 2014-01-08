Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbaAHUck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:32:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:15427 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757183AbaAHUci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:32:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,626,1384329600"; 
   d="scan'208";a="463717286"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: fix syntax in comments and debug output
Date: Wed,  8 Jan 2014 22:31:46 +0200
Message-Id: <1389213106-19536-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Fix syntax errors in comments and debug strings

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    |  4 ++--
 drivers/misc/mei/client.c    | 22 +++++++++++-----------
 drivers/misc/mei/debugfs.c   |  4 ++--
 drivers/misc/mei/hbm.c       | 18 +++++++++---------
 drivers/misc/mei/interrupt.c |  6 +++---
 drivers/misc/mei/main.c      |  2 +-
 drivers/misc/mei/mei_dev.h   |  4 ++--
 drivers/misc/mei/nfc.c       | 12 ++++++------
 8 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 29fcd57..2fad844 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -177,7 +177,7 @@ int mei_amthif_read(struct mei_device *dev, struct file *file,
 	unsigned long timeout;
 	int i;
 
-	/* Only Posible if we are in timeout */
+	/* Only possible if we are in timeout */
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
 
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 9b8975b..efdc9f4 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -154,7 +154,7 @@ int mei_io_cb_alloc_req_buf(struct mei_cl_cb *cb, size_t length)
 	return 0;
 }
 /**
- * mei_io_cb_alloc_resp_buf - allocate respose buffer
+ * mei_io_cb_alloc_resp_buf - allocate response buffer
  *
  * @cb: io callback structure
  * @length: size of the buffer
@@ -207,7 +207,7 @@ int mei_cl_flush_queues(struct mei_cl *cl)
 
 
 /**
- * mei_cl_init - initializes intialize cl.
+ * mei_cl_init - initializes cl.
  *
  * @cl: host client to be initialized
  * @dev: mei device
@@ -263,10 +263,10 @@ struct mei_cl_cb *mei_cl_find_read_cb(struct mei_cl *cl)
 	return NULL;
 }
 
-/** mei_cl_link: allocte host id in the host map
+/** mei_cl_link: allocate host id in the host map
  *
  * @cl - host client
- * @id - fixed host id or -1 for genereting one
+ * @id - fixed host id or -1 for generic one
  *
  * returns 0 on success
  *	-EINVAL on incorrect values
@@ -282,19 +282,19 @@ int mei_cl_link(struct mei_cl *cl, int id)
 
 	dev = cl->dev;
 
-	/* If Id is not asigned get one*/
+	/* If Id is not assigned get one*/
 	if (id == MEI_HOST_CLIENT_ID_ANY)
 		id = find_first_zero_bit(dev->host_clients_map,
 					MEI_CLIENTS_MAX);
 
 	if (id >= MEI_CLIENTS_MAX) {
-		dev_err(&dev->pdev->dev, "id exceded %d", MEI_CLIENTS_MAX) ;
+		dev_err(&dev->pdev->dev, "id exceeded %d", MEI_CLIENTS_MAX);
 		return -EMFILE;
 	}
 
 	open_handle_count = dev->open_handle_count + dev->iamthif_open_count;
 	if (open_handle_count >= MEI_MAX_OPEN_HANDLE_COUNT) {
-		dev_err(&dev->pdev->dev, "open_handle_count exceded %d",
+		dev_err(&dev->pdev->dev, "open_handle_count exceeded %d",
 			MEI_MAX_OPEN_HANDLE_COUNT);
 		return -EMFILE;
 	}
@@ -377,7 +377,7 @@ void mei_host_client_init(struct work_struct *work)
 
 
 /**
- * mei_cl_disconnect - disconnect host clinet form the me one
+ * mei_cl_disconnect - disconnect host client from the me one
  *
  * @cl: host client
  *
@@ -456,7 +456,7 @@ free:
  *
  * @cl: private data of the file object
  *
- * returns ture if other client is connected, 0 - otherwise.
+ * returns true if other client is connected, false - otherwise.
  */
 bool mei_cl_is_other_connecting(struct mei_cl *cl)
 {
@@ -480,7 +480,7 @@ bool mei_cl_is_other_connecting(struct mei_cl *cl)
 }
 
 /**
- * mei_cl_connect - connect host clinet to the me one
+ * mei_cl_connect - connect host client to the me one
  *
  * @cl: host client
  *
@@ -775,7 +775,7 @@ int mei_cl_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
  * @cl: host client
  * @cl: write callback with filled data
  *
- * returns numbe of bytes sent on success, <0 on failure.
+ * returns number of bytes sent on success, <0 on failure.
  */
 int mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, bool blocking)
 {
diff --git a/drivers/misc/mei/debugfs.c b/drivers/misc/mei/debugfs.c
index e3870f2..a3ae154 100644
--- a/drivers/misc/mei/debugfs.c
+++ b/drivers/misc/mei/debugfs.c
@@ -43,7 +43,7 @@ static ssize_t mei_dbgfs_read_meclients(struct file *fp, char __user *ubuf,
 
 	mutex_lock(&dev->device_lock);
 
-	/*  if the driver is not enabled the list won't b consitent */
+	/*  if the driver is not enabled the list won't be consistent */
 	if (dev->dev_state != MEI_DEV_ENABLED)
 		goto out;
 
@@ -101,7 +101,7 @@ static const struct file_operations mei_dbgfs_fops_devstate = {
 
 /**
  * mei_dbgfs_deregister - Remove the debugfs files and directories
- * @mei - pointer to mei device private dat
+ * @mei - pointer to mei device private data
  */
 void mei_dbgfs_deregister(struct mei_device *dev)
 {
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index e63eeb5..0aaf2c5 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -83,12 +83,12 @@ void mei_hbm_cl_hdr(struct mei_cl *cl, u8 hbm_cmd, void *buf, size_t len)
 }
 
 /**
- * same_disconn_addr - tells if they have the same address
+ * mei_hbm_cl_addr_equal - tells if they have the same address
  *
- * @file: private data of the file object.
- * @disconn: disconnection request.
+ * @cl: - client
+ * @buf: buffer with cl header
  *
- * returns true if addres are same
+ * returns true if addresses are the same
  */
 static inline
 bool mei_hbm_cl_addr_equal(struct mei_cl *cl, void *buf)
@@ -283,7 +283,7 @@ static int mei_hbm_prop_req(struct mei_device *dev)
 }
 
 /**
- * mei_hbm_stop_req_prepare - perpare stop request message
+ * mei_hbm_stop_req_prepare - prepare stop request message
  *
  * @dev - mei device
  * @mei_hdr - mei message header
@@ -304,7 +304,7 @@ static void mei_hbm_stop_req_prepare(struct mei_device *dev,
 }
 
 /**
- * mei_hbm_cl_flow_control_req - sends flow control requst.
+ * mei_hbm_cl_flow_control_req - sends flow control request.
  *
  * @dev: the device structure
  * @cl: client info
@@ -466,7 +466,7 @@ int mei_hbm_cl_connect_req(struct mei_device *dev, struct mei_cl *cl)
 }
 
 /**
- * mei_hbm_cl_connect_res - connect resposne from the ME
+ * mei_hbm_cl_connect_res - connect response from the ME
  *
  * @dev: the device structure
  * @rs: connect response bus message
@@ -520,8 +520,8 @@ static void mei_hbm_cl_connect_res(struct mei_device *dev,
 
 
 /**
- * mei_hbm_fw_disconnect_req - disconnect request initiated by me
- *  host sends disoconnect response
+ * mei_hbm_fw_disconnect_req - disconnect request initiated by ME firmware
+ *  host sends disconnect response
  *
  * @dev: the device structure.
  * @disconnect_req: disconnect request bus message from the me
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index b5ceba4..f0fbb51 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -31,7 +31,7 @@
 
 
 /**
- * mei_irq_compl_handler - dispatch complete handelers
+ * mei_irq_compl_handler - dispatch complete handlers
  *	for the completed callbacks
  *
  * @dev - mei device
@@ -338,7 +338,7 @@ int mei_irq_read_handler(struct mei_device *dev,
 		goto reset_slots;
 	}
 
-	/* find recepient cl */
+	/* find recipient cl */
 	list_for_each_entry(cl, &dev->file_list, link) {
 		if (mei_cl_hbm_equal(cl, mei_hdr)) {
 			cl_dbg(dev, cl, "got a message\n");
@@ -346,7 +346,7 @@ int mei_irq_read_handler(struct mei_device *dev,
 		}
 	}
 
-	/* if no recepient cl was found we assume corrupted header\n */
+	/* if no recipient cl was found we assume corrupted header */
 	if (&cl->link == &dev->file_list) {
 		dev_err(&dev->pdev->dev, "no destination client found 0x%08X\n",
 				dev->rd_msg_hdr);
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 9661a81..5424f8f 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -48,7 +48,7 @@
  *
  * @inode: pointer to inode structure
  * @file: pointer to file structure
- e
+ *
  * returns 0 on success, <0 on error
  */
 static int mei_open(struct inode *inode, struct file *file)
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index d3f4c5f..f7de95b 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -70,7 +70,7 @@ extern const uuid_le mei_wd_guid;
  * that can be opened to the driver.
  *
  * Limit to 255: 256 Total Clients
- * minus internal client for MEI Bus Messags
+ * minus internal client for MEI Bus Messages
  */
 #define  MEI_MAX_OPEN_HANDLE_COUNT (MEI_CLIENTS_MAX - 1)
 
@@ -186,7 +186,7 @@ struct mei_cl_cb {
 	u32 internal:1;
 };
 
-/* MEI client instance carried as file->pirvate_data*/
+/* MEI client instance carried as file->private_data*/
 struct mei_cl {
 	struct list_head link;
 	struct mei_device *dev;
diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 0a89220..7b052e2 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -92,7 +92,7 @@ struct mei_nfc_hci_hdr {
  * @cl: NFC host client
  * @cl_info: NFC info host client
  * @init_work: perform connection to the info client
- * @fw_ivn: NFC Intervace Version Number
+ * @fw_ivn: NFC Interface Version Number
  * @vendor_id: NFC manufacturer ID
  * @radio_type: NFC radio type
  */
@@ -163,7 +163,7 @@ static int mei_nfc_build_bus_name(struct mei_nfc_dev *ndev)
 			return 0;
 
 		default:
-			dev_err(&dev->pdev->dev, "Unknow radio type 0x%x\n",
+			dev_err(&dev->pdev->dev, "Unknown radio type 0x%x\n",
 				ndev->radio_type);
 
 			return -EINVAL;
@@ -175,14 +175,14 @@ static int mei_nfc_build_bus_name(struct mei_nfc_dev *ndev)
 			ndev->bus_name = "pn544";
 			return 0;
 		default:
-			dev_err(&dev->pdev->dev, "Unknow radio type 0x%x\n",
+			dev_err(&dev->pdev->dev, "Unknown radio type 0x%x\n",
 				ndev->radio_type);
 
 			return -EINVAL;
 		}
 
 	default:
-		dev_err(&dev->pdev->dev, "Unknow vendor ID 0x%x\n",
+		dev_err(&dev->pdev->dev, "Unknown vendor ID 0x%x\n",
 			ndev->vendor_id);
 
 		return -EINVAL;
@@ -428,7 +428,7 @@ static void mei_nfc_init(struct work_struct *work)
 	mutex_unlock(&dev->device_lock);
 
 	if (mei_nfc_if_version(ndev) < 0) {
-		dev_err(&dev->pdev->dev, "Could not get the NFC interfave version");
+		dev_err(&dev->pdev->dev, "Could not get the NFC interface version");
 
 		goto err;
 	}
@@ -481,7 +481,7 @@ int mei_nfc_host_init(struct mei_device *dev)
 	struct mei_cl *cl_info, *cl = NULL;
 	int i, ret;
 
-	/* already initialzed */
+	/* already initialized */
 	if (ndev->cl_info)
 		return 0;
 
-- 
1.8.4.2

