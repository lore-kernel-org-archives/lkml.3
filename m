Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762832Ab3DDQFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:05:15 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:52546 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762806Ab3DDQFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:05:14 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org, tomas.winkler@intel.com
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] mei: Fix typo in drivers/misc/mei
Date: Fri,  5 Apr 2013 01:05:05 +0900
Message-Id: <1365091505-24583-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.2.279.g631bc94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typos in comments

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/misc/mei/amthif.c    |  6 +++---
 drivers/misc/mei/client.c    | 24 ++++++++++++------------
 drivers/misc/mei/hbm.c       |  9 +++++----
 drivers/misc/mei/hw-me.c     |  8 ++++----
 drivers/misc/mei/interrupt.c |  6 +++---
 drivers/misc/mei/pci-me.c    |  1 +
 drivers/misc/mei/wd.c        |  1 +
 7 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index c86d7e3..1fbfd63 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -60,7 +60,7 @@ void mei_amthif_reset_params(struct mei_device *dev)
 }
 
 /**
- * mei_amthif_host_init_ - mei initialization amthif client.
+ * mei_amthif_host_init - mei initialization amthif client.
  *
  * @dev: the device structure
  *
@@ -433,7 +433,7 @@ unsigned int mei_amthif_poll(struct mei_device *dev,
 
 
 /**
- * mei_amthif_irq_process_completed - processes completed iamthif operation.
+ * mei_amthif_irq_write_completed - processes completed iamthif operation.
  *
  * @dev: the device structure.
  * @slots: free slots.
@@ -703,7 +703,7 @@ static bool mei_clear_lists(struct mei_device *dev, struct file *file)
 /**
 * mei_amthif_release - the release function
 *
-*  @inode: pointer to inode structure
+*  @dev: device structure
 *  @file: pointer to file structure
 *
 *  returns 0 on success, <0 on error
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 1569afe..f2685ab 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -109,7 +109,7 @@ void mei_io_cb_free(struct mei_cl_cb *cb)
  * mei_io_cb_init - allocate and initialize io callback
  *
  * @cl - mei client
- * @file: pointer to file structure
+ * @fp: pointer to file structure
  *
  * returns mei_cl_cb pointer or NULL;
  */
@@ -132,8 +132,8 @@ struct mei_cl_cb *mei_io_cb_init(struct mei_cl *cl, struct file *fp)
 /**
  * mei_io_cb_alloc_req_buf - allocate request buffer
  *
- * @cb -  io callback structure
- * @size: size of the buffer
+ * @cb: io callback structure
+ * @length: size of the buffer
  *
  * returns 0 on success
  *         -EINVAL if cb is NULL
@@ -154,10 +154,10 @@ int mei_io_cb_alloc_req_buf(struct mei_cl_cb *cb, size_t length)
 	return 0;
 }
 /**
- * mei_io_cb_alloc_req_buf - allocate respose buffer
+ * mei_io_cb_alloc_resp_buf - allocate respose buffer
  *
- * @cb -  io callback structure
- * @size: size of the buffer
+ * @cb: io callback structure
+ * @length: size of the buffer
  *
  * returns 0 on success
  *         -EINVAL if cb is NULL
@@ -183,7 +183,6 @@ int mei_io_cb_alloc_resp_buf(struct mei_cl_cb *cb, size_t length)
 /**
  * mei_cl_flush_queues - flushes queue lists belonging to cl.
  *
- * @dev: the device structure
  * @cl: host client
  */
 int mei_cl_flush_queues(struct mei_cl *cl)
@@ -243,7 +242,8 @@ struct mei_cl *mei_cl_allocate(struct mei_device *dev)
 /**
  * mei_cl_find_read_cb - find this cl's callback in the read list
  *
- * @dev: device structure
+ * @cl: host client 
+ *
  * returns cb on success, NULL on error
  */
 struct mei_cl_cb *mei_cl_find_read_cb(struct mei_cl *cl)
@@ -262,6 +262,7 @@ struct mei_cl_cb *mei_cl_find_read_cb(struct mei_cl *cl)
  *
  * @cl - host client
  * @id - fixed host id or -1 for genereting one
+ *
  * returns 0 on success
  *	-EINVAL on incorrect values
  *	-ENONET if client not found
@@ -301,7 +302,7 @@ int mei_cl_link(struct mei_cl *cl, int id)
 /**
  * mei_cl_unlink - remove me_cl from the list
  *
- * @dev: the device structure
+ * @cl: host client 
  */
 int mei_cl_unlink(struct mei_cl *cl)
 {
@@ -534,7 +535,6 @@ out:
 /**
  * mei_cl_flow_ctrl_creds - checks flow_control credits for cl.
  *
- * @dev: the device structure
  * @cl: private data of the file object
  *
  * returns 1 if mei_flow_ctrl_creds >0, 0 - otherwise.
@@ -575,8 +575,8 @@ int mei_cl_flow_ctrl_creds(struct mei_cl *cl)
 /**
  * mei_cl_flow_ctrl_reduce - reduces flow_control.
  *
- * @dev: the device structure
  * @cl: private data of the file object
+ *
  * @returns
  *	0 on success
  *	-ENOENT when me client is not found
@@ -614,7 +614,7 @@ int mei_cl_flow_ctrl_reduce(struct mei_cl *cl)
 }
 
 /**
- * mei_cl_start_read - the start read client message function.
+ * mei_cl_read_start - the start read client message function.
  *
  * @cl: host client
  *
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index fb9e63b..4465d3f 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -62,6 +62,7 @@ static void mei_hbm_me_cl_allocate(struct mei_device *dev)
 
 /**
  * mei_hbm_cl_hdr - construct client hbm header
+ *
  * @cl: - client
  * @hbm_cmd: host bus message command
  * @buf: buffer for cl header
@@ -184,7 +185,7 @@ static void mei_hbm_enum_clients_req(struct mei_device *dev)
 }
 
 /**
- * mei_hbm_prop_requsest - request property for a single client
+ * mei_hbm_prop_req - request property for a single client
  *
  * @dev: the device structure
  *
@@ -283,9 +284,9 @@ int mei_hbm_cl_flow_control_req(struct mei_device *dev, struct mei_cl *cl)
 }
 
 /**
- * add_single_flow_creds - adds single buffer credentials.
+ * mei_hbm_add_single_flow_creds - adds single buffer credentials.
  *
- * @file: private data ot the file object.
+ * @dev: the device structure
  * @flow: flow control.
  */
 static void mei_hbm_add_single_flow_creds(struct mei_device *dev,
@@ -477,7 +478,7 @@ static void mei_hbm_cl_connect_res(struct mei_device *dev,
 
 
 /**
- * mei_client_disconnect_request - disconnect request initiated by me
+ * mei_hbm_fw_disconnect_req - disconnect request initiated by me
  *  host sends disoconnect response
  *
  * @dev: the device structure.
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 45ea718..c31f7a47 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -103,7 +103,7 @@ static inline void mei_hcsr_set(struct mei_me_hw *hw, u32 hcsr)
 
 
 /**
- * me_hw_config - configure hw dependent settings
+ * mei_me_hw_config - configure hw dependent settings
  *
  * @dev: mei device
  */
@@ -155,7 +155,7 @@ static void mei_me_intr_disable(struct mei_device *dev)
  * mei_me_hw_reset - resets fw via mei csr register.
  *
  * @dev: the device structure
- * @interrupts_enabled: if interrupt should be enabled after reset.
+ * @intr_enable: if interrupt should be enabled after reset.
  */
 static void mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 {
@@ -243,7 +243,7 @@ static unsigned char mei_hbuf_filled_slots(struct mei_device *dev)
 }
 
 /**
- * mei_hbuf_is_empty - checks if host buffer is empty.
+ * mei_me_hbuf_is_empty - checks if host buffer is empty.
  *
  * @dev: the device structure
  *
@@ -543,7 +543,7 @@ static const struct mei_hw_ops mei_me_hw_ops = {
 };
 
 /**
- * init_mei_device - allocates and initializes the mei device structure
+ * mei_me_dev_init - allocates and initializes the mei device structure
  *
  * @pdev: The pci device structure
  *
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 3535b26..8a649d7 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -30,7 +30,7 @@
 
 
 /**
- * mei_complete_handler - processes completed operation.
+ * mei_irq_complete_handler - processes completed operation.
  *
  * @cl: private data of the file object.
  * @cb_pos: callback block.
@@ -177,7 +177,7 @@ static int _mei_irq_thread_close(struct mei_device *dev, s32 *slots,
 
 
 /**
- * _mei_hb_read - processes read related operation.
+ * _mei_irq_thread_read - processes read related operation.
  *
  * @dev: the device structure.
  * @slots: free slots.
@@ -310,7 +310,7 @@ static int mei_irq_thread_write_complete(struct mei_device *dev, s32 *slots,
 }
 
 /**
- * mei_irq_thread_read_handler - bottom half read routine after ISR to
+ * mei_irq_read_handler - bottom half read routine after ISR to
  * handle the read processing.
  *
  * @dev: the device structure
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index b40ec06..df17506 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -92,6 +92,7 @@ static DEFINE_MUTEX(mei_mutex);
 
 /**
  * mei_quirk_probe - probe for devices that doesn't valid ME interface
+ *
  * @pdev: PCI device structure
  * @ent: entry into pci_device_table
  *
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 2413247..3effd5f 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -58,6 +58,7 @@ static void mei_wd_set_start_timeout(struct mei_device *dev, u16 timeout)
  * mei_wd_host_init - connect to the watchdog client
  *
  * @dev: the device structure
+ *
  * returns -ENENT if wd client cannot be found
  *         -EIO if write has failed
  *         0 on success
-- 
1.8.2.279.g631bc94

