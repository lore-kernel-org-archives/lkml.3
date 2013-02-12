Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847Ab3BLSjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:39:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:21154 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933597Ab3BLSiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:38:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="261638051"
From: Samuel Ortiz <sameo@linux.intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [char-misc-next 01/12 v3] mei: Rename mei_device to mei_host
Date: Tue, 12 Feb 2013 19:36:51 +0100
Message-Id: <1360694222-27632-2-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
References: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for the MEI bus code merge, we rename the mei_device
structure to mei_host.
struct mei_device will be used for devices on the MEI bus in order to follow
exisiting driver model implementations practices.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/misc/mei/amthif.c    |   30 ++++++------
 drivers/misc/mei/client.c    |   36 +++++++-------
 drivers/misc/mei/client.h    |   14 +++---
 drivers/misc/mei/hbm.c       |   28 +++++------
 drivers/misc/mei/hbm.h       |   10 ++--
 drivers/misc/mei/hw-me.c     |   42 ++++++++--------
 drivers/misc/mei/hw-me.h     |    2 +-
 drivers/misc/mei/init.c      |    6 +--
 drivers/misc/mei/interrupt.c |   18 +++----
 drivers/misc/mei/main.c      |   14 +++---
 drivers/misc/mei/mei_dev.h   |  110 +++++++++++++++++++++---------------------
 drivers/misc/mei/pci-me.c    |    8 +--
 drivers/misc/mei/wd.c        |   20 ++++----
 13 files changed, 169 insertions(+), 169 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index c86d7e3..6f67a0a 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -47,7 +47,7 @@ const uuid_le mei_amthif_guid  = UUID_LE(0x12f80028, 0xb4b7, 0x4b2d,
  *
  * @dev: the device structure
  */
-void mei_amthif_reset_params(struct mei_device *dev)
+void mei_amthif_reset_params(struct mei_host *dev)
 {
 	/* reset iamthif parameters. */
 	dev->iamthif_current_cb = NULL;
@@ -65,7 +65,7 @@ void mei_amthif_reset_params(struct mei_device *dev)
  * @dev: the device structure
  *
  */
-int mei_amthif_host_init(struct mei_device *dev)
+int mei_amthif_host_init(struct mei_host *dev)
 {
 	struct mei_cl *cl = &dev->iamthif_cl;
 	unsigned char *msg_buf;
@@ -129,7 +129,7 @@ int mei_amthif_host_init(struct mei_device *dev)
  *
  * returns   returned a list entry on success, NULL on failure.
  */
-struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_device *dev,
+struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_host *dev,
 						struct file *file)
 {
 	struct mei_cl_cb *pos = NULL;
@@ -162,7 +162,7 @@ struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_device *dev,
  *  zero if no data to read,
  *  negative on failure.
  */
-int mei_amthif_read(struct mei_device *dev, struct file *file,
+int mei_amthif_read(struct mei_host *dev, struct file *file,
 	       char __user *ubuf, size_t length, loff_t *offset)
 {
 	int rets;
@@ -274,7 +274,7 @@ out:
  * returns 0 on success, <0 on failure.
  *
  */
-static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
+static int mei_amthif_send_cmd(struct mei_host *dev, struct mei_cl_cb *cb)
 {
 	struct mei_msg_hdr mei_hdr;
 	int ret;
@@ -348,7 +348,7 @@ static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
  * returns 0 on success, <0 on failure.
  *
  */
-int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *cb)
+int mei_amthif_write(struct mei_host *dev, struct mei_cl_cb *cb)
 {
 	int ret;
 
@@ -378,7 +378,7 @@ int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *cb)
  *
  * returns 0 on success, <0 on failure.
  */
-void mei_amthif_run_next_cmd(struct mei_device *dev)
+void mei_amthif_run_next_cmd(struct mei_host *dev)
 {
 	struct mei_cl_cb *pos = NULL;
 	struct mei_cl_cb *next = NULL;
@@ -414,7 +414,7 @@ void mei_amthif_run_next_cmd(struct mei_device *dev)
 }
 
 
-unsigned int mei_amthif_poll(struct mei_device *dev,
+unsigned int mei_amthif_poll(struct mei_host *dev,
 		struct file *file, poll_table *wait)
 {
 	unsigned int mask = 0;
@@ -443,7 +443,7 @@ unsigned int mei_amthif_poll(struct mei_device *dev,
  *
  * returns 0, OK; otherwise, error.
  */
-int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
+int mei_amthif_irq_write_complete(struct mei_host *dev, s32 *slots,
 			struct mei_cl_cb *cb, struct mei_cl_cb *cmpl_list)
 {
 	struct mei_msg_hdr mei_hdr;
@@ -512,7 +512,7 @@ int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
  * returns 0 on success, <0 on failure.
  */
 int mei_amthif_irq_read_message(struct mei_cl_cb *complete_list,
-		struct mei_device *dev, struct mei_msg_hdr *mei_hdr)
+		struct mei_host *dev, struct mei_msg_hdr *mei_hdr)
 {
 	struct mei_cl_cb *cb;
 	unsigned char *buffer;
@@ -564,7 +564,7 @@ int mei_amthif_irq_read_message(struct mei_cl_cb *complete_list,
  *
  * returns 0, OK; otherwise, error.
  */
-int mei_amthif_irq_read(struct mei_device *dev, s32 *slots)
+int mei_amthif_irq_read(struct mei_host *dev, s32 *slots)
 {
 
 	if (((*slots) * sizeof(u32)) < (sizeof(struct mei_msg_hdr)
@@ -593,7 +593,7 @@ int mei_amthif_irq_read(struct mei_device *dev, s32 *slots)
  * @dev: the device structure.
  * @cb_pos: callback block.
  */
-void mei_amthif_complete(struct mei_device *dev, struct mei_cl_cb *cb)
+void mei_amthif_complete(struct mei_host *dev, struct mei_cl_cb *cb)
 {
 	if (dev->iamthif_canceled != 1) {
 		dev->iamthif_state = MEI_IAMTHIF_READ_COMPLETE;
@@ -627,7 +627,7 @@ void mei_amthif_complete(struct mei_device *dev, struct mei_cl_cb *cb)
  *
  * returns true if callback removed from the list, false otherwise
  */
-static bool mei_clear_list(struct mei_device *dev,
+static bool mei_clear_list(struct mei_host *dev,
 		const struct file *file, struct list_head *mei_cb_list)
 {
 	struct mei_cl_cb *cb_pos = NULL;
@@ -667,7 +667,7 @@ static bool mei_clear_list(struct mei_device *dev,
  *
  * returns true if callback removed from the list, false otherwise
  */
-static bool mei_clear_lists(struct mei_device *dev, struct file *file)
+static bool mei_clear_lists(struct mei_host *dev, struct file *file)
 {
 	bool removed = false;
 
@@ -708,7 +708,7 @@ static bool mei_clear_lists(struct mei_device *dev, struct file *file)
 *
 *  returns 0 on success, <0 on error
 */
-int mei_amthif_release(struct mei_device *dev, struct file *file)
+int mei_amthif_release(struct mei_host *dev, struct file *file)
 {
 	if (dev->open_handle_count > 0)
 		dev->open_handle_count--;
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 1569afe..79eda18 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -31,7 +31,7 @@
  * @dev: mei device
  * returns me client index or -ENOENT if not found
  */
-int mei_me_cl_by_uuid(const struct mei_device *dev, const uuid_le *uuid)
+int mei_me_cl_by_uuid(const struct mei_host *dev, const uuid_le *uuid)
 {
 	int i, res = -ENOENT;
 
@@ -57,7 +57,7 @@ int mei_me_cl_by_uuid(const struct mei_device *dev, const uuid_le *uuid)
  * returns index on success, -ENOENT on failure.
  */
 
-int mei_me_cl_by_id(struct mei_device *dev, u8 client_id)
+int mei_me_cl_by_id(struct mei_host *dev, u8 client_id)
 {
 	int i;
 	for (i = 0; i < dev->me_clients_num; i++)
@@ -209,7 +209,7 @@ int mei_cl_flush_queues(struct mei_cl *cl)
  * @cl: host client to be initialized
  * @dev: mei device
  */
-void mei_cl_init(struct mei_cl *cl, struct mei_device *dev)
+void mei_cl_init(struct mei_cl *cl, struct mei_host *dev)
 {
 	memset(cl, 0, sizeof(struct mei_cl));
 	init_waitqueue_head(&cl->wait);
@@ -227,7 +227,7 @@ void mei_cl_init(struct mei_cl *cl, struct mei_device *dev)
  * @dev: mei device
  * returns  The allocated file or NULL on failure
  */
-struct mei_cl *mei_cl_allocate(struct mei_device *dev)
+struct mei_cl *mei_cl_allocate(struct mei_host *dev)
 {
 	struct mei_cl *cl;
 
@@ -248,7 +248,7 @@ struct mei_cl *mei_cl_allocate(struct mei_device *dev)
  */
 struct mei_cl_cb *mei_cl_find_read_cb(struct mei_cl *cl)
 {
-	struct mei_device *dev = cl->dev;
+	struct mei_host *dev = cl->dev;
 	struct mei_cl_cb *cb = NULL;
 	struct mei_cl_cb *next = NULL;
 
@@ -268,7 +268,7 @@ struct mei_cl_cb *mei_cl_find_read_cb(struct mei_cl *cl)
  */
 int mei_cl_link(struct mei_cl *cl, int id)
 {
-	struct mei_device *dev;
+	struct mei_host *dev;
 
 	if (WARN_ON(!cl || !cl->dev))
 		return -EINVAL;
@@ -305,7 +305,7 @@ int mei_cl_link(struct mei_cl *cl, int id)
  */
 int mei_cl_unlink(struct mei_cl *cl)
 {
-	struct mei_device *dev;
+	struct mei_host *dev;
 	struct mei_cl *pos, *next;
 
 	/* don't shout on error exit path */
@@ -332,8 +332,8 @@ int mei_cl_unlink(struct mei_cl *cl)
 
 void mei_host_client_init(struct work_struct *work)
 {
-	struct mei_device *dev = container_of(work,
-					      struct mei_device, init_work);
+	struct mei_host *dev = container_of(work,
+					      struct mei_host, init_work);
 	struct mei_client_properties *client_props;
 	int i;
 
@@ -376,7 +376,7 @@ void mei_host_client_init(struct work_struct *work)
  */
 int mei_cl_disconnect(struct mei_cl *cl)
 {
-	struct mei_device *dev;
+	struct mei_host *dev;
 	struct mei_cl_cb *cb;
 	int rets, err;
 
@@ -448,7 +448,7 @@ free:
  */
 bool mei_cl_is_other_connecting(struct mei_cl *cl)
 {
-	struct mei_device *dev;
+	struct mei_host *dev;
 	struct mei_cl *pos;
 	struct mei_cl *next;
 
@@ -478,7 +478,7 @@ bool mei_cl_is_other_connecting(struct mei_cl *cl)
  */
 int mei_cl_connect(struct mei_cl *cl, struct file *file)
 {
-	struct mei_device *dev;
+	struct mei_host *dev;
 	struct mei_cl_cb *cb;
 	long timeout = mei_secs_to_jiffies(MEI_CL_CONNECT_TIMEOUT);
 	int rets;
@@ -543,7 +543,7 @@ out:
  */
 int mei_cl_flow_ctrl_creds(struct mei_cl *cl)
 {
-	struct mei_device *dev;
+	struct mei_host *dev;
 	int i;
 
 	if (WARN_ON(!cl || !cl->dev))
@@ -584,7 +584,7 @@ int mei_cl_flow_ctrl_creds(struct mei_cl *cl)
  */
 int mei_cl_flow_ctrl_reduce(struct mei_cl *cl)
 {
-	struct mei_device *dev;
+	struct mei_host *dev;
 	int i;
 
 	if (WARN_ON(!cl || !cl->dev))
@@ -622,7 +622,7 @@ int mei_cl_flow_ctrl_reduce(struct mei_cl *cl)
  */
 int mei_cl_read_start(struct mei_cl *cl)
 {
-	struct mei_device *dev;
+	struct mei_host *dev;
 	struct mei_cl_cb *cb;
 	int rets;
 	int i;
@@ -682,7 +682,7 @@ err:
  * @dev - mei device
  */
 
-void mei_cl_all_disconnect(struct mei_device *dev)
+void mei_cl_all_disconnect(struct mei_host *dev)
 {
 	struct mei_cl *cl, *next;
 
@@ -700,7 +700,7 @@ void mei_cl_all_disconnect(struct mei_device *dev)
  *
  * @dev  - mei device
  */
-void mei_cl_all_read_wakeup(struct mei_device *dev)
+void mei_cl_all_read_wakeup(struct mei_host *dev)
 {
 	struct mei_cl *cl, *next;
 	list_for_each_entry_safe(cl, next, &dev->file_list, link) {
@@ -716,7 +716,7 @@ void mei_cl_all_read_wakeup(struct mei_device *dev)
 
  * @dev - mei device
  */
-void mei_cl_all_write_clear(struct mei_device *dev)
+void mei_cl_all_write_clear(struct mei_host *dev)
 {
 	struct mei_cl_cb *cb, *next;
 
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index 214b239..9db03b0 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -24,8 +24,8 @@
 
 #include "mei_dev.h"
 
-int mei_me_cl_by_uuid(const struct mei_device *dev, const uuid_le *cuuid);
-int mei_me_cl_by_id(struct mei_device *dev, u8 client_id);
+int mei_me_cl_by_uuid(const struct mei_host *dev, const uuid_le *cuuid);
+int mei_me_cl_by_id(struct mei_host *dev, u8 client_id);
 
 /*
  * MEI IO Functions
@@ -51,8 +51,8 @@ void mei_io_list_flush(struct mei_cl_cb *list, struct mei_cl *cl);
  * MEI Host Client Functions
  */
 
-struct mei_cl *mei_cl_allocate(struct mei_device *dev);
-void mei_cl_init(struct mei_cl *cl, struct mei_device *dev);
+struct mei_cl *mei_cl_allocate(struct mei_host *dev);
+void mei_cl_init(struct mei_cl *cl, struct mei_host *dev);
 
 
 int mei_cl_link(struct mei_cl *cl, int id);
@@ -94,9 +94,9 @@ int mei_cl_connect(struct mei_cl *cl, struct file *file);
 void mei_host_client_init(struct work_struct *work);
 
 
-void mei_cl_all_disconnect(struct mei_device *dev);
-void mei_cl_all_read_wakeup(struct mei_device *dev);
-void mei_cl_all_write_clear(struct mei_device *dev);
+void mei_cl_all_disconnect(struct mei_host *dev);
+void mei_cl_all_read_wakeup(struct mei_host *dev);
+void mei_cl_all_write_clear(struct mei_host *dev);
 
 
 #endif /* _MEI_CLIENT_H_ */
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index fb9e63b..e71eb35 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -30,7 +30,7 @@
  *
  * returns none.
  */
-static void mei_hbm_me_cl_allocate(struct mei_device *dev)
+static void mei_hbm_me_cl_allocate(struct mei_host *dev)
 {
 	struct mei_me_client *clients;
 	int b;
@@ -128,7 +128,7 @@ static bool is_treat_specially_client(struct mei_cl *cl,
  *
  * @dev: the device structure
  */
-void mei_hbm_start_req(struct mei_device *dev)
+void mei_hbm_start_req(struct mei_host *dev)
 {
 	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	struct hbm_host_version_request *start_req;
@@ -161,7 +161,7 @@ void mei_hbm_start_req(struct mei_device *dev)
  *
  * returns none.
  */
-static void mei_hbm_enum_clients_req(struct mei_device *dev)
+static void mei_hbm_enum_clients_req(struct mei_host *dev)
 {
 	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	struct hbm_host_enum_request *enum_req;
@@ -191,7 +191,7 @@ static void mei_hbm_enum_clients_req(struct mei_device *dev)
  * returns none.
  */
 
-static int mei_hbm_prop_req(struct mei_device *dev)
+static int mei_hbm_prop_req(struct mei_host *dev)
 {
 
 	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
@@ -246,7 +246,7 @@ static int mei_hbm_prop_req(struct mei_device *dev)
  * @mei_hdr - mei message header
  * @data - hbm message body buffer
  */
-static void mei_hbm_stop_req_prepare(struct mei_device *dev,
+static void mei_hbm_stop_req_prepare(struct mei_host *dev,
 		struct mei_msg_hdr *mei_hdr, unsigned char *data)
 {
 	struct hbm_host_stop_request *req =
@@ -268,7 +268,7 @@ static void mei_hbm_stop_req_prepare(struct mei_device *dev,
  *
  * This function returns -EIO on write failure
  */
-int mei_hbm_cl_flow_control_req(struct mei_device *dev, struct mei_cl *cl)
+int mei_hbm_cl_flow_control_req(struct mei_host *dev, struct mei_cl *cl)
 {
 	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	const size_t len = sizeof(struct hbm_flow_control);
@@ -288,7 +288,7 @@ int mei_hbm_cl_flow_control_req(struct mei_device *dev, struct mei_cl *cl)
  * @file: private data ot the file object.
  * @flow: flow control.
  */
-static void mei_hbm_add_single_flow_creds(struct mei_device *dev,
+static void mei_hbm_add_single_flow_creds(struct mei_host *dev,
 				  struct hbm_flow_control *flow)
 {
 	struct mei_me_client *client;
@@ -316,7 +316,7 @@ static void mei_hbm_add_single_flow_creds(struct mei_device *dev,
  * @dev: the device structure
  * @flow_control: flow control response bus message
  */
-static void mei_hbm_cl_flow_control_res(struct mei_device *dev,
+static void mei_hbm_cl_flow_control_res(struct mei_host *dev,
 		struct hbm_flow_control *flow_control)
 {
 	struct mei_cl *cl = NULL;
@@ -350,7 +350,7 @@ static void mei_hbm_cl_flow_control_res(struct mei_device *dev,
  *
  * This function returns -EIO on write failure
  */
-int mei_hbm_cl_disconnect_req(struct mei_device *dev, struct mei_cl *cl)
+int mei_hbm_cl_disconnect_req(struct mei_host *dev, struct mei_cl *cl)
 {
 	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	const size_t len = sizeof(struct hbm_client_connect_request);
@@ -367,7 +367,7 @@ int mei_hbm_cl_disconnect_req(struct mei_device *dev, struct mei_cl *cl)
  * @dev: the device structure
  * @rs: disconnect response bus message
  */
-static void mei_hbm_cl_disconnect_res(struct mei_device *dev,
+static void mei_hbm_cl_disconnect_res(struct mei_host *dev,
 		struct hbm_client_connect_response *rs)
 {
 	struct mei_cl *cl;
@@ -411,7 +411,7 @@ static void mei_hbm_cl_disconnect_res(struct mei_device *dev,
  *
  * returns -EIO on write failure
  */
-int mei_hbm_cl_connect_req(struct mei_device *dev, struct mei_cl *cl)
+int mei_hbm_cl_connect_req(struct mei_host *dev, struct mei_cl *cl)
 {
 	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	const size_t len = sizeof(struct hbm_client_connect_request);
@@ -428,7 +428,7 @@ int mei_hbm_cl_connect_req(struct mei_device *dev, struct mei_cl *cl)
  * @dev: the device structure
  * @rs: connect response bus message
  */
-static void mei_hbm_cl_connect_res(struct mei_device *dev,
+static void mei_hbm_cl_connect_res(struct mei_host *dev,
 		struct hbm_client_connect_response *rs)
 {
 
@@ -483,7 +483,7 @@ static void mei_hbm_cl_connect_res(struct mei_device *dev,
  * @dev: the device structure.
  * @disconnect_req: disconnect request bus message from the me
  */
-static void mei_hbm_fw_disconnect_req(struct mei_device *dev,
+static void mei_hbm_fw_disconnect_req(struct mei_host *dev,
 		struct hbm_client_connect_request *disconnect_req)
 {
 	struct mei_cl *cl, *next;
@@ -518,7 +518,7 @@ static void mei_hbm_fw_disconnect_req(struct mei_device *dev,
  * @dev: the device structure
  * @mei_hdr: header of bus message
  */
-void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
+void mei_hbm_dispatch(struct mei_host *dev, struct mei_msg_hdr *hdr)
 {
 	struct mei_bus_message *mei_msg;
 	struct mei_me_client *me_client;
diff --git a/drivers/misc/mei/hbm.h b/drivers/misc/mei/hbm.h
index b552afb..ef87c98 100644
--- a/drivers/misc/mei/hbm.h
+++ b/drivers/misc/mei/hbm.h
@@ -17,7 +17,7 @@
 #ifndef _MEI_HBM_H_
 #define _MEI_HBM_H_
 
-void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr);
+void mei_hbm_dispatch(struct mei_host *dev, struct mei_msg_hdr *hdr);
 
 static inline void mei_hbm_hdr(struct mei_msg_hdr *hdr, size_t length)
 {
@@ -28,11 +28,11 @@ static inline void mei_hbm_hdr(struct mei_msg_hdr *hdr, size_t length)
 	hdr->reserved = 0;
 }
 
-void mei_hbm_start_req(struct mei_device *dev);
+void mei_hbm_start_req(struct mei_host *dev);
 
-int mei_hbm_cl_flow_control_req(struct mei_device *dev, struct mei_cl *cl);
-int mei_hbm_cl_disconnect_req(struct mei_device *dev, struct mei_cl *cl);
-int mei_hbm_cl_connect_req(struct mei_device *dev, struct mei_cl *cl);
+int mei_hbm_cl_flow_control_req(struct mei_host *dev, struct mei_cl *cl);
+int mei_hbm_cl_disconnect_req(struct mei_host *dev, struct mei_cl *cl);
+int mei_hbm_cl_connect_req(struct mei_host *dev, struct mei_cl *cl);
 
 
 #endif /* _MEI_HBM_H_ */
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 45ea718..ebd8621 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -61,7 +61,7 @@ static inline void mei_reg_write(const struct mei_me_hw *hw,
  *
  * returns ME_CB_RW register value (u32)
  */
-static u32 mei_me_mecbrw_read(const struct mei_device *dev)
+static u32 mei_me_mecbrw_read(const struct mei_host *dev)
 {
 	return mei_reg_read(to_me_hw(dev), ME_CB_RW);
 }
@@ -107,7 +107,7 @@ static inline void mei_hcsr_set(struct mei_me_hw *hw, u32 hcsr)
  *
  * @dev: mei device
  */
-static void mei_me_hw_config(struct mei_device *dev)
+static void mei_me_hw_config(struct mei_host *dev)
 {
 	u32 hcsr = mei_hcsr_read(to_me_hw(dev));
 	/* Doesn't change in runtime */
@@ -118,7 +118,7 @@ static void mei_me_hw_config(struct mei_device *dev)
  *
  * @dev: the device structure
  */
-static void mei_me_intr_clear(struct mei_device *dev)
+static void mei_me_intr_clear(struct mei_host *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
 	u32 hcsr = mei_hcsr_read(hw);
@@ -130,7 +130,7 @@ static void mei_me_intr_clear(struct mei_device *dev)
  *
  * @dev: the device structure
  */
-static void mei_me_intr_enable(struct mei_device *dev)
+static void mei_me_intr_enable(struct mei_host *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
 	u32 hcsr = mei_hcsr_read(hw);
@@ -143,7 +143,7 @@ static void mei_me_intr_enable(struct mei_device *dev)
  *
  * @dev: the device structure
  */
-static void mei_me_intr_disable(struct mei_device *dev)
+static void mei_me_intr_disable(struct mei_host *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
 	u32 hcsr = mei_hcsr_read(hw);
@@ -157,7 +157,7 @@ static void mei_me_intr_disable(struct mei_device *dev)
  * @dev: the device structure
  * @interrupts_enabled: if interrupt should be enabled after reset.
  */
-static void mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
+static void mei_me_hw_reset(struct mei_host *dev, bool intr_enable)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
 	u32 hcsr = mei_hcsr_read(hw);
@@ -190,7 +190,7 @@ static void mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
  * returns bool
  */
 
-static void mei_me_host_set_ready(struct mei_device *dev)
+static void mei_me_host_set_ready(struct mei_host *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
 	hw->host_hw_state |= H_IE | H_IG | H_RDY;
@@ -202,7 +202,7 @@ static void mei_me_host_set_ready(struct mei_device *dev)
  * @dev - mei device
  * returns bool
  */
-static bool mei_me_host_is_ready(struct mei_device *dev)
+static bool mei_me_host_is_ready(struct mei_host *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
 	hw->host_hw_state = mei_hcsr_read(hw);
@@ -215,7 +215,7 @@ static bool mei_me_host_is_ready(struct mei_device *dev)
  * @dev - mei device
  * returns bool
  */
-static bool mei_me_hw_is_ready(struct mei_device *dev)
+static bool mei_me_hw_is_ready(struct mei_host *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
 	hw->me_hw_state = mei_mecsr_read(hw);
@@ -229,7 +229,7 @@ static bool mei_me_hw_is_ready(struct mei_device *dev)
  *
  * returns number of filled slots
  */
-static unsigned char mei_hbuf_filled_slots(struct mei_device *dev)
+static unsigned char mei_hbuf_filled_slots(struct mei_host *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
 	char read_ptr, write_ptr;
@@ -249,7 +249,7 @@ static unsigned char mei_hbuf_filled_slots(struct mei_device *dev)
  *
  * returns true if empty, false - otherwise.
  */
-static bool mei_me_hbuf_is_empty(struct mei_device *dev)
+static bool mei_me_hbuf_is_empty(struct mei_host *dev)
 {
 	return mei_hbuf_filled_slots(dev) == 0;
 }
@@ -261,7 +261,7 @@ static bool mei_me_hbuf_is_empty(struct mei_device *dev)
  *
  * returns -1(ESLOTS_OVERFLOW) if overflow, otherwise empty slots count
  */
-static int mei_me_hbuf_empty_slots(struct mei_device *dev)
+static int mei_me_hbuf_empty_slots(struct mei_host *dev)
 {
 	unsigned char filled_slots, empty_slots;
 
@@ -275,7 +275,7 @@ static int mei_me_hbuf_empty_slots(struct mei_device *dev)
 	return empty_slots;
 }
 
-static size_t mei_me_hbuf_max_len(const struct mei_device *dev)
+static size_t mei_me_hbuf_max_len(const struct mei_host *dev)
 {
 	return dev->hbuf_depth * sizeof(u32) - sizeof(struct mei_msg_hdr);
 }
@@ -290,7 +290,7 @@ static size_t mei_me_hbuf_max_len(const struct mei_device *dev)
  *
  * This function returns -EIO if write has failed
  */
-static int mei_me_write_message(struct mei_device *dev,
+static int mei_me_write_message(struct mei_host *dev,
 			struct mei_msg_hdr *header,
 			unsigned char *buf)
 {
@@ -338,7 +338,7 @@ static int mei_me_write_message(struct mei_device *dev,
  *
  * returns -1(ESLOTS_OVERFLOW) if overflow, otherwise filled slots count
  */
-static int mei_me_count_full_read_slots(struct mei_device *dev)
+static int mei_me_count_full_read_slots(struct mei_host *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
 	char read_ptr, write_ptr;
@@ -365,7 +365,7 @@ static int mei_me_count_full_read_slots(struct mei_device *dev)
  * @buffer: message buffer will be written
  * @buffer_length: message size will be read
  */
-static int mei_me_read_slots(struct mei_device *dev, unsigned char *buffer,
+static int mei_me_read_slots(struct mei_host *dev, unsigned char *buffer,
 		    unsigned long buffer_length)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
@@ -396,7 +396,7 @@ static int mei_me_read_slots(struct mei_device *dev, unsigned char *buffer,
 
 irqreturn_t mei_me_irq_quick_handler(int irq, void *dev_id)
 {
-	struct mei_device *dev = (struct mei_device *) dev_id;
+	struct mei_host *dev = (struct mei_host *) dev_id;
 	struct mei_me_hw *hw = to_me_hw(dev);
 	u32 csr_reg = mei_hcsr_read(hw);
 
@@ -421,7 +421,7 @@ irqreturn_t mei_me_irq_quick_handler(int irq, void *dev_id)
  */
 irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 {
-	struct mei_device *dev = (struct mei_device *) dev_id;
+	struct mei_host *dev = (struct mei_host *) dev_id;
 	struct mei_cl_cb complete_list;
 	struct mei_cl_cb *cb_pos = NULL, *cb_next = NULL;
 	struct mei_cl *cl;
@@ -549,11 +549,11 @@ static const struct mei_hw_ops mei_me_hw_ops = {
  *
  * returns The mei_device_device pointer on success, NULL on failure.
  */
-struct mei_device *mei_me_dev_init(struct pci_dev *pdev)
+struct mei_host *mei_me_dev_init(struct pci_dev *pdev)
 {
-	struct mei_device *dev;
+	struct mei_host *dev;
 
-	dev = kzalloc(sizeof(struct mei_device) +
+	dev = kzalloc(sizeof(struct mei_host) +
 			 sizeof(struct mei_me_hw), GFP_KERNEL);
 	if (!dev)
 		return NULL;
diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
index 8518d3e..66d6755 100644
--- a/drivers/misc/mei/hw-me.h
+++ b/drivers/misc/mei/hw-me.h
@@ -34,7 +34,7 @@ struct mei_me_hw {
 
 #define to_me_hw(dev) (struct mei_me_hw *)((dev)->hw)
 
-struct mei_device *mei_me_dev_init(struct pci_dev *pdev);
+struct mei_host *mei_me_dev_init(struct pci_dev *pdev);
 
 /* get slots (dwords) from a message length + header (bytes) */
 static inline unsigned char mei_data2slots(size_t length)
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 6ec5301..d4b48a7 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -42,7 +42,7 @@ const char *mei_dev_state_str(int state)
 #undef MEI_DEV_STATE
 }
 
-void mei_device_init(struct mei_device *dev)
+void mei_device_init(struct mei_host *dev)
 {
 	/* setup our list array */
 	INIT_LIST_HEAD(&dev->file_list);
@@ -65,7 +65,7 @@ void mei_device_init(struct mei_device *dev)
  *
  * returns 0 on success, <0 on failure.
  */
-int mei_hw_init(struct mei_device *dev)
+int mei_hw_init(struct mei_host *dev)
 {
 	int ret = 0;
 
@@ -133,7 +133,7 @@ err:
  * @dev: the device structure
  * @interrupts_enabled: if interrupt should be enabled after reset.
  */
-void mei_reset(struct mei_device *dev, int interrupts_enabled)
+void mei_reset(struct mei_host *dev, int interrupts_enabled)
 {
 	bool unexpected;
 
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 3535b26..30cc864 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -81,7 +81,7 @@ static int _mei_irq_thread_state_ok(struct mei_cl *cl,
  * returns 0 on success, <0 on failure.
  */
 static int mei_irq_thread_read_client_message(struct mei_cl_cb *complete_list,
-		struct mei_device *dev,
+		struct mei_host *dev,
 		struct mei_msg_hdr *mei_hdr)
 {
 	struct mei_cl *cl;
@@ -148,7 +148,7 @@ quit:
  *
  * returns 0, OK; otherwise, error.
  */
-static int _mei_irq_thread_close(struct mei_device *dev, s32 *slots,
+static int _mei_irq_thread_close(struct mei_host *dev, s32 *slots,
 				struct mei_cl_cb *cb_pos,
 				struct mei_cl *cl,
 				struct mei_cl_cb *cmpl_list)
@@ -187,7 +187,7 @@ static int _mei_irq_thread_close(struct mei_device *dev, s32 *slots,
  *
  * returns 0, OK; otherwise, error.
  */
-static int _mei_irq_thread_read(struct mei_device *dev,	s32 *slots,
+static int _mei_irq_thread_read(struct mei_host *dev,	s32 *slots,
 			struct mei_cl_cb *cb_pos,
 			struct mei_cl *cl,
 			struct mei_cl_cb *cmpl_list)
@@ -224,7 +224,7 @@ static int _mei_irq_thread_read(struct mei_device *dev,	s32 *slots,
  *
  * returns 0, OK; otherwise, error.
  */
-static int _mei_irq_thread_ioctl(struct mei_device *dev, s32 *slots,
+static int _mei_irq_thread_ioctl(struct mei_host *dev, s32 *slots,
 			struct mei_cl_cb *cb_pos,
 			struct mei_cl *cl,
 			struct mei_cl_cb *cmpl_list)
@@ -260,7 +260,7 @@ static int _mei_irq_thread_ioctl(struct mei_device *dev, s32 *slots,
  *
  * returns 0, OK; otherwise, error.
  */
-static int mei_irq_thread_write_complete(struct mei_device *dev, s32 *slots,
+static int mei_irq_thread_write_complete(struct mei_host *dev, s32 *slots,
 			struct mei_cl_cb *cb, struct mei_cl_cb *cmpl_list)
 {
 	struct mei_msg_hdr mei_hdr;
@@ -319,7 +319,7 @@ static int mei_irq_thread_write_complete(struct mei_device *dev, s32 *slots,
  *
  * returns 0 on success, <0 on failure.
  */
-int mei_irq_read_handler(struct mei_device *dev,
+int mei_irq_read_handler(struct mei_host *dev,
 		struct mei_cl_cb *cmpl_list, s32 *slots)
 {
 	struct mei_msg_hdr *mei_hdr;
@@ -419,7 +419,7 @@ end:
  *
  * returns 0 on success, <0 on failure.
  */
-int mei_irq_write_handler(struct mei_device *dev,
+int mei_irq_write_handler(struct mei_host *dev,
 				struct mei_cl_cb *cmpl_list)
 {
 
@@ -577,8 +577,8 @@ void mei_timer(struct work_struct *work)
 	struct mei_cl_cb  *cb_pos = NULL;
 	struct mei_cl_cb  *cb_next = NULL;
 
-	struct mei_device *dev = container_of(work,
-					struct mei_device, timer_work.work);
+	struct mei_host *dev = container_of(work,
+					struct mei_host, timer_work.work);
 
 
 	mutex_lock(&dev->device_lock);
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 903f809..da8cef5 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -56,7 +56,7 @@ static int mei_open(struct inode *inode, struct file *file)
 	struct miscdevice *misc = file->private_data;
 	struct pci_dev *pdev;
 	struct mei_cl *cl;
-	struct mei_device *dev;
+	struct mei_host *dev;
 
 	int err;
 
@@ -117,7 +117,7 @@ static int mei_release(struct inode *inode, struct file *file)
 {
 	struct mei_cl *cl = file->private_data;
 	struct mei_cl_cb *cb;
-	struct mei_device *dev;
+	struct mei_host *dev;
 	int rets = 0;
 
 	if (WARN_ON(!cl || !cl->dev))
@@ -193,7 +193,7 @@ static ssize_t mei_read(struct file *file, char __user *ubuf,
 	struct mei_cl *cl = file->private_data;
 	struct mei_cl_cb *cb_pos = NULL;
 	struct mei_cl_cb *cb = NULL;
-	struct mei_device *dev;
+	struct mei_host *dev;
 	int i;
 	int rets;
 	int err;
@@ -343,7 +343,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	struct mei_cl *cl = file->private_data;
 	struct mei_cl_cb *write_cb = NULL;
 	struct mei_msg_hdr mei_hdr;
-	struct mei_device *dev;
+	struct mei_host *dev;
 	unsigned long timeout = 0;
 	int rets;
 	int i;
@@ -516,7 +516,7 @@ err:
 static int mei_ioctl_connect_client(struct file *file,
 			struct mei_connect_client_data *data)
 {
-	struct mei_device *dev;
+	struct mei_host *dev;
 	struct mei_client *client;
 	struct mei_cl *cl;
 	int i;
@@ -611,7 +611,7 @@ end:
  */
 static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 {
-	struct mei_device *dev;
+	struct mei_host *dev;
 	struct mei_cl *cl = file->private_data;
 	struct mei_connect_client_data *connect_data = NULL;
 	int rets;
@@ -697,7 +697,7 @@ static long mei_compat_ioctl(struct file *file,
 static unsigned int mei_poll(struct file *file, poll_table *wait)
 {
 	struct mei_cl *cl = file->private_data;
-	struct mei_device *dev;
+	struct mei_host *dev;
 	unsigned int mask = 0;
 
 	if (WARN_ON(!cl || !cl->dev))
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index cb80166..b521313 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -194,7 +194,7 @@ struct mei_cl_cb {
 /* MEI client instance carried as file->pirvate_data*/
 struct mei_cl {
 	struct list_head link;
-	struct mei_device *dev;
+	struct mei_host *dev;
 	enum file_state state;
 	wait_queue_head_t tx_wait;
 	wait_queue_head_t rx_wait;
@@ -237,34 +237,34 @@ struct mei_cl {
  */
 struct mei_hw_ops {
 
-	void (*host_set_ready) (struct mei_device *dev);
-	bool (*host_is_ready) (struct mei_device *dev);
+	void (*host_set_ready) (struct mei_host *dev);
+	bool (*host_is_ready) (struct mei_host *dev);
 
-	bool (*hw_is_ready) (struct mei_device *dev);
-	void (*hw_reset) (struct mei_device *dev, bool enable);
-	void (*hw_config) (struct mei_device *dev);
+	bool (*hw_is_ready) (struct mei_host *dev);
+	void (*hw_reset) (struct mei_host *dev, bool enable);
+	void (*hw_config) (struct mei_host *dev);
 
-	void (*intr_clear) (struct mei_device *dev);
-	void (*intr_enable) (struct mei_device *dev);
-	void (*intr_disable) (struct mei_device *dev);
+	void (*intr_clear) (struct mei_host *dev);
+	void (*intr_enable) (struct mei_host *dev);
+	void (*intr_disable) (struct mei_host *dev);
 
-	int (*hbuf_free_slots) (struct mei_device *dev);
-	bool (*hbuf_is_ready) (struct mei_device *dev);
-	size_t (*hbuf_max_len) (const struct mei_device *dev);
+	int (*hbuf_free_slots) (struct mei_host *dev);
+	bool (*hbuf_is_ready) (struct mei_host *dev);
+	size_t (*hbuf_max_len) (const struct mei_host *dev);
 
-	int (*write)(struct mei_device *dev,
+	int (*write)(struct mei_host *dev,
 		     struct mei_msg_hdr *hdr,
 		     unsigned char *buf);
 
-	int (*rdbuf_full_slots)(struct mei_device *dev);
+	int (*rdbuf_full_slots)(struct mei_host *dev);
 
-	u32 (*read_hdr)(const struct mei_device *dev);
-	int (*read) (struct mei_device *dev,
+	u32 (*read_hdr)(const struct mei_host *dev);
+	int (*read) (struct mei_host *dev,
 		     unsigned char *buf, unsigned long len);
 };
 
 /**
- * struct mei_device -  MEI private device struct
+ * struct mei_host -  MEI private host struct
 
  * @mem_addr - mem mapped base register address
 
@@ -273,7 +273,7 @@ struct mei_hw_ops {
  * @wr_msg - the buffer for hbm control messages
  * @wr_ext_msg - the buffer for hbm control responses (set in read cycle)
  */
-struct mei_device {
+struct mei_host {
 	struct pci_dev *pdev;	/* pointer to pci device struct */
 	/*
 	 * lists of queues
@@ -378,144 +378,144 @@ static inline unsigned long mei_secs_to_jiffies(unsigned long sec)
 /*
  * mei init function prototypes
  */
-void mei_device_init(struct mei_device *dev);
-void mei_reset(struct mei_device *dev, int interrupts);
-int mei_hw_init(struct mei_device *dev);
+void mei_device_init(struct mei_host *dev);
+void mei_reset(struct mei_host *dev, int interrupts);
+int mei_hw_init(struct mei_host *dev);
 
 /*
  *  MEI interrupt functions prototype
  */
 
 void mei_timer(struct work_struct *work);
-int mei_irq_read_handler(struct mei_device *dev,
+int mei_irq_read_handler(struct mei_host *dev,
 		struct mei_cl_cb *cmpl_list, s32 *slots);
 
-int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list);
+int mei_irq_write_handler(struct mei_host *dev, struct mei_cl_cb *cmpl_list);
 
 void mei_irq_complete_handler(struct mei_cl *cl, struct mei_cl_cb *cb_pos);
 
 /*
  * AMTHIF - AMT Host Interface Functions
  */
-void mei_amthif_reset_params(struct mei_device *dev);
+void mei_amthif_reset_params(struct mei_host *dev);
 
-int mei_amthif_host_init(struct mei_device *dev);
+int mei_amthif_host_init(struct mei_host *dev);
 
-int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *priv_cb);
+int mei_amthif_write(struct mei_host *dev, struct mei_cl_cb *priv_cb);
 
-int mei_amthif_read(struct mei_device *dev, struct file *file,
+int mei_amthif_read(struct mei_host *dev, struct file *file,
 		char __user *ubuf, size_t length, loff_t *offset);
 
-unsigned int mei_amthif_poll(struct mei_device *dev,
+unsigned int mei_amthif_poll(struct mei_host *dev,
 		struct file *file, poll_table *wait);
 
-int mei_amthif_release(struct mei_device *dev, struct file *file);
+int mei_amthif_release(struct mei_host *dev, struct file *file);
 
-struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_device *dev,
+struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_host *dev,
 						struct file *file);
 
-void mei_amthif_run_next_cmd(struct mei_device *dev);
+void mei_amthif_run_next_cmd(struct mei_host *dev);
 
 
-int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
+int mei_amthif_irq_write_complete(struct mei_host *dev, s32 *slots,
 			struct mei_cl_cb *cb, struct mei_cl_cb *cmpl_list);
 
-void mei_amthif_complete(struct mei_device *dev, struct mei_cl_cb *cb);
+void mei_amthif_complete(struct mei_host *dev, struct mei_cl_cb *cb);
 int mei_amthif_irq_read_message(struct mei_cl_cb *complete_list,
-		struct mei_device *dev, struct mei_msg_hdr *mei_hdr);
-int mei_amthif_irq_read(struct mei_device *dev, s32 *slots);
+		struct mei_host *dev, struct mei_msg_hdr *mei_hdr);
+int mei_amthif_irq_read(struct mei_host *dev, s32 *slots);
 
 
-int mei_wd_send(struct mei_device *dev);
-int mei_wd_stop(struct mei_device *dev);
-int mei_wd_host_init(struct mei_device *dev);
+int mei_wd_send(struct mei_host *dev);
+int mei_wd_stop(struct mei_host *dev);
+int mei_wd_host_init(struct mei_host *dev);
 /*
  * mei_watchdog_register  - Registering watchdog interface
  *   once we got connection to the WD Client
  * @dev - mei device
  */
-void mei_watchdog_register(struct mei_device *dev);
+void mei_watchdog_register(struct mei_host *dev);
 /*
  * mei_watchdog_unregister  - Unregistering watchdog interface
  * @dev - mei device
  */
-void mei_watchdog_unregister(struct mei_device *dev);
+void mei_watchdog_unregister(struct mei_host *dev);
 
 /*
  * Register Access Function
  */
 
-static inline void mei_hw_config(struct mei_device *dev)
+static inline void mei_hw_config(struct mei_host *dev)
 {
 	dev->ops->hw_config(dev);
 }
-static inline void mei_hw_reset(struct mei_device *dev, bool enable)
+static inline void mei_hw_reset(struct mei_host *dev, bool enable)
 {
 	dev->ops->hw_reset(dev, enable);
 }
 
-static inline void mei_clear_interrupts(struct mei_device *dev)
+static inline void mei_clear_interrupts(struct mei_host *dev)
 {
 	dev->ops->intr_clear(dev);
 }
 
-static inline void mei_enable_interrupts(struct mei_device *dev)
+static inline void mei_enable_interrupts(struct mei_host *dev)
 {
 	dev->ops->intr_enable(dev);
 }
 
-static inline void mei_disable_interrupts(struct mei_device *dev)
+static inline void mei_disable_interrupts(struct mei_host *dev)
 {
 	dev->ops->intr_disable(dev);
 }
 
-static inline void mei_host_set_ready(struct mei_device *dev)
+static inline void mei_host_set_ready(struct mei_host *dev)
 {
 	dev->ops->host_set_ready(dev);
 }
-static inline bool mei_host_is_ready(struct mei_device *dev)
+static inline bool mei_host_is_ready(struct mei_host *dev)
 {
 	return dev->ops->host_is_ready(dev);
 }
-static inline bool mei_hw_is_ready(struct mei_device *dev)
+static inline bool mei_hw_is_ready(struct mei_host *dev)
 {
 	return dev->ops->hw_is_ready(dev);
 }
 
-static inline bool mei_hbuf_is_ready(struct mei_device *dev)
+static inline bool mei_hbuf_is_ready(struct mei_host *dev)
 {
 	return dev->ops->hbuf_is_ready(dev);
 }
 
-static inline int mei_hbuf_empty_slots(struct mei_device *dev)
+static inline int mei_hbuf_empty_slots(struct mei_host *dev)
 {
 	return dev->ops->hbuf_free_slots(dev);
 }
 
-static inline size_t mei_hbuf_max_len(const struct mei_device *dev)
+static inline size_t mei_hbuf_max_len(const struct mei_host *dev)
 {
 	return dev->ops->hbuf_max_len(dev);
 }
 
-static inline int mei_write_message(struct mei_device *dev,
+static inline int mei_write_message(struct mei_host *dev,
 			struct mei_msg_hdr *hdr,
 			unsigned char *buf)
 {
 	return dev->ops->write(dev, hdr, buf);
 }
 
-static inline u32 mei_read_hdr(const struct mei_device *dev)
+static inline u32 mei_read_hdr(const struct mei_host *dev)
 {
 	return dev->ops->read_hdr(dev);
 }
 
-static inline void mei_read_slots(struct mei_device *dev,
+static inline void mei_read_slots(struct mei_host *dev,
 		     unsigned char *buf, unsigned long len)
 {
 	dev->ops->read(dev, buf, len);
 }
 
-static inline int mei_count_full_read_slots(struct mei_device *dev)
+static inline int mei_count_full_read_slots(struct mei_host *dev)
 {
 	return dev->ops->rdbuf_full_slots(dev);
 }
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index b40ec06..8e88ec0 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -121,7 +121,7 @@ static bool mei_quirk_probe(struct pci_dev *pdev,
  */
 static int mei_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	struct mei_device *dev;
+	struct mei_host *dev;
 	struct mei_me_hw *hw;
 	int err;
 
@@ -235,7 +235,7 @@ end:
  */
 static void mei_remove(struct pci_dev *pdev)
 {
-	struct mei_device *dev;
+	struct mei_host *dev;
 	struct mei_me_hw *hw;
 
 	if (mei_pdev != pdev)
@@ -307,7 +307,7 @@ static void mei_remove(struct pci_dev *pdev)
 static int mei_pci_suspend(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
-	struct mei_device *dev = pci_get_drvdata(pdev);
+	struct mei_host *dev = pci_get_drvdata(pdev);
 	int err;
 
 	if (!dev)
@@ -335,7 +335,7 @@ static int mei_pci_suspend(struct device *device)
 static int mei_pci_resume(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
-	struct mei_device *dev;
+	struct mei_host *dev;
 	int err;
 
 	dev = pci_get_drvdata(pdev);
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 2413247..51cc54f 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -47,7 +47,7 @@ const uuid_le mei_wd_guid = UUID_LE(0x05B79A6F, 0x4628, 0x4D7F, 0x89,
 						0x9D, 0xA9, 0x15, 0x14, 0xCB,
 						0x32, 0xAB);
 
-static void mei_wd_set_start_timeout(struct mei_device *dev, u16 timeout)
+static void mei_wd_set_start_timeout(struct mei_host *dev, u16 timeout)
 {
 	dev_dbg(&dev->pdev->dev, "wd: set timeout=%d.\n", timeout);
 	memcpy(dev->wd_data, mei_start_wd_params, MEI_WD_HDR_SIZE);
@@ -62,7 +62,7 @@ static void mei_wd_set_start_timeout(struct mei_device *dev, u16 timeout)
  *         -EIO if write has failed
  *         0 on success
  */
-int mei_wd_host_init(struct mei_device *dev)
+int mei_wd_host_init(struct mei_host *dev)
 {
 	struct mei_cl *cl = &dev->wd_cl;
 	int i;
@@ -112,7 +112,7 @@ int mei_wd_host_init(struct mei_device *dev)
  *	-EIO when message send fails
  *	-EINVAL when invalid message is to be sent
  */
-int mei_wd_send(struct mei_device *dev)
+int mei_wd_send(struct mei_host *dev)
 {
 	struct mei_msg_hdr hdr;
 
@@ -141,7 +141,7 @@ int mei_wd_send(struct mei_device *dev)
  *	-EIO when message send fails
  *	-EINVAL when invalid message is to be sent
  */
-int mei_wd_stop(struct mei_device *dev)
+int mei_wd_stop(struct mei_host *dev)
 {
 	int ret;
 
@@ -204,7 +204,7 @@ out:
 static int mei_wd_ops_start(struct watchdog_device *wd_dev)
 {
 	int err = -ENODEV;
-	struct mei_device *dev;
+	struct mei_host *dev;
 
 	dev = watchdog_get_drvdata(wd_dev);
 	if (!dev)
@@ -242,7 +242,7 @@ end_unlock:
  */
 static int mei_wd_ops_stop(struct watchdog_device *wd_dev)
 {
-	struct mei_device *dev;
+	struct mei_host *dev;
 
 	dev = watchdog_get_drvdata(wd_dev);
 	if (!dev)
@@ -265,7 +265,7 @@ static int mei_wd_ops_stop(struct watchdog_device *wd_dev)
 static int mei_wd_ops_ping(struct watchdog_device *wd_dev)
 {
 	int ret = 0;
-	struct mei_device *dev;
+	struct mei_host *dev;
 
 	dev = watchdog_get_drvdata(wd_dev);
 	if (!dev)
@@ -319,7 +319,7 @@ end:
  */
 static int mei_wd_ops_set_timeout(struct watchdog_device *wd_dev, unsigned int timeout)
 {
-	struct mei_device *dev;
+	struct mei_host *dev;
 
 	dev = watchdog_get_drvdata(wd_dev);
 	if (!dev)
@@ -366,7 +366,7 @@ static struct watchdog_device amt_wd_dev = {
 };
 
 
-void mei_watchdog_register(struct mei_device *dev)
+void mei_watchdog_register(struct mei_host *dev)
 {
 	if (watchdog_register_device(&amt_wd_dev)) {
 		dev_err(&dev->pdev->dev,
@@ -379,7 +379,7 @@ void mei_watchdog_register(struct mei_device *dev)
 	watchdog_set_drvdata(&amt_wd_dev, dev);
 }
 
-void mei_watchdog_unregister(struct mei_device *dev)
+void mei_watchdog_unregister(struct mei_host *dev)
 {
 	if (watchdog_get_drvdata(&amt_wd_dev) == NULL)
 		return;
-- 
1.7.10.4

