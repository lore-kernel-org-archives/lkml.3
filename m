Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbaI2Ndx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:33:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:32061 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbaI2NdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:33:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393030140"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [RESEND char-misc-next 17/18] mei: fix KDoc documentation formatting
Date: Mon, 29 Sep 2014 16:31:49 +0300
Message-Id: <1411997510-29094-18-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
References: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Fix Kdoc documentation formatting warnings
genertaed by ./scripts/kernel-doc

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    | 30 +++++++--------
 drivers/misc/mei/client.c    | 70 ++++++++++++++++++++---------------
 drivers/misc/mei/debugfs.c   |  7 +++-
 drivers/misc/mei/hbm.c       | 43 +++++++++++-----------
 drivers/misc/mei/hw-me.c     | 48 ++++++++++++------------
 drivers/misc/mei/hw-txe.c    | 57 +++++++++++++++-------------
 drivers/misc/mei/hw.h        | 46 +++++++++++------------
 drivers/misc/mei/init.c      | 10 ++---
 drivers/misc/mei/interrupt.c | 24 ++++++------
 drivers/misc/mei/main.c      | 21 +++++------
 drivers/misc/mei/mei_dev.h   | 88 ++++++++++++++++++++++----------------------
 drivers/misc/mei/nfc.c       |  3 +-
 drivers/misc/mei/pci-me.c    |  4 +-
 drivers/misc/mei/pci-txe.c   |  2 +-
 drivers/misc/mei/wd.c        | 15 ++++----
 15 files changed, 243 insertions(+), 225 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index d9b0e761f..29b3fd0 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -122,7 +122,7 @@ int mei_amthif_host_init(struct mei_device *dev)
  * @dev: the device structure
  * @file: pointer to file object
  *
- * returns   returned a list entry on success, NULL on failure.
+ * Return:   returned a list entry on success, NULL on failure.
  */
 struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_device *dev,
 						struct file *file)
@@ -140,15 +140,14 @@ struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_device *dev,
  * mei_amthif_read - read data from AMTHIF client
  *
  * @dev: the device structure
- * @if_num:  minor number
  * @file: pointer to file object
- * @*ubuf: pointer to user data in user space
+ * @ubuf: pointer to user data in user space
  * @length: data length to read
  * @offset: data read offset
  *
  * Locking: called under "dev->device_lock" lock
  *
- * returns
+ * Return:
  *  returned data length on success,
  *  zero if no data to read,
  *  negative on failure.
@@ -256,7 +255,7 @@ out:
  * @dev: the device structure
  * @cb: mei call back struct
  *
- * returns 0 on success, <0 on failure.
+ * Return: 0 on success, <0 on failure.
  *
  */
 static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
@@ -326,7 +325,7 @@ static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
  * @dev: the device structure
  * @cb: mei call back struct
  *
- * returns 0 on success, <0 on failure.
+ * Return: 0 on success, <0 on failure.
  *
  */
 int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *cb)
@@ -356,8 +355,6 @@ int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *cb)
  * mei_amthif_run_next_cmd
  *
  * @dev: the device structure
- *
- * returns 0 on success, <0 on failure.
  */
 void mei_amthif_run_next_cmd(struct mei_device *dev)
 {
@@ -420,12 +417,11 @@ unsigned int mei_amthif_poll(struct mei_device *dev,
 /**
  * mei_amthif_irq_write - write iamthif command in irq thread context.
  *
- * @dev: the device structure.
- * @cb_pos: callback block.
  * @cl: private data of the file object.
+ * @cb: callback block.
  * @cmpl_list: complete list.
  *
- * returns 0, OK; otherwise, error.
+ * Return: 0, OK; otherwise, error.
  */
 int mei_amthif_irq_write(struct mei_cl *cl, struct mei_cl_cb *cb,
 			 struct mei_cl_cb *cmpl_list)
@@ -507,7 +503,7 @@ int mei_amthif_irq_write(struct mei_cl *cl, struct mei_cl_cb *cb,
  * @mei_hdr: header of amthif message
  * @complete_list: An instance of our list structure
  *
- * returns 0 on success, <0 on failure.
+ * Return: 0 on success, <0 on failure.
  */
 int mei_amthif_irq_read_msg(struct mei_device *dev,
 			    struct mei_msg_hdr *mei_hdr,
@@ -560,7 +556,7 @@ int mei_amthif_irq_read_msg(struct mei_device *dev,
  * @dev: the device structure.
  * @slots: free slots.
  *
- * returns 0, OK; otherwise, error.
+ * Return: 0, OK; otherwise, error.
  */
 int mei_amthif_irq_read(struct mei_device *dev, s32 *slots)
 {
@@ -590,7 +586,7 @@ int mei_amthif_irq_read(struct mei_device *dev, s32 *slots)
  * mei_amthif_complete - complete amthif callback.
  *
  * @dev: the device structure.
- * @cb_pos: callback block.
+ * @cb: callback block.
  */
 void mei_amthif_complete(struct mei_device *dev, struct mei_cl_cb *cb)
 {
@@ -624,7 +620,7 @@ void mei_amthif_complete(struct mei_device *dev, struct mei_cl_cb *cb)
  * mei_clear_list is called to clear resources associated with file
  * when application calls close function or Ctrl-C was pressed
  *
- * returns true if callback removed from the list, false otherwise
+ * Return: true if callback removed from the list, false otherwise
  */
 static bool mei_clear_list(struct mei_device *dev,
 		const struct file *file, struct list_head *mei_cb_list)
@@ -664,7 +660,7 @@ static bool mei_clear_list(struct mei_device *dev,
  * mei_clear_lists is called to clear resources associated with file
  * when application calls close function or Ctrl-C was pressed
  *
- * returns true if callback removed from the list, false otherwise
+ * Return: true if callback removed from the list, false otherwise
  */
 static bool mei_clear_lists(struct mei_device *dev, struct file *file)
 {
@@ -705,7 +701,7 @@ static bool mei_clear_lists(struct mei_device *dev, struct file *file)
 *  @dev: device structure
 *  @file: pointer to file structure
 *
-*  returns 0 on success, <0 on error
+*  Return: 0 on success, <0 on error
 */
 int mei_amthif_release(struct mei_device *dev, struct file *file)
 {
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index bf3fd67..1f91c55 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -27,13 +27,14 @@
 #include "client.h"
 
 /**
- * mei_me_cl_by_uuid - locate index of me client
+ * mei_me_cl_by_uuid - locate me client by uuid
  *
  * @dev: mei device
+ * @uuid: me client uuid
  *
  * Locking: called under "dev->device_lock" lock
  *
- * returns me client or NULL if not found
+ * Return: me client or NULL if not found
  */
 struct mei_me_client *mei_me_cl_by_uuid(const struct mei_device *dev,
 					const uuid_le *uuid)
@@ -48,16 +49,15 @@ struct mei_me_client *mei_me_cl_by_uuid(const struct mei_device *dev,
 }
 
 /**
- * mei_me_cl_by_id return index to me_clients for client_id
+ * mei_me_cl_by_id - locate me client by client id
  *
  * @dev: the device structure
  * @client_id: me client id
  *
  * Locking: called under "dev->device_lock" lock
  *
- * returns me client or NULL if not found
+ * Return: me client or NULL if not found
  */
-
 struct mei_me_client *mei_me_cl_by_id(struct mei_device *dev, u8 client_id)
 {
 
@@ -69,6 +69,17 @@ struct mei_me_client *mei_me_cl_by_id(struct mei_device *dev, u8 client_id)
 	return NULL;
 }
 
+/**
+ * mei_me_cl_by_uuid_id - locate me client by client id and uuid
+ *
+ * @dev: the device structure
+ * @uuid: me client uuid
+ * @client_id: me client id
+ *
+ * Locking: called under "dev->device_lock" lock
+ *
+ * Return: me client or NULL if not found
+ */
 struct mei_me_client *mei_me_cl_by_uuid_id(struct mei_device *dev,
 					   const uuid_le *uuid, u8 client_id)
 {
@@ -109,7 +120,7 @@ void mei_me_cl_remove(struct mei_device *dev, const uuid_le *uuid, u8 client_id)
  * @cl1: host client 1
  * @cl2: host client 2
  *
- * returns true  - if the clients has same host and me ids
+ * Return: true  - if the clients has same host and me ids
  *         false - otherwise
  */
 static inline bool mei_cl_cmp_id(const struct mei_cl *cl1,
@@ -184,10 +195,10 @@ void mei_io_cb_free(struct mei_cl_cb *cb)
 /**
  * mei_io_cb_init - allocate and initialize io callback
  *
- * @cl - mei client
+ * @cl: mei client
  * @fp: pointer to file structure
  *
- * returns mei_cl_cb pointer or NULL;
+ * Return: mei_cl_cb pointer or NULL;
  */
 struct mei_cl_cb *mei_io_cb_init(struct mei_cl *cl, struct file *fp)
 {
@@ -211,7 +222,7 @@ struct mei_cl_cb *mei_io_cb_init(struct mei_cl *cl, struct file *fp)
  * @cb: io callback structure
  * @length: size of the buffer
  *
- * returns 0 on success
+ * Return: 0 on success
  *         -EINVAL if cb is NULL
  *         -ENOMEM if allocation failed
  */
@@ -235,7 +246,7 @@ int mei_io_cb_alloc_req_buf(struct mei_cl_cb *cb, size_t length)
  * @cb: io callback structure
  * @length: size of the buffer
  *
- * returns 0 on success
+ * Return: 0 on success
  *         -EINVAL if cb is NULL
  *         -ENOMEM if allocation failed
  */
@@ -305,7 +316,7 @@ void mei_cl_init(struct mei_cl *cl, struct mei_device *dev)
  * mei_cl_allocate - allocates cl  structure and sets it up.
  *
  * @dev: mei device
- * returns  The allocated file or NULL on failure
+ * Return:  The allocated file or NULL on failure
  */
 struct mei_cl *mei_cl_allocate(struct mei_device *dev)
 {
@@ -325,7 +336,7 @@ struct mei_cl *mei_cl_allocate(struct mei_device *dev)
  *
  * @cl: host client
  *
- * returns cb on success, NULL on error
+ * Return: cb on success, NULL on error
  */
 struct mei_cl_cb *mei_cl_find_read_cb(struct mei_cl *cl)
 {
@@ -343,7 +354,7 @@ struct mei_cl_cb *mei_cl_find_read_cb(struct mei_cl *cl)
  * @cl - host client
  * @id - fixed host id or -1 for generic one
  *
- * returns 0 on success
+ * Return: 0 on success
  *	-EINVAL on incorrect values
  *	-ENONET if client not found
  */
@@ -455,10 +466,10 @@ void mei_host_client_init(struct work_struct *work)
 }
 
 /**
- * mei_hbuf_acquire: try to acquire host buffer
+ * mei_hbuf_acquire - try to acquire host buffer
  *
  * @dev: the device structure
- * returns true if host buffer was acquired
+ * Return: true if host buffer was acquired
  */
 bool mei_hbuf_acquire(struct mei_device *dev)
 {
@@ -485,7 +496,7 @@ bool mei_hbuf_acquire(struct mei_device *dev)
  *
  * Locking: called under "dev->device_lock" lock
  *
- * returns 0 on success, <0 on failure.
+ * Return: 0 on success, <0 on failure.
  */
 int mei_cl_disconnect(struct mei_cl *cl)
 {
@@ -566,7 +577,7 @@ free:
  *
  * @cl: private data of the file object
  *
- * returns true if other client is connected, false - otherwise.
+ * Return: true if other client is connected, false - otherwise.
  */
 bool mei_cl_is_other_connecting(struct mei_cl *cl)
 {
@@ -593,10 +604,11 @@ bool mei_cl_is_other_connecting(struct mei_cl *cl)
  * mei_cl_connect - connect host client to the me one
  *
  * @cl: host client
+ * @file: pointer to file structure
  *
  * Locking: called under "dev->device_lock" lock
  *
- * returns 0 on success, <0 on failure.
+ * Return: 0 on success, <0 on failure.
  */
 int mei_cl_connect(struct mei_cl *cl, struct file *file)
 {
@@ -671,7 +683,7 @@ out:
  *
  * @cl: private data of the file object
  *
- * returns 1 if mei_flow_ctrl_creds >0, 0 - otherwise.
+ * Return: 1 if mei_flow_ctrl_creds >0, 0 - otherwise.
  *	-ENOENT if mei_cl is not present
  *	-EINVAL if single_recv_buf == 0
  */
@@ -707,7 +719,7 @@ int mei_cl_flow_ctrl_creds(struct mei_cl *cl)
  *
  * @cl: private data of the file object
  *
- * @returns
+ * Return:
  *	0 on success
  *	-ENOENT when me client is not found
  *	-EINVAL when ctrl credits are <= 0
@@ -745,7 +757,7 @@ int mei_cl_flow_ctrl_reduce(struct mei_cl *cl)
  *
  * @cl: host client
  *
- * returns 0 on success, <0 on failure.
+ * Return: 0 on success, <0 on failure.
  */
 int mei_cl_read_start(struct mei_cl *cl, size_t length)
 {
@@ -823,7 +835,7 @@ out:
  * @cb: callback block.
  * @cmpl_list: complete list.
  *
- * returns 0, OK; otherwise error.
+ * Return: 0, OK; otherwise error.
  */
 int mei_cl_irq_write(struct mei_cl *cl, struct mei_cl_cb *cb,
 		     struct mei_cl_cb *cmpl_list)
@@ -900,12 +912,12 @@ int mei_cl_irq_write(struct mei_cl *cl, struct mei_cl_cb *cb,
 
 /**
  * mei_cl_write - submit a write cb to mei device
-	assumes device_lock is locked
+ *	assumes device_lock is locked
  *
  * @cl: host client
- * @cl: write callback with filled data
+ * @cb: write callback with filled data
  *
- * returns number of bytes sent on success, <0 on failure.
+ * Return: number of bytes sent on success, <0 on failure.
  */
 int mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, bool blocking)
 {
@@ -1042,7 +1054,7 @@ void mei_cl_complete(struct mei_cl *cl, struct mei_cl_cb *cb)
 /**
  * mei_cl_all_disconnect - disconnect forcefully all connected clients
  *
- * @dev - mei device
+ * @dev: mei device
  */
 
 void mei_cl_all_disconnect(struct mei_device *dev)
@@ -1060,7 +1072,7 @@ void mei_cl_all_disconnect(struct mei_device *dev)
 /**
  * mei_cl_all_wakeup  - wake up all readers and writers they can be interrupted
  *
- * @dev  - mei device
+ * @dev: mei device
  */
 void mei_cl_all_wakeup(struct mei_device *dev)
 {
@@ -1080,8 +1092,8 @@ void mei_cl_all_wakeup(struct mei_device *dev)
 
 /**
  * mei_cl_all_write_clear - clear all pending writes
-
- * @dev - mei device
+ *
+ * @dev: mei device
  */
 void mei_cl_all_write_clear(struct mei_device *dev)
 {
diff --git a/drivers/misc/mei/debugfs.c b/drivers/misc/mei/debugfs.c
index b92b8bc..357b02c 100644
--- a/drivers/misc/mei/debugfs.c
+++ b/drivers/misc/mei/debugfs.c
@@ -161,7 +161,8 @@ static const struct file_operations mei_dbgfs_fops_devstate = {
 
 /**
  * mei_dbgfs_deregister - Remove the debugfs files and directories
- * @mei - pointer to mei device private data
+ *
+ * @dev: the mei device structure
  */
 void mei_dbgfs_deregister(struct mei_device *dev)
 {
@@ -172,8 +173,10 @@ void mei_dbgfs_deregister(struct mei_device *dev)
 }
 
 /**
- * Add the debugfs files
+ * mei_dbgfs_register - Add the debugfs files
  *
+ * @dev: the mei device structure
+ * @name: the mei device name
  */
 int mei_dbgfs_register(struct mei_device *dev, const char *name)
 {
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 92d0739..da476e8 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -79,7 +79,7 @@ const char *mei_hbm_state_str(enum mei_hbm_state state)
  *
  * @status: client connect response status
  *
- * returns corresponding error code
+ * Return: corresponding error code
  */
 static int mei_cl_conn_status_to_errno(enum mei_cl_connect_status status)
 {
@@ -196,7 +196,7 @@ int mei_hbm_cl_write(struct mei_device *dev,
  * @cl: client
  * @cmd: hbm client message
  *
- * returns true if addresses are the same
+ * Return: true if addresses are the same
  */
 static inline
 bool mei_hbm_cl_addr_equal(struct mei_cl *cl, struct mei_hbm_cl_cmd *cmd)
@@ -211,7 +211,7 @@ bool mei_hbm_cl_addr_equal(struct mei_cl *cl, struct mei_hbm_cl_cmd *cmd)
  * @dev: the device structure
  * @buf: a buffer with hbm cl command
  *
- * returns the recipient client or NULL if not found
+ * Return: the recipient client or NULL if not found
  */
 static inline
 struct mei_cl *mei_hbm_cl_find_by_cmd(struct mei_device *dev, void *buf)
@@ -231,7 +231,7 @@ struct mei_cl *mei_hbm_cl_find_by_cmd(struct mei_device *dev, void *buf)
  *
  * @dev: the device structure
  *
- * returns 0 on success and < 0 on failure
+ * Return: 0 on success and < 0 on failure
  */
 int mei_hbm_start_wait(struct mei_device *dev)
 {
@@ -259,7 +259,7 @@ int mei_hbm_start_wait(struct mei_device *dev)
  *
  * @dev: the device structure
  *
- * returns 0 on success and < 0 on failure
+ * Return: 0 on success and < 0 on failure
  */
 int mei_hbm_start_req(struct mei_device *dev)
 {
@@ -297,7 +297,7 @@ int mei_hbm_start_req(struct mei_device *dev)
  *
  * @dev: the device structure
  *
- * returns 0 on success and < 0 on failure
+ * Return: 0 on success and < 0 on failure
  */
 static int mei_hbm_enum_clients_req(struct mei_device *dev)
 {
@@ -330,7 +330,7 @@ static int mei_hbm_enum_clients_req(struct mei_device *dev)
  * @dev: the device structure
  * @res: hbm property response
  *
- * returns 0 on success and -ENOMEM on allocation failure
+ * Return: 0 on success and -ENOMEM on allocation failure
  */
 
 static int mei_hbm_me_cl_add(struct mei_device *dev,
@@ -355,7 +355,7 @@ static int mei_hbm_me_cl_add(struct mei_device *dev,
  *
  * @dev: the device structure
  *
- * returns 0 on success and < 0 on failure
+ * Return: 0 on success and < 0 on failure
  */
 
 static int mei_hbm_prop_req(struct mei_device *dev)
@@ -405,7 +405,7 @@ static int mei_hbm_prop_req(struct mei_device *dev)
  * @dev: the device structure
  * @pg_cmd: the pg command code
  *
- * returns -EIO on write failure
+ * Return: -EIO on write failure
  *         -EOPNOTSUPP if the operation is not supported by the protocol
  */
 int mei_hbm_pg(struct mei_device *dev, u8 pg_cmd)
@@ -434,10 +434,9 @@ EXPORT_SYMBOL_GPL(mei_hbm_pg);
 /**
  * mei_hbm_stop_req - send stop request message
  *
- * @dev - mei device
- * @cl: client info
+ * @dev: mei device
  *
- * This function returns -EIO on write failure
+ * Return: -EIO on write failure
  */
 static int mei_hbm_stop_req(struct mei_device *dev)
 {
@@ -461,7 +460,7 @@ static int mei_hbm_stop_req(struct mei_device *dev)
  * @dev: the device structure
  * @cl: client info
  *
- * This function returns -EIO on write failure
+ * Return: -EIO on write failure
  */
 int mei_hbm_cl_flow_control_req(struct mei_device *dev, struct mei_cl *cl)
 {
@@ -477,7 +476,7 @@ int mei_hbm_cl_flow_control_req(struct mei_device *dev, struct mei_cl *cl)
  * @dev: the device structure
  * @flow: flow control.
  *
- * return 0 on success, < 0 otherwise
+ * Return: 0 on success, < 0 otherwise
  */
 static int mei_hbm_add_single_flow_creds(struct mei_device *dev,
 				  struct hbm_flow_control *flow)
@@ -533,7 +532,7 @@ static void mei_hbm_cl_flow_control_res(struct mei_device *dev,
  * @dev: the device structure
  * @cl: a client to disconnect from
  *
- * This function returns -EIO on write failure
+ * Return: -EIO on write failure
  */
 int mei_hbm_cl_disconnect_req(struct mei_device *dev, struct mei_cl *cl)
 {
@@ -548,7 +547,7 @@ int mei_hbm_cl_disconnect_req(struct mei_device *dev, struct mei_cl *cl)
  * @dev: the device structure
  * @cl: a client to disconnect from
  *
- * This function returns -EIO on write failure
+ * Return: -EIO on write failure
  */
 int mei_hbm_cl_disconnect_rsp(struct mei_device *dev, struct mei_cl *cl)
 {
@@ -584,7 +583,7 @@ static void mei_hbm_cl_disconnect_res(struct mei_cl *cl,
  * @dev: the device structure
  * @cl: a client to connect to
  *
- * returns -EIO on write failure
+ * Return: -EIO on write failure
  */
 int mei_hbm_cl_connect_req(struct mei_device *dev, struct mei_cl *cl)
 {
@@ -677,7 +676,7 @@ static void mei_hbm_cl_res(struct mei_device *dev,
  * @dev: the device structure.
  * @disconnect_req: disconnect request bus message from the me
  *
- * returns -ENOMEM on allocation failure
+ * Return: -ENOMEM on allocation failure
  */
 static int mei_hbm_fw_disconnect_req(struct mei_device *dev,
 		struct hbm_client_connect_request *disconnect_req)
@@ -702,7 +701,7 @@ static int mei_hbm_fw_disconnect_req(struct mei_device *dev,
 }
 
 /**
- * mei_hbm_config_features: check what hbm features and commands
+ * mei_hbm_config_features - check what hbm features and commands
  *        are supported by the fw
  *
  * @dev: the device structure
@@ -724,7 +723,7 @@ static void mei_hbm_config_features(struct mei_device *dev)
  *     support the hbm version of the device
  *
  * @dev: the device structure
- * returns true if driver can support hbm version of the device
+ * Return: true if driver can support hbm version of the device
  */
 bool mei_hbm_version_is_supported(struct mei_device *dev)
 {
@@ -738,9 +737,9 @@ bool mei_hbm_version_is_supported(struct mei_device *dev)
  * handle the read bus message cmd processing.
  *
  * @dev: the device structure
- * @mei_hdr: header of bus message
+ * @hdr: header of bus message
  *
- * returns 0 on success and < 0 on failure
+ * Return: 0 on success and < 0 on failure
  */
 int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 {
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 77166ea..9dd7aa7 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -28,10 +28,10 @@
 /**
  * mei_me_reg_read - Reads 32bit data from the mei device
  *
- * @dev: the device structure
+ * @hw: the me hardware structure
  * @offset: offset from which to read the data
  *
- * returns register value (u32)
+ * Return: register value (u32)
  */
 static inline u32 mei_me_reg_read(const struct mei_me_hw *hw,
 			       unsigned long offset)
@@ -43,7 +43,7 @@ static inline u32 mei_me_reg_read(const struct mei_me_hw *hw,
 /**
  * mei_me_reg_write - Writes 32bit data to the mei device
  *
- * @dev: the device structure
+ * @hw: the me hardware structure
  * @offset: offset from which to write the data
  * @value: register value to write (u32)
  */
@@ -59,7 +59,7 @@ static inline void mei_me_reg_write(const struct mei_me_hw *hw,
  *
  * @dev: the device structure
  *
- * returns ME_CB_RW register value (u32)
+ * Return: ME_CB_RW register value (u32)
  */
 static u32 mei_me_mecbrw_read(const struct mei_device *dev)
 {
@@ -68,9 +68,9 @@ static u32 mei_me_mecbrw_read(const struct mei_device *dev)
 /**
  * mei_me_mecsr_read - Reads 32bit data from the ME CSR
  *
- * @dev: the device structure
+ * @hw: the me hardware structure
  *
- * returns ME_CSR_HA register value (u32)
+ * Return: ME_CSR_HA register value (u32)
  */
 static inline u32 mei_me_mecsr_read(const struct mei_me_hw *hw)
 {
@@ -80,9 +80,9 @@ static inline u32 mei_me_mecsr_read(const struct mei_me_hw *hw)
 /**
  * mei_hcsr_read - Reads 32bit data from the host CSR
  *
- * @dev: the device structure
+ * @hw: the me hardware structure
  *
- * returns H_CSR register value (u32)
+ * Return: H_CSR register value (u32)
  */
 static inline u32 mei_hcsr_read(const struct mei_me_hw *hw)
 {
@@ -93,7 +93,7 @@ static inline u32 mei_hcsr_read(const struct mei_me_hw *hw)
  * mei_hcsr_set - writes H_CSR register to the mei device,
  * and ignores the H_IS bit for it is write-one-to-zero.
  *
- * @dev: the device structure
+ * @hw: the me hardware structure
  */
 static inline void mei_hcsr_set(struct mei_me_hw *hw, u32 hcsr)
 {
@@ -274,8 +274,8 @@ static void mei_me_host_set_ready(struct mei_device *dev)
 /**
  * mei_me_host_is_ready - check whether the host has turned ready
  *
- * @dev - mei device
- * returns bool
+ * @dev: mei device
+ * Return: bool
  */
 static bool mei_me_host_is_ready(struct mei_device *dev)
 {
@@ -288,8 +288,8 @@ static bool mei_me_host_is_ready(struct mei_device *dev)
 /**
  * mei_me_hw_is_ready - check whether the me(hw) has turned ready
  *
- * @dev - mei device
- * returns bool
+ * @dev: mei device
+ * Return: bool
  */
 static bool mei_me_hw_is_ready(struct mei_device *dev)
 {
@@ -333,7 +333,7 @@ static int mei_me_hw_start(struct mei_device *dev)
  *
  * @dev: the device structure
  *
- * returns number of filled slots
+ * Return: number of filled slots
  */
 static unsigned char mei_hbuf_filled_slots(struct mei_device *dev)
 {
@@ -353,7 +353,7 @@ static unsigned char mei_hbuf_filled_slots(struct mei_device *dev)
  *
  * @dev: the device structure
  *
- * returns true if empty, false - otherwise.
+ * Return: true if empty, false - otherwise.
  */
 static bool mei_me_hbuf_is_empty(struct mei_device *dev)
 {
@@ -365,7 +365,7 @@ static bool mei_me_hbuf_is_empty(struct mei_device *dev)
  *
  * @dev: the device structure
  *
- * returns -EOVERFLOW if overflow, otherwise empty slots count
+ * Return: -EOVERFLOW if overflow, otherwise empty slots count
  */
 static int mei_me_hbuf_empty_slots(struct mei_device *dev)
 {
@@ -394,7 +394,7 @@ static size_t mei_me_hbuf_max_len(const struct mei_device *dev)
  * @header: mei HECI header of message
  * @buf: message payload will be written
  *
- * This function returns -EIO if write has failed
+ * Return: -EIO if write has failed
  */
 static int mei_me_write_message(struct mei_device *dev,
 			struct mei_msg_hdr *header,
@@ -444,7 +444,7 @@ static int mei_me_write_message(struct mei_device *dev,
  *
  * @dev: the device structure
  *
- * returns -EOVERFLOW if overflow, otherwise filled slots count
+ * Return: -EOVERFLOW if overflow, otherwise filled slots count
  */
 static int mei_me_count_full_read_slots(struct mei_device *dev)
 {
@@ -529,7 +529,7 @@ static void mei_me_pg_exit(struct mei_device *dev)
  *
  * @dev: the device structure
  *
- * returns 0 on success an error code otherwise
+ * Return: 0 on success an error code otherwise
  */
 int mei_me_pg_set_sync(struct mei_device *dev)
 {
@@ -566,7 +566,7 @@ int mei_me_pg_set_sync(struct mei_device *dev)
  *
  * @dev: the device structure
  *
- * returns 0 on success an error code otherwise
+ * Return: 0 on success an error code otherwise
  */
 int mei_me_pg_unset_sync(struct mei_device *dev)
 {
@@ -603,7 +603,7 @@ reply:
  *
  * @dev: the device structure
  *
- * returns: true is pg supported, false otherwise
+ * Return: true is pg supported, false otherwise
  */
 static bool mei_me_pg_is_enabled(struct mei_device *dev)
 {
@@ -635,7 +635,7 @@ notsupported:
  * @irq: The irq number
  * @dev_id: pointer to the device structure
  *
- * returns irqreturn_t
+ * Return: irqreturn_t
  */
 
 irqreturn_t mei_me_irq_quick_handler(int irq, void *dev_id)
@@ -660,7 +660,7 @@ irqreturn_t mei_me_irq_quick_handler(int irq, void *dev_id)
  * @irq: The irq number
  * @dev_id: pointer to the device structure
  *
- * returns irqreturn_t
+ * Return: irqreturn_t
  *
  */
 irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
@@ -841,7 +841,7 @@ const struct mei_cfg mei_me_lpt_cfg = {
  * @pdev: The pci device structure
  * @cfg: per device generation config
  *
- * returns The mei_device_device pointer on success, NULL on failure.
+ * Return: The mei_device_device pointer on success, NULL on failure.
  */
 struct mei_device *mei_me_dev_init(struct pci_dev *pdev,
 				   const struct mei_cfg *cfg)
diff --git a/drivers/misc/mei/hw-txe.c b/drivers/misc/mei/hw-txe.c
index 695d480..0a15522 100644
--- a/drivers/misc/mei/hw-txe.c
+++ b/drivers/misc/mei/hw-txe.c
@@ -85,7 +85,7 @@ static inline u32 mei_txe_sec_reg_read(struct mei_txe_hw *hw,
  * mei_txe_sec_reg_write_silent - Writes 32bit data to the SeC BAR
  *   doesn't check for aliveness
  *
- * @dev: the device structure
+ * @hw: the txe hardware structure
  * @offset: register offset
  * @value: value to write
  *
@@ -100,7 +100,7 @@ static inline void mei_txe_sec_reg_write_silent(struct mei_txe_hw *hw,
 /**
  * mei_txe_sec_reg_write - Writes 32bit data to the SeC BAR
  *
- * @dev: the device structure
+ * @hw: the txe hardware structure
  * @offset: register offset
  * @value: value to write
  *
@@ -128,7 +128,7 @@ static inline u32 mei_txe_br_reg_read(struct mei_txe_hw *hw,
 /**
  * mei_txe_br_reg_write - Writes 32bit data to the Bridge BAR
  *
- * @hw: the device structure
+ * @hw: the txe hardware structure
  * @offset: offset from which to write the data
  * @value: the byte to write
  */
@@ -205,7 +205,8 @@ static u32 mei_txe_aliveness_get(struct mei_device *dev)
  * @expected: expected aliveness value
  *
  * Polls for HICR_HOST_ALIVENESS_RESP.ALIVENESS_RESP to be set
- * returns > 0 if the expected value was received, -ETIME otherwise
+ *
+ * Return: > 0 if the expected value was received, -ETIME otherwise
  */
 static int mei_txe_aliveness_poll(struct mei_device *dev, u32 expected)
 {
@@ -238,7 +239,8 @@ static int mei_txe_aliveness_poll(struct mei_device *dev, u32 expected)
  * @expected: expected aliveness value
  *
  * Waits for HICR_HOST_ALIVENESS_RESP.ALIVENESS_RESP to be set
- * returns returns 0 on success and < 0 otherwise
+ *
+ * Return: 0 on success and < 0 otherwise
  */
 static int mei_txe_aliveness_wait(struct mei_device *dev, u32 expected)
 {
@@ -277,7 +279,7 @@ static int mei_txe_aliveness_wait(struct mei_device *dev, u32 expected)
  *
  * @dev: the device structure
  *
- * returns returns 0 on success and < 0 otherwise
+ * Return: 0 on success and < 0 otherwise
  */
 int mei_txe_aliveness_set_sync(struct mei_device *dev, u32 req)
 {
@@ -291,7 +293,7 @@ int mei_txe_aliveness_set_sync(struct mei_device *dev, u32 req)
  *
  * @dev: the device structure
  *
- * returns: true is pg supported, false otherwise
+ * Return: true is pg supported, false otherwise
  */
 static bool mei_txe_pg_is_enabled(struct mei_device *dev)
 {
@@ -304,7 +306,7 @@ static bool mei_txe_pg_is_enabled(struct mei_device *dev)
  *
  * @dev: the device structure
  *
- * returns: MEI_PG_OFF if aliveness is on and MEI_PG_ON otherwise
+ * Return: MEI_PG_OFF if aliveness is on and MEI_PG_ON otherwise
  */
 static inline enum mei_pg_state mei_txe_pg_state(struct mei_device *dev)
 {
@@ -329,9 +331,10 @@ static void mei_txe_input_ready_interrupt_enable(struct mei_device *dev)
 }
 
 /**
- * mei_txe_input_doorbell_set
- *   - Sets bit 0 in SEC_IPC_INPUT_DOORBELL.IPC_INPUT_DOORBELL.
- * @dev: the device structure
+ * mei_txe_input_doorbell_set - sets bit 0 in
+ *    SEC_IPC_INPUT_DOORBELL.IPC_INPUT_DOORBELL.
+ *
+ * @hw: the txe hardware structure
  */
 static void mei_txe_input_doorbell_set(struct mei_txe_hw *hw)
 {
@@ -343,7 +346,7 @@ static void mei_txe_input_doorbell_set(struct mei_txe_hw *hw)
 /**
  * mei_txe_output_ready_set - Sets the SICR_SEC_IPC_OUTPUT_STATUS bit to 1
  *
- * @dev: the device structure
+ * @hw: the txe hardware structure
  */
 static void mei_txe_output_ready_set(struct mei_txe_hw *hw)
 {
@@ -459,7 +462,7 @@ static void mei_txe_input_payload_write(struct mei_device *dev,
  * @dev: the device structure
  * @idx: index in the device buffer
  *
- * returns register value at index
+ * Return: register value at index
  */
 static u32 mei_txe_out_data_read(const struct mei_device *dev,
 					unsigned long idx)
@@ -503,6 +506,8 @@ static void mei_txe_readiness_clear(struct mei_device *dev)
  *	the HICR_SEC_IPC_READINESS register value
  *
  * @dev: the device structure
+ *
+ * Return: the HICR_SEC_IPC_READINESS register value
  */
 static u32 mei_txe_readiness_get(struct mei_device *dev)
 {
@@ -553,7 +558,7 @@ static inline bool mei_txe_host_is_ready(struct mei_device *dev)
  *
  * @dev: the device structure
  *
- * returns 0 on success and -ETIME on timeout
+ * Return: 0 on success and -ETIME on timeout
  */
 static int mei_txe_readiness_wait(struct mei_device *dev)
 {
@@ -637,7 +642,8 @@ static void mei_txe_hw_config(struct mei_device *dev)
  * @dev: the device structure
  * @header: header of message
  * @buf: message buffer will be written
- * returns 1 if success, 0 - otherwise.
+ *
+ * Return: if success, 0 - otherwise.
  */
 
 static int mei_txe_write(struct mei_device *dev,
@@ -704,7 +710,7 @@ static int mei_txe_write(struct mei_device *dev,
  *
  * @dev: the device structure
  *
- * returns the PAYLOAD_SIZE - 4
+ * Return: PAYLOAD_SIZE - 4
  */
 static size_t mei_txe_hbuf_max_len(const struct mei_device *dev)
 {
@@ -716,7 +722,7 @@ static size_t mei_txe_hbuf_max_len(const struct mei_device *dev)
  *
  * @dev: the device structure
  *
- * returns always hbuf_depth
+ * Return: always hbuf_depth
  */
 static int mei_txe_hbuf_empty_slots(struct mei_device *dev)
 {
@@ -730,7 +736,7 @@ static int mei_txe_hbuf_empty_slots(struct mei_device *dev)
  *
  * @dev: the device structure
  *
- * returns always buffer size in dwords count
+ * Return: always buffer size in dwords count
  */
 static int mei_txe_count_full_read_slots(struct mei_device *dev)
 {
@@ -743,7 +749,7 @@ static int mei_txe_count_full_read_slots(struct mei_device *dev)
  *
  * @dev: the device structure
  *
- * returns mei message header
+ * Return: mei message header
  */
 
 static u32 mei_txe_read_hdr(const struct mei_device *dev)
@@ -757,7 +763,7 @@ static u32 mei_txe_read_hdr(const struct mei_device *dev)
  * @buf: message buffer will be written
  * @len: message size will be read
  *
- * returns -EINVAL on error wrong argument and 0 on success
+ * Return: -EINVAL on error wrong argument and 0 on success
  */
 static int mei_txe_read(struct mei_device *dev,
 		unsigned char *buf, unsigned long len)
@@ -799,7 +805,7 @@ static int mei_txe_read(struct mei_device *dev,
  * @dev: the device structure
  * @intr_enable: if interrupt should be enabled after reset.
  *
- * returns 0 on success and < 0 in case of error
+ * Return: 0 on success and < 0 in case of error
  */
 static int mei_txe_hw_reset(struct mei_device *dev, bool intr_enable)
 {
@@ -853,7 +859,7 @@ static int mei_txe_hw_reset(struct mei_device *dev, bool intr_enable)
  *
  * @dev: the device structure
  *
- * returns 0 on success and < 0 in case of error
+ * Return: 0 on success and < 0 in case of error
  */
 static int mei_txe_hw_start(struct mei_device *dev)
 {
@@ -964,7 +970,8 @@ out:
  * @irq: The irq number
  * @dev_id: pointer to the device structure
  *
- * returns irqreturn_t
+ * Return: IRQ_WAKE_THREAD if interrupt is designed for the device
+ *         IRQ_NONE otherwise
  */
 irqreturn_t mei_txe_irq_quick_handler(int irq, void *dev_id)
 {
@@ -982,7 +989,7 @@ irqreturn_t mei_txe_irq_quick_handler(int irq, void *dev_id)
  * @irq: The irq number
  * @dev_id: pointer to the device structure
  *
- * returns irqreturn_t
+ * Return: IRQ_HANDLED
  *
  */
 irqreturn_t mei_txe_irq_thread_handler(int irq, void *dev_id)
@@ -1130,7 +1137,7 @@ static const struct mei_hw_ops mei_txe_hw_ops = {
  *
  * @pdev - pci device
  *
- * returns struct mei_device * on success or NULL;
+ * Return: struct mei_device * on success or NULL;
  *
  */
 struct mei_device *mei_txe_dev_init(struct pci_dev *pdev)
diff --git a/drivers/misc/mei/hw.h b/drivers/misc/mei/hw.h
index 6e31113..ea8de2a 100644
--- a/drivers/misc/mei/hw.h
+++ b/drivers/misc/mei/hw.h
@@ -99,16 +99,16 @@ enum mei_stop_reason_types {
 
 
 /**
- * mei_hbm_status  - mei host bus messages return values
+ * enum mei_hbm_status  - mei host bus messages return values
  *
- * @MEI_HBMS_SUCCESS           - status success
- * @MEI_HBMS_CLIENT_NOT_FOUND  - client not found
- * @MEI_HBMS_ALREADY_EXISTS    - connection already established
- * @MEI_HBMS_REJECTED          - connection is rejected
- * @MEI_HBMS_INVALID_PARAMETER - invalid parameter
- * @MEI_HBMS_NOT_ALLOWED       - operation not allowed
- * @MEI_HBMS_ALREADY_STARTED   - system is already started
- * @MEI_HBMS_NOT_STARTED       - system not started
+ * @MEI_HBMS_SUCCESS           : status success
+ * @MEI_HBMS_CLIENT_NOT_FOUND  : client not found
+ * @MEI_HBMS_ALREADY_EXISTS    : connection already established
+ * @MEI_HBMS_REJECTED          : connection is rejected
+ * @MEI_HBMS_INVALID_PARAMETER : invalid parameter
+ * @MEI_HBMS_NOT_ALLOWED       : operation not allowed
+ * @MEI_HBMS_ALREADY_STARTED   : system is already started
+ * @MEI_HBMS_NOT_STARTED       : system not started
  */
 enum mei_hbm_status {
 	MEI_HBMS_SUCCESS           = 0,
@@ -165,10 +165,10 @@ struct mei_bus_message {
  * struct hbm_cl_cmd - client specific host bus command
  *	CONNECT, DISCONNECT, and FlOW CONTROL
  *
- * @hbm_cmd - bus message command header
- * @me_addr - address of the client in ME
- * @host_addr - address of the client in the driver
- * @data
+ * @hbm_cmd: bus message command header
+ * @me_addr: address of the client in ME
+ * @host_addr: address of the client in the driver
+ * @data: generic data
  */
 struct mei_hbm_cl_cmd {
 	u8 hbm_cmd;
@@ -248,8 +248,8 @@ struct hbm_props_response {
 /**
  * struct hbm_power_gate - power gate request/response
  *
- * @hbm_cmd - bus message command header
- * @reserved[3]
+ * @hbm_cmd: bus message command header
+ * @reserved: reserved
  */
 struct hbm_power_gate {
 	u8 hbm_cmd;
@@ -259,10 +259,10 @@ struct hbm_power_gate {
 /**
  * struct hbm_client_connect_request - connect/disconnect request
  *
- * @hbm_cmd - bus message command header
- * @me_addr - address of the client in ME
- * @host_addr - address of the client in the driver
- * @reserved
+ * @hbm_cmd: bus message command header
+ * @me_addr: address of the client in ME
+ * @host_addr: address of the client in the driver
+ * @reserved: reserved
  */
 struct hbm_client_connect_request {
 	u8 hbm_cmd;
@@ -274,10 +274,10 @@ struct hbm_client_connect_request {
 /**
  * struct hbm_client_connect_response - connect/disconnect response
  *
- * @hbm_cmd - bus message command header
- * @me_addr - address of the client in ME
- * @host_addr - address of the client in the driver
- * @status - status of the request
+ * @hbm_cmd: bus message command header
+ * @me_addr: address of the client in ME
+ * @host_addr: address of the client in the driver
+ * @status: status of the request
  */
 struct hbm_client_connect_response {
 	u8 hbm_cmd;
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 76ef8ff..52d7f42 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -56,11 +56,11 @@ const char *mei_pg_state_str(enum mei_pg_state state)
 
 
 /**
- * mei_cancel_work. Cancel mei background jobs
+ * mei_cancel_work - Cancel mei background jobs
  *
  * @dev: the device structure
  *
- * returns 0 on success or < 0 if the reset hasn't succeeded
+ * Return: 0 on success or < 0 if the reset hasn't succeeded
  */
 void mei_cancel_work(struct mei_device *dev)
 {
@@ -175,7 +175,7 @@ EXPORT_SYMBOL_GPL(mei_reset);
  *
  * @dev: the device structure
  *
- * returns 0 on success, <0 on failure.
+ * Return: 0 on success, <0 on failure.
  */
 int mei_start(struct mei_device *dev)
 {
@@ -244,7 +244,7 @@ EXPORT_SYMBOL_GPL(mei_start);
  *
  * @dev: the device structure
  *
- * returns 0 on success or -ENODEV if the restart hasn't succeeded
+ * Return: 0 on success or -ENODEV if the restart hasn't succeeded
  */
 int mei_restart(struct mei_device *dev)
 {
@@ -325,7 +325,7 @@ EXPORT_SYMBOL_GPL(mei_stop);
  *
  * @dev: the device structure
  *
- * returns true of there is no pending write
+ * Return: true of there is no pending write
  */
 bool mei_write_is_idle(struct mei_device *dev)
 {
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 8844e17..d8aa1d3 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -33,8 +33,8 @@
  * mei_irq_compl_handler - dispatch complete handlers
  *	for the completed callbacks
  *
- * @dev - mei device
- * @compl_list - list of completed cbs
+ * @dev: mei device
+ * @compl_list: list of completed cbs
  */
 void mei_irq_compl_handler(struct mei_device *dev, struct mei_cl_cb *compl_list)
 {
@@ -62,7 +62,7 @@ EXPORT_SYMBOL_GPL(mei_irq_compl_handler);
  * @cl: host client
  * @mei_hdr: header of mei client message
  *
- * returns true if matches, false otherwise
+ * Return: true if matches, false otherwise
  */
 static inline int mei_cl_hbm_equal(struct mei_cl *cl,
 			struct mei_msg_hdr *mei_hdr)
@@ -72,12 +72,12 @@ static inline int mei_cl_hbm_equal(struct mei_cl *cl,
 }
 /**
  * mei_cl_is_reading - checks if the client
-		is the one to read this message
+ *		is the one to read this message
  *
  * @cl: mei client
  * @mei_hdr: header of mei message
  *
- * returns true on match and false otherwise
+ * Return: true on match and false otherwise
  */
 static bool mei_cl_is_reading(struct mei_cl *cl, struct mei_msg_hdr *mei_hdr)
 {
@@ -93,7 +93,7 @@ static bool mei_cl_is_reading(struct mei_cl *cl, struct mei_msg_hdr *mei_hdr)
  * @mei_hdr: header of mei client message
  * @complete_list: An instance of our list structure
  *
- * returns 0 on success, <0 on failure.
+ * Return: 0 on success, <0 on failure.
  */
 static int mei_cl_irq_read_msg(struct mei_device *dev,
 			       struct mei_msg_hdr *mei_hdr,
@@ -165,7 +165,7 @@ static int mei_cl_irq_read_msg(struct mei_device *dev,
  * @cb: callback block.
  * @cmpl_list: complete list.
  *
- * returns 0, OK; otherwise, error.
+ * Return: 0, OK; otherwise, error.
  */
 static int mei_cl_irq_disconnect_rsp(struct mei_cl *cl, struct mei_cl_cb *cb,
 				     struct mei_cl_cb *cmpl_list)
@@ -201,7 +201,7 @@ static int mei_cl_irq_disconnect_rsp(struct mei_cl *cl, struct mei_cl_cb *cb,
  * @cb: callback block.
  * @cmpl_list: complete list.
  *
- * returns 0, OK; otherwise, error.
+ * Return: 0, OK; otherwise, error.
  */
 static int mei_cl_irq_disconnect(struct mei_cl *cl, struct mei_cl_cb *cb,
 			    struct mei_cl_cb *cmpl_list)
@@ -241,7 +241,7 @@ static int mei_cl_irq_disconnect(struct mei_cl *cl, struct mei_cl_cb *cb,
  * @cb: callback block.
  * @cmpl_list: complete list.
  *
- * returns 0, OK; otherwise, error.
+ * Return: 0, OK; otherwise, error.
  */
 static int mei_cl_irq_read(struct mei_cl *cl, struct mei_cl_cb *cb,
 			   struct mei_cl_cb *cmpl_list)
@@ -278,7 +278,7 @@ static int mei_cl_irq_read(struct mei_cl *cl, struct mei_cl_cb *cb,
  * @cb: callback block.
  * @cmpl_list: complete list.
  *
- * returns 0, OK; otherwise, error.
+ * Return: 0, OK; otherwise, error.
  */
 static int mei_cl_irq_connect(struct mei_cl *cl, struct mei_cl_cb *cb,
 			      struct mei_cl_cb *cmpl_list)
@@ -321,7 +321,7 @@ static int mei_cl_irq_connect(struct mei_cl *cl, struct mei_cl_cb *cb,
  * @cmpl_list: An instance of our list structure
  * @slots: slots to read.
  *
- * returns 0 on success, <0 on failure.
+ * Return: 0 on success, <0 on failure.
  */
 int mei_irq_read_handler(struct mei_device *dev,
 		struct mei_cl_cb *cmpl_list, s32 *slots)
@@ -424,7 +424,7 @@ EXPORT_SYMBOL_GPL(mei_irq_read_handler);
  * @dev: the device structure
  * @cmpl_list: An instance of our list structure
  *
- * returns 0 on success, <0 on failure.
+ * Return: 0 on success, <0 on failure.
  */
 int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 {
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index d31f271..beedc91 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -44,7 +44,7 @@
  * @inode: pointer to inode structure
  * @file: pointer to file structure
  *
- * returns 0 on success, <0 on error
+ * Return: 0 on success, <0 on error
  */
 static int mei_open(struct inode *inode, struct file *file)
 {
@@ -96,7 +96,7 @@ err_unlock:
  * @inode: pointer to inode structure
  * @file: pointer to file structure
  *
- * returns 0 on success, <0 on error
+ * Return: 0 on success, <0 on error
  */
 static int mei_release(struct inode *inode, struct file *file)
 {
@@ -157,7 +157,7 @@ out:
  * @length: buffer length
  * @offset: data offset in buffer
  *
- * returns >=0 data length on success , <0 on error
+ * Return: >=0 data length on success , <0 on error
  */
 static ssize_t mei_read(struct file *file, char __user *ubuf,
 			size_t length, loff_t *offset)
@@ -297,7 +297,7 @@ out:
  * @length: buffer length
  * @offset: data offset in buffer
  *
- * returns >=0 data length on success , <0 on error
+ * Return: >=0 data length on success , <0 on error
  */
 static ssize_t mei_write(struct file *file, const char __user *ubuf,
 			 size_t length, loff_t *offset)
@@ -414,13 +414,12 @@ out:
 /**
  * mei_ioctl_connect_client - the connect to fw client IOCTL function
  *
- * @dev: the device structure
- * @data: IOCTL connect data, input and output parameters
  * @file: private data of the file object
+ * @data: IOCTL connect data, input and output parameters
  *
  * Locking: called under "dev->device_lock" lock
  *
- * returns 0 on success, <0 on failure.
+ * Return: 0 on success, <0 on failure.
  */
 static int mei_ioctl_connect_client(struct file *file,
 			struct mei_connect_client_data *data)
@@ -509,7 +508,7 @@ end:
  * @cmd: ioctl command
  * @data: pointer to mei message structure
  *
- * returns 0 on success , <0 on error
+ * Return: 0 on success , <0 on error
  */
 static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 {
@@ -573,7 +572,7 @@ out:
  * @cmd: ioctl command
  * @data: pointer to mei message structure
  *
- * returns 0 on success , <0 on error
+ * Return: 0 on success , <0 on error
  */
 #ifdef CONFIG_COMPAT
 static long mei_compat_ioctl(struct file *file,
@@ -590,7 +589,7 @@ static long mei_compat_ioctl(struct file *file,
  * @file: pointer to file structure
  * @wait: pointer to poll_table structure
  *
- * returns poll mask
+ * Return: poll mask
  */
 static unsigned int mei_poll(struct file *file, poll_table *wait)
 {
@@ -660,7 +659,7 @@ static DEFINE_IDR(mei_idr);
  *
  * @dev:  device pointer
  *
- * returns allocated minor, or -ENOSPC if no free minor left
+ * Return: allocated minor, or -ENOSPC if no free minor left
  */
 static int mei_minor_get(struct mei_device *dev)
 {
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 0a1f2b7..563eebb 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -157,8 +157,8 @@ struct mei_msg_data {
 /*
  * struct mei_fw_status - storage of FW status data
  *
- * @count - number of actually available elements in array
- * @status - FW status registers
+ * @count: number of actually available elements in array
+ * @status: FW status registers
  */
 struct mei_fw_status {
 	int count;
@@ -168,9 +168,10 @@ struct mei_fw_status {
 /**
  * struct mei_me_client - representation of me (fw) client
  *
- * @props  - client properties
- * @client_id - me client id
- * @mei_flow_ctrl_creds - flow control credits
+ * @list: link in me client list
+ * @props: client properties
+ * @client_id: me client id
+ * @mei_flow_ctrl_creds: flow control credits
  */
 struct mei_me_client {
 	struct list_head list;
@@ -185,8 +186,9 @@ struct mei_cl;
 /**
  * struct mei_cl_cb - file operation callback structure
  *
- * @cl - file client who is running this operation
- * @fop_type - file operation type
+ * @list: link in callback queue
+ * @cl: file client who is running this operation
+ * @fop_type: file operation type
  */
 struct mei_cl_cb {
 	struct list_head list;
@@ -226,31 +228,31 @@ struct mei_cl {
 
 /** struct mei_hw_ops
  *
- * @host_is_ready    - query for host readiness
+ * @host_is_ready    : query for host readiness
 
- * @hw_is_ready      - query if hw is ready
- * @hw_reset         - reset hw
- * @hw_start         - start hw after reset
- * @hw_config        - configure hw
+ * @hw_is_ready      : query if hw is ready
+ * @hw_reset         : reset hw
+ * @hw_start         : start hw after reset
+ * @hw_config        : configure hw
 
- * @fw_status        - get fw status registers
- * @pg_state         - power gating state of the device
- * @pg_is_enabled    - is power gating enabled
+ * @fw_status        : get fw status registers
+ * @pg_state         : power gating state of the device
+ * @pg_is_enabled    : is power gating enabled
 
- * @intr_clear       - clear pending interrupts
- * @intr_enable      - enable interrupts
- * @intr_disable     - disable interrupts
+ * @intr_clear       : clear pending interrupts
+ * @intr_enable      : enable interrupts
+ * @intr_disable     : disable interrupts
 
- * @hbuf_free_slots  - query for write buffer empty slots
- * @hbuf_is_ready    - query if write buffer is empty
- * @hbuf_max_len     - query for write buffer max len
+ * @hbuf_free_slots  : query for write buffer empty slots
+ * @hbuf_is_ready    : query if write buffer is empty
+ * @hbuf_max_len     : query for write buffer max len
 
- * @write            - write a message to FW
+ * @write            : write a message to FW
 
- * @rdbuf_full_slots - query how many slots are filled
+ * @rdbuf_full_slots : query how many slots are filled
 
- * @read_hdr         - get first 4 bytes (header)
- * @read             - read a buffer from the FW
+ * @read_hdr         : get first 4 bytes (header)
+ * @read             : read a buffer from the FW
  */
 struct mei_hw_ops {
 
@@ -330,7 +332,6 @@ void mei_cl_bus_exit(void);
  * when being probed and shall use it for doing ME bus I/O.
  *
  * @dev: linux driver model device pointer
- * @uuid: me client uuid
  * @cl: mei client
  * @ops: ME transport ops
  * @event_cb: Drivers register this callback to get asynchronous ME
@@ -383,21 +384,21 @@ const char *mei_pg_state_str(enum mei_pg_state state);
 /**
  * struct mei_device -  MEI private device struct
 
- * @dev  - device on a bus
- * @cdev - character device
- * @minor - minor number allocated for device
+ * @dev         : device on a bus
+ * @cdev        : character device
+ * @minor       : minor number allocated for device
  *
- * @reset_count - limits the number of consecutive resets
- * @hbm_state - state of host bus message protocol
+ * @reset_count : limits the number of consecutive resets
+ * @hbm_state   : state of host bus message protocol
  *
- * @hbm_f_pg_supported - hbm feature pgi protocol
+ * @hbm_f_pg_supported : hbm feature pgi protocol
  *
- * @pg_event - power gating event
- * @mem_addr - mem mapped base register address
+ * @pg_event    : power gating event
+ * @mem_addr    : mem mapped base register address
 
- * @hbuf_depth - depth of hardware host/write buffer is slots
- * @hbuf_is_ready - query if the host host/write buffer is ready
- * @wr_msg - the buffer for hbm control messages
+ * @hbuf_depth  : depth of hardware host/write buffer is slots
+ * @hbuf_is_ready : query if the host host/write buffer is ready
+ * @wr_msg      : the buffer for hbm control messages
  */
 struct mei_device {
 	struct device *dev;
@@ -521,8 +522,9 @@ static inline unsigned long mei_secs_to_jiffies(unsigned long sec)
 /**
  * mei_data2slots - get slots - number of (dwords) from a message length
  *	+ size of the mei header
- * @length - size of the messages in bytes
- * returns  - number of slots
+ * @length: size of the messages in bytes
+ *
+ * Return: number of slots
  */
 static inline u32 mei_data2slots(size_t length)
 {
@@ -531,8 +533,8 @@ static inline u32 mei_data2slots(size_t length)
 
 /**
  * mei_slots2data- get data in slots - bytes from slots
- * @slots -  number of available slots
- * returns  - number of bytes in slots
+ * @slots: number of available slots
+ * Return: number of bytes in slots
  */
 static inline u32 mei_slots2data(int slots)
 {
@@ -610,12 +612,12 @@ int mei_wd_host_init(struct mei_device *dev);
 /*
  * mei_watchdog_register  - Registering watchdog interface
  *   once we got connection to the WD Client
- * @dev - mei device
+ * @dev: mei device
  */
 int mei_watchdog_register(struct mei_device *dev);
 /*
  * mei_watchdog_unregister  - Unregistering watchdog interface
- * @dev - mei device
+ * @dev: mei device
  */
 void mei_watchdog_unregister(struct mei_device *dev);
 
diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 5b369f4..288665e 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -88,7 +88,8 @@ struct mei_nfc_hci_hdr {
 
 #define MEI_NFC_HEADER_SIZE 10
 
-/** mei_nfc_dev - NFC mei device
+/**
+ * struct mei_nfc_dev - NFC mei device
  *
  * @cl: NFC host client
  * @cl_info: NFC info host client
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index a910717..532d393 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -103,7 +103,7 @@ static inline void mei_me_unset_pm_domain(struct mei_device *dev) {}
  * @pdev: PCI device structure
  * @cfg: per generation config
  *
- * returns true if ME Interface is valid, false otherwise
+ * Return: true if ME Interface is valid, false otherwise
  */
 static bool mei_me_quirk_probe(struct pci_dev *pdev,
 				const struct mei_cfg *cfg)
@@ -122,7 +122,7 @@ static bool mei_me_quirk_probe(struct pci_dev *pdev,
  * @pdev: PCI device structure
  * @ent: entry in kcs_pci_tbl
  *
- * returns 0 on success, <0 on failure.
+ * Return: 0 on success, <0 on failure.
  */
 static int mei_me_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
diff --git a/drivers/misc/mei/pci-txe.c b/drivers/misc/mei/pci-txe.c
index 69eb999..2898480 100644
--- a/drivers/misc/mei/pci-txe.c
+++ b/drivers/misc/mei/pci-txe.c
@@ -67,7 +67,7 @@ static void mei_txe_pci_iounmap(struct pci_dev *pdev, struct mei_txe_hw *hw)
  * @pdev: PCI device structure
  * @ent: entry in mei_txe_pci_tbl
  *
- * returns 0 on success, <0 on failure.
+ * Return: 0 on success, <0 on failure.
  */
 static int mei_txe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 626b4c1..b836dff 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -51,7 +51,7 @@ static void mei_wd_set_start_timeout(struct mei_device *dev, u16 timeout)
  *
  * @dev: the device structure
  *
- * returns -ENOTTY if wd client cannot be found
+ * Return: -ENOTTY if wd client cannot be found
  *         -EIO if write has failed
  *         0 on success
  */
@@ -105,7 +105,7 @@ int mei_wd_host_init(struct mei_device *dev)
  *
  * @dev: the device structure
  *
- * returns 0 if success,
+ * Return: 0 if success,
  *	-EIO when message send fails
  *	-EINVAL when invalid message is to be sent
  *	-ENODEV on flow control failure
@@ -150,9 +150,8 @@ int mei_wd_send(struct mei_device *dev)
  * mei_wd_stop - sends watchdog stop message to fw.
  *
  * @dev: the device structure
- * @preserve: indicate if to keep the timeout value
  *
- * returns 0 if success
+ * Return: 0 if success
  * on error:
  *	-EIO    when message send fails
  *	-EINVAL when invalid message is to be sent
@@ -207,7 +206,7 @@ err:
  *
  * @wd_dev - watchdog device struct
  *
- * returns 0 if success, negative errno code for failure
+ * Return: 0 if success, negative errno code for failure
  */
 static int mei_wd_ops_start(struct watchdog_device *wd_dev)
 {
@@ -244,7 +243,7 @@ end_unlock:
  *
  * @wd_dev - watchdog device struct
  *
- * returns 0 if success, negative errno code for failure
+ * Return: 0 if success, negative errno code for failure
  */
 static int mei_wd_ops_stop(struct watchdog_device *wd_dev)
 {
@@ -266,7 +265,7 @@ static int mei_wd_ops_stop(struct watchdog_device *wd_dev)
  *
  * @wd_dev - watchdog device struct
  *
- * returns 0 if success, negative errno code for failure
+ * Return: 0 if success, negative errno code for failure
  */
 static int mei_wd_ops_ping(struct watchdog_device *wd_dev)
 {
@@ -314,7 +313,7 @@ end:
  * @wd_dev - watchdog device struct
  * @timeout - timeout value to set
  *
- * returns 0 if success, negative errno code for failure
+ * Return: 0 if success, negative errno code for failure
  */
 static int mei_wd_ops_set_timeout(struct watchdog_device *wd_dev,
 		unsigned int timeout)
-- 
1.9.3

