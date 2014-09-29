Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbaI2Ndb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:33:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:32065 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595AbaI2NdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:33:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393030154"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [RESEND char-misc-next 18/18] mei: fix kernel-doc warnings
Date: Mon, 29 Sep 2014 16:31:50 +0300
Message-Id: <1411997510-29094-19-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
References: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Add missed parameters descriptions and return values descriptions

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    |   5 +-
 drivers/misc/mei/client.c    |   6 ++
 drivers/misc/mei/debugfs.c   |   2 +
 drivers/misc/mei/hbm.c       |   2 +
 drivers/misc/mei/hw-me.c     |  41 ++++++++++--
 drivers/misc/mei/hw-me.h     |   6 ++
 drivers/misc/mei/hw-txe.c    |  63 ++++++++++++------
 drivers/misc/mei/hw-txe.h    |   1 +
 drivers/misc/mei/hw.h        |   2 +
 drivers/misc/mei/init.c      |   4 +-
 drivers/misc/mei/interrupt.c |   4 +-
 drivers/misc/mei/mei_dev.h   | 151 +++++++++++++++++++++++++++++++++----------
 drivers/misc/mei/nfc.c       |   5 ++
 drivers/misc/mei/pci-me.c    |   6 +-
 14 files changed, 231 insertions(+), 67 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 29b3fd0..6cdce84 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -64,6 +64,7 @@ void mei_amthif_reset_params(struct mei_device *dev)
  *
  * @dev: the device structure
  *
+ * Return: 0 on success, <0 on failure.
  */
 int mei_amthif_host_init(struct mei_device *dev)
 {
@@ -352,7 +353,7 @@ int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *cb)
 	return mei_amthif_send_cmd(dev, cb);
 }
 /**
- * mei_amthif_run_next_cmd
+ * mei_amthif_run_next_cmd - send next amt command from queue
  *
  * @dev: the device structure
  */
@@ -496,7 +497,7 @@ int mei_amthif_irq_write(struct mei_cl *cl, struct mei_cl_cb *cb,
 }
 
 /**
- * mei_amthif_irq_read_message - read routine after ISR to
+ * mei_amthif_irq_read_msg - read routine after ISR to
  *			handle the read amthif message
  *
  * @dev: the device structure
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 1f91c55..bc9ba53 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -271,6 +271,8 @@ int mei_io_cb_alloc_resp_buf(struct mei_cl_cb *cb, size_t length)
  * mei_cl_flush_queues - flushes queue lists belonging to cl.
  *
  * @cl: host client
+ *
+ * Return: 0 on success, -EINVAL if cl or cl->dev is NULL.
  */
 int mei_cl_flush_queues(struct mei_cl *cl)
 {
@@ -402,6 +404,8 @@ int mei_cl_link(struct mei_cl *cl, int id)
  * mei_cl_unlink - remove me_cl from the list
  *
  * @cl: host client
+ *
+ * Return: always 0
  */
 int mei_cl_unlink(struct mei_cl *cl)
 {
@@ -756,6 +760,7 @@ int mei_cl_flow_ctrl_reduce(struct mei_cl *cl)
  * mei_cl_read_start - the start read client message function.
  *
  * @cl: host client
+ * @length: number of bytes to read
  *
  * Return: 0 on success, <0 on failure.
  */
@@ -916,6 +921,7 @@ int mei_cl_irq_write(struct mei_cl *cl, struct mei_cl_cb *cb,
  *
  * @cl: host client
  * @cb: write callback with filled data
+ * @blocking: block until completed
  *
  * Return: number of bytes sent on success, <0 on failure.
  */
diff --git a/drivers/misc/mei/debugfs.c b/drivers/misc/mei/debugfs.c
index 357b02c..ce15667 100644
--- a/drivers/misc/mei/debugfs.c
+++ b/drivers/misc/mei/debugfs.c
@@ -177,6 +177,8 @@ void mei_dbgfs_deregister(struct mei_device *dev)
  *
  * @dev: the mei device structure
  * @name: the mei device name
+ *
+ * Return: 0 on success, <0 on failure.
  */
 int mei_dbgfs_register(struct mei_device *dev, const char *name)
 {
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index da476e8..49a2653 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -176,6 +176,8 @@ void mei_hbm_cl_hdr(struct mei_cl *cl, u8 hbm_cmd, void *buf, size_t len)
  * @cl: client
  * @hbm_cmd: host bus message command
  * @len: buffer length
+ *
+ * Return: 0 on success, <0 on failure.
  */
 static inline
 int mei_hbm_cl_write(struct mei_device *dev,
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 9dd7aa7..4f2fd6f 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -94,6 +94,7 @@ static inline u32 mei_hcsr_read(const struct mei_me_hw *hw)
  * and ignores the H_IS bit for it is write-one-to-zero.
  *
  * @hw: the me hardware structure
+ * @hcsr: new register value
  */
 static inline void mei_hcsr_set(struct mei_me_hw *hw, u32 hcsr)
 {
@@ -106,6 +107,8 @@ static inline void mei_hcsr_set(struct mei_me_hw *hw, u32 hcsr)
  *
  * @dev: mei device
  * @fw_status: fw status register values
+ *
+ * Return: 0 on success, error otherwise
  */
 static int mei_me_fw_status(struct mei_device *dev,
 			    struct mei_fw_status *fw_status)
@@ -149,8 +152,9 @@ static void mei_me_hw_config(struct mei_device *dev)
  * mei_me_pg_state  - translate internal pg state
  *   to the mei power gating state
  *
- * @hw -  me hardware
- * returns: MEI_PG_OFF if aliveness is on and MEI_PG_ON otherwise
+ * @dev:  mei device
+ *
+ * Return: MEI_PG_OFF if aliveness is on and MEI_PG_ON otherwise
  */
 static inline enum mei_pg_state mei_me_pg_state(struct mei_device *dev)
 {
@@ -160,7 +164,7 @@ static inline enum mei_pg_state mei_me_pg_state(struct mei_device *dev)
 }
 
 /**
- * mei_clear_interrupts - clear and stop interrupts
+ * mei_me_intr_clear - clear and stop interrupts
  *
  * @dev: the device structure
  */
@@ -187,7 +191,7 @@ static void mei_me_intr_enable(struct mei_device *dev)
 }
 
 /**
- * mei_disable_interrupts - disables mei device interrupts
+ * mei_me_intr_disable - disables mei device interrupts
  *
  * @dev: the device structure
  */
@@ -222,6 +226,8 @@ static void mei_me_hw_reset_release(struct mei_device *dev)
  *
  * @dev: the device structure
  * @intr_enable: if interrupt should be enabled after reset.
+ *
+ * Return: always 0
  */
 static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 {
@@ -259,10 +265,8 @@ static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 /**
  * mei_me_host_set_ready - enable device
  *
- * @dev - mei device
- * returns bool
+ * @dev: mei device
  */
-
 static void mei_me_host_set_ready(struct mei_device *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
@@ -271,6 +275,7 @@ static void mei_me_host_set_ready(struct mei_device *dev)
 	hw->host_hw_state |= H_IE | H_IG | H_RDY;
 	mei_hcsr_set(hw, hw->host_hw_state);
 }
+
 /**
  * mei_me_host_is_ready - check whether the host has turned ready
  *
@@ -299,6 +304,13 @@ static bool mei_me_hw_is_ready(struct mei_device *dev)
 	return (hw->me_hw_state & ME_RDY_HRA) == ME_RDY_HRA;
 }
 
+/**
+ * mei_me_hw_ready_wait - wait until the me(hw) has turned ready
+ *  or timeout is reached
+ *
+ * @dev: mei device
+ * Return: 0 on success, error otherwise
+ */
 static int mei_me_hw_ready_wait(struct mei_device *dev)
 {
 	mutex_unlock(&dev->device_lock);
@@ -315,6 +327,12 @@ static int mei_me_hw_ready_wait(struct mei_device *dev)
 	return 0;
 }
 
+/**
+ * mei_me_hw_start - hw start routine
+ *
+ * @dev: mei device
+ * Return: 0 on success, error otherwise
+ */
 static int mei_me_hw_start(struct mei_device *dev)
 {
 	int ret = mei_me_hw_ready_wait(dev);
@@ -381,6 +399,13 @@ static int mei_me_hbuf_empty_slots(struct mei_device *dev)
 	return empty_slots;
 }
 
+/**
+ * mei_me_hbuf_max_len - returns size of hw buffer.
+ *
+ * @dev: the device structure
+ *
+ * Return: size of hw buffer in bytes
+ */
 static size_t mei_me_hbuf_max_len(const struct mei_device *dev)
 {
 	return dev->hbuf_depth * sizeof(u32) - sizeof(struct mei_msg_hdr);
@@ -472,6 +497,8 @@ static int mei_me_count_full_read_slots(struct mei_device *dev)
  * @dev: the device structure
  * @buffer: message buffer will be written
  * @buffer_length: message size will be read
+ *
+ * Return: always 0
  */
 static int mei_me_read_slots(struct mei_device *dev, unsigned char *buffer,
 		    unsigned long buffer_length)
diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
index b0001b3..e6a59a6 100644
--- a/drivers/misc/mei/hw-me.h
+++ b/drivers/misc/mei/hw-me.h
@@ -47,7 +47,13 @@ struct mei_cfg {
 #define MEI_ME_RPM_TIMEOUT    500 /* ms */
 
 /**
+ * struct mei_me_hw - me hw specific data
+ *
  * @cfg: per device generation config and ops
+ * @mem_addr:  io memory address
+ * @host_hw_state: cached host state
+ * @me_hw_state:   cached me (fw) state
+ * @pg_state:      power gating state
  */
 struct mei_me_hw {
 	const struct mei_cfg *cfg;
diff --git a/drivers/misc/mei/hw-txe.c b/drivers/misc/mei/hw-txe.c
index 0a15522..d3cf042 100644
--- a/drivers/misc/mei/hw-txe.c
+++ b/drivers/misc/mei/hw-txe.c
@@ -28,11 +28,12 @@
 #include "hbm.h"
 
 /**
- * mei_txe_reg_read - Reads 32bit data from the device
+ * mei_txe_reg_read - Reads 32bit data from the txe device
  *
  * @base_addr: registers base address
  * @offset: register offset
  *
+ * Return: register value
  */
 static inline u32 mei_txe_reg_read(void __iomem *base_addr,
 					unsigned long offset)
@@ -41,7 +42,7 @@ static inline u32 mei_txe_reg_read(void __iomem *base_addr,
 }
 
 /**
- * mei_txe_reg_write - Writes 32bit data to the device
+ * mei_txe_reg_write - Writes 32bit data to the txe device
  *
  * @base_addr: registers base address
  * @offset: register offset
@@ -56,10 +57,12 @@ static inline void mei_txe_reg_write(void __iomem *base_addr,
 /**
  * mei_txe_sec_reg_read_silent - Reads 32bit data from the SeC BAR
  *
- * @dev: the device structure
+ * @hw: the txe hardware structure
  * @offset: register offset
  *
  * Doesn't check for aliveness while Reads 32bit data from the SeC BAR
+ *
+ * Return: register value
  */
 static inline u32 mei_txe_sec_reg_read_silent(struct mei_txe_hw *hw,
 				unsigned long offset)
@@ -70,10 +73,12 @@ static inline u32 mei_txe_sec_reg_read_silent(struct mei_txe_hw *hw,
 /**
  * mei_txe_sec_reg_read - Reads 32bit data from the SeC BAR
  *
- * @dev: the device structure
+ * @hw: the txe hardware structure
  * @offset: register offset
  *
  * Reads 32bit data from the SeC BAR and shout loud if aliveness is not set
+ *
+ * Return: register value
  */
 static inline u32 mei_txe_sec_reg_read(struct mei_txe_hw *hw,
 				unsigned long offset)
@@ -115,9 +120,10 @@ static inline void mei_txe_sec_reg_write(struct mei_txe_hw *hw,
 /**
  * mei_txe_br_reg_read - Reads 32bit data from the Bridge BAR
  *
- * @hw: the device structure
+ * @hw: the txe hardware structure
  * @offset: offset from which to read the data
  *
+ * Return: the byte read.
  */
 static inline u32 mei_txe_br_reg_read(struct mei_txe_hw *hw,
 				unsigned long offset)
@@ -147,7 +153,10 @@ static inline void mei_txe_br_reg_write(struct mei_txe_hw *hw,
  * Request for aliveness change and returns true if the change is
  *   really needed and false if aliveness is already
  *   in the requested state
- * Requires device lock to be held
+ *
+ * Locking: called under "dev->device_lock" lock
+ *
+ * Return: true if request was send
  */
 static bool mei_txe_aliveness_set(struct mei_device *dev, u32 req)
 {
@@ -172,6 +181,8 @@ static bool mei_txe_aliveness_set(struct mei_device *dev, u32 req)
  *
  * Extract HICR_HOST_ALIVENESS_RESP_ACK bit from
  * from HICR_HOST_ALIVENESS_REQ register value
+ *
+ * Return: SICR_HOST_ALIVENESS_REQ_REQUESTED bit value
  */
 static u32 mei_txe_aliveness_req_get(struct mei_device *dev)
 {
@@ -184,10 +195,11 @@ static u32 mei_txe_aliveness_req_get(struct mei_device *dev)
 
 /**
  * mei_txe_aliveness_get - get aliveness response register value
+ *
  * @dev: the device structure
  *
- * Extract HICR_HOST_ALIVENESS_RESP_ACK bit
- * from HICR_HOST_ALIVENESS_RESP register value
+ * Return: HICR_HOST_ALIVENESS_RESP_ACK bit from HICR_HOST_ALIVENESS_RESP
+ *         register
  */
 static u32 mei_txe_aliveness_get(struct mei_device *dev)
 {
@@ -278,6 +290,7 @@ static int mei_txe_aliveness_wait(struct mei_device *dev, u32 expected)
  * mei_txe_aliveness_set_sync - sets an wait for aliveness to complete
  *
  * @dev: the device structure
+ * @req: requested aliveness value
  *
  * Return: 0 on success and < 0 otherwise
  */
@@ -359,6 +372,8 @@ static void mei_txe_output_ready_set(struct mei_txe_hw *hw)
  * mei_txe_is_input_ready - check if TXE is ready for receiving data
  *
  * @dev: the device structure
+ *
+ * Return: true if INPUT STATUS READY bit is set
  */
 static bool mei_txe_is_input_ready(struct mei_device *dev)
 {
@@ -417,6 +432,8 @@ static void mei_txe_intr_enable(struct mei_device *dev)
  *
  * Checks if there are pending interrupts
  * only Aliveness, Readiness, Input ready, and Output doorbell are relevant
+ *
+ * Return: true if there are pending interrupts
  */
 static bool mei_txe_pending_interrupts(struct mei_device *dev)
 {
@@ -476,7 +493,7 @@ static u32 mei_txe_out_data_read(const struct mei_device *dev,
 /* Readiness */
 
 /**
- * mei_txe_readiness_set_host_rdy
+ * mei_txe_readiness_set_host_rdy - set host readiness bit
  *
  * @dev: the device structure
  */
@@ -490,7 +507,7 @@ static void mei_txe_readiness_set_host_rdy(struct mei_device *dev)
 }
 
 /**
- * mei_txe_readiness_clear
+ * mei_txe_readiness_clear - clear host readiness bit
  *
  * @dev: the device structure
  */
@@ -521,7 +538,9 @@ static u32 mei_txe_readiness_get(struct mei_device *dev)
  * mei_txe_readiness_is_sec_rdy - check readiness
  *  for HICR_SEC_IPC_READINESS_SEC_RDY
  *
- * @readiness - cached readiness state
+ * @readiness: cached readiness state
+ *
+ * Return: true if readiness bit is set
  */
 static inline bool mei_txe_readiness_is_sec_rdy(u32 readiness)
 {
@@ -532,6 +551,8 @@ static inline bool mei_txe_readiness_is_sec_rdy(u32 readiness)
  * mei_txe_hw_is_ready - check if the hw is ready
  *
  * @dev: the device structure
+ *
+ * Return: true if sec is ready
  */
 static bool mei_txe_hw_is_ready(struct mei_device *dev)
 {
@@ -544,6 +565,8 @@ static bool mei_txe_hw_is_ready(struct mei_device *dev)
  * mei_txe_host_is_ready - check if the host is ready
  *
  * @dev: the device structure
+ *
+ * Return: true if host is ready
  */
 static inline bool mei_txe_host_is_ready(struct mei_device *dev)
 {
@@ -589,6 +612,8 @@ const struct mei_fw_status mei_txe_fw_sts = {
  *
  * @dev: mei device
  * @fw_status: fw status register values
+ *
+ * Return: 0 on success, error otherwise
  */
 static int mei_txe_fw_status(struct mei_device *dev,
 			     struct mei_fw_status *fw_status)
@@ -643,7 +668,7 @@ static void mei_txe_hw_config(struct mei_device *dev)
  * @header: header of message
  * @buf: message buffer will be written
  *
- * Return: if success, 0 - otherwise.
+ * Return: 0 if success, <0 - otherwise.
  */
 
 static int mei_txe_write(struct mei_device *dev,
@@ -710,7 +735,7 @@ static int mei_txe_write(struct mei_device *dev,
  *
  * @dev: the device structure
  *
- * Return: PAYLOAD_SIZE - 4
+ * Return: the PAYLOAD_SIZE - 4
  */
 static size_t mei_txe_hbuf_max_len(const struct mei_device *dev)
 {
@@ -859,7 +884,7 @@ static int mei_txe_hw_reset(struct mei_device *dev, bool intr_enable)
  *
  * @dev: the device structure
  *
- * Return: 0 on success and < 0 in case of error
+ * Return: 0 on success an error code otherwise
  */
 static int mei_txe_hw_start(struct mei_device *dev)
 {
@@ -915,6 +940,8 @@ static int mei_txe_hw_start(struct mei_device *dev)
  *
  * @dev: the device structure
  * @do_ack: acknowledge interrupts
+ *
+ * Return: true if found interrupts to process.
  */
 static bool mei_txe_check_and_ack_intrs(struct mei_device *dev, bool do_ack)
 {
@@ -990,7 +1017,6 @@ irqreturn_t mei_txe_irq_quick_handler(int irq, void *dev_id)
  * @dev_id: pointer to the device structure
  *
  * Return: IRQ_HANDLED
- *
  */
 irqreturn_t mei_txe_irq_thread_handler(int irq, void *dev_id)
 {
@@ -1135,10 +1161,9 @@ static const struct mei_hw_ops mei_txe_hw_ops = {
 /**
  * mei_txe_dev_init - allocates and initializes txe hardware specific structure
  *
- * @pdev - pci device
- *
- * Return: struct mei_device * on success or NULL;
+ * @pdev: pci device
  *
+ * Return: struct mei_device * on success or NULL
  */
 struct mei_device *mei_txe_dev_init(struct pci_dev *pdev)
 {
@@ -1165,6 +1190,8 @@ struct mei_device *mei_txe_dev_init(struct pci_dev *pdev)
  * @dev:   the device structure
  * @addr:  physical address start of the range
  * @range: physical range size
+ *
+ * Return: 0 on success an error code otherwise
  */
 int mei_txe_setup_satt2(struct mei_device *dev, phys_addr_t addr, u32 range)
 {
diff --git a/drivers/misc/mei/hw-txe.h b/drivers/misc/mei/hw-txe.h
index e8dd2d1..ce3ed0b 100644
--- a/drivers/misc/mei/hw-txe.h
+++ b/drivers/misc/mei/hw-txe.h
@@ -40,6 +40,7 @@
  * @mem_addr:            SeC and BRIDGE bars
  * @aliveness:           aliveness (power gating) state of the hardware
  * @readiness:           readiness state of the hardware
+ * @slots:               number of empty slots
  * @wait_aliveness_resp: aliveness wait queue
  * @intr_cause:          translated interrupt cause
  */
diff --git a/drivers/misc/mei/hw.h b/drivers/misc/mei/hw.h
index ea8de2a..16fef6d 100644
--- a/drivers/misc/mei/hw.h
+++ b/drivers/misc/mei/hw.h
@@ -109,6 +109,8 @@ enum mei_stop_reason_types {
  * @MEI_HBMS_NOT_ALLOWED       : operation not allowed
  * @MEI_HBMS_ALREADY_STARTED   : system is already started
  * @MEI_HBMS_NOT_STARTED       : system not started
+ *
+ * @MEI_HBMS_MAX               : sentinel
  */
 enum mei_hbm_status {
 	MEI_HBMS_SUCCESS           = 0,
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 52d7f42..7901d07 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -59,8 +59,6 @@ const char *mei_pg_state_str(enum mei_pg_state state)
  * mei_cancel_work - Cancel mei background jobs
  *
  * @dev: the device structure
- *
- * Return: 0 on success or < 0 if the reset hasn't succeeded
  */
 void mei_cancel_work(struct mei_device *dev)
 {
@@ -75,6 +73,8 @@ EXPORT_SYMBOL_GPL(mei_cancel_work);
  * mei_reset - resets host and fw.
  *
  * @dev: the device structure
+ *
+ * Return: 0 on success or < 0 if the reset hasn't succeeded
  */
 int mei_reset(struct mei_device *dev)
 {
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index d8aa1d3..20c6c51 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -87,7 +87,7 @@ static bool mei_cl_is_reading(struct mei_cl *cl, struct mei_msg_hdr *mei_hdr)
 }
 
 /**
- * mei_irq_read_client_message - process client message
+ * mei_cl_irq_read_msg - process client message
  *
  * @dev: the device structure
  * @mei_hdr: header of mei client message
@@ -234,7 +234,7 @@ static int mei_cl_irq_disconnect(struct mei_cl *cl, struct mei_cl_cb *cb,
 
 
 /**
- * mei_cl_irq_close - processes client read related operation from the
+ * mei_cl_irq_read - processes client read related operation from the
  *	interrupt thread context - request for flow control credits
  *
  * @cl: client
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 563eebb..71744b1 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -129,11 +129,11 @@ enum mei_wd_states {
 
 /**
  * enum mei_cb_file_ops  - file operation associated with the callback
- * @MEI_FOP_READ      - read
- * @MEI_FOP_WRITE     - write
- * @MEI_FOP_CONNECT   - connect
- * @MEI_FOP_DISCONNECT - disconnect
- * @MEI_FOP_DISCONNECT_RSP - disconnect response
+ * @MEI_FOP_READ:       read
+ * @MEI_FOP_WRITE:      write
+ * @MEI_FOP_CONNECT:    connect
+ * @MEI_FOP_DISCONNECT: disconnect
+ * @MEI_FOP_DISCONNECT_RSP: disconnect response
  */
 enum mei_cb_file_ops {
 	MEI_FOP_READ = 0,
@@ -189,6 +189,12 @@ struct mei_cl;
  * @list: link in callback queue
  * @cl: file client who is running this operation
  * @fop_type: file operation type
+ * @request_buffer: buffer to store request data
+ * @response_buffer: buffer to store response data
+ * @buf_idx: last read index
+ * @read_time: last read operation time stamp (iamthif)
+ * @file_object: pointer to file structure
+ * @internal: communication between driver and FW flag
  */
 struct mei_cl_cb {
 	struct list_head list;
@@ -202,7 +208,29 @@ struct mei_cl_cb {
 	u32 internal:1;
 };
 
-/* MEI client instance carried as file->private_data*/
+/**
+ * struct mei_cl - me client host representation
+ *    carried in file->private_data
+ *
+ * @link: link in the clients list
+ * @dev: mei parent device
+ * @state: file operation state
+ * @tx_wait: wait queue for tx completion
+ * @rx_wait: wait queue for rx completion
+ * @wait:  wait queue for management operation
+ * @status: connection status
+ * @cl_uuid: client uuid name
+ * @host_client_id: host id
+ * @me_client_id: me/fw id
+ * @mei_flow_ctrl_creds: transmit flow credentials
+ * @timer_count:  watchdog timer for operation completion
+ * @reading_state: state of the rx
+ * @writing_state: state of the tx
+ * @read_cb: current pending reading callback
+ *
+ * @device: device on the mei client bus
+ * @device_link:  link to bus clients
+ */
 struct mei_cl {
 	struct list_head link;
 	struct mei_device *dev;
@@ -211,7 +239,6 @@ struct mei_cl {
 	wait_queue_head_t rx_wait;
 	wait_queue_head_t wait;
 	int status;
-	/* ID of client connected */
 	uuid_le cl_uuid;
 	u8 host_client_id;
 	u8 me_client_id;
@@ -334,8 +361,10 @@ void mei_cl_bus_exit(void);
  * @dev: linux driver model device pointer
  * @cl: mei client
  * @ops: ME transport ops
+ * @event_work: async work to execute event callback
  * @event_cb: Drivers register this callback to get asynchronous ME
  *	events (e.g. Rx buffer pending) notifications.
+ * @event_context: event callback run context
  * @events: Events bitmask sent to the driver.
  * @priv_data: client private data
  */
@@ -355,7 +384,7 @@ struct mei_cl_device {
 };
 
 
- /**
+/**
  * enum mei_pg_event - power gating transition events
  *
  * @MEI_PG_EVENT_IDLE: the driver is not in power gating transition
@@ -383,49 +412,102 @@ const char *mei_pg_state_str(enum mei_pg_state state);
 
 /**
  * struct mei_device -  MEI private device struct
-
+ *
  * @dev         : device on a bus
  * @cdev        : character device
  * @minor       : minor number allocated for device
  *
- * @reset_count : limits the number of consecutive resets
- * @hbm_state   : state of host bus message protocol
+ * @read_list   : read completion list
+ * @write_list  : write pending list
+ * @write_waiting_list : write completion list
+ * @ctrl_wr_list : pending control write list
+ * @ctrl_rd_list : pending control read list
  *
- * @hbm_f_pg_supported : hbm feature pgi protocol
+ * @file_list   : list of opened handles
+ * @open_handle_count: number of opened handles
+ *
+ * @device_lock : big device lock
+ * @timer_work  : MEI timer delayed work (timeouts)
+ *
+ * @recvd_hw_ready : hw ready message received flag
+ *
+ * @wait_hw_ready : wait queue for receive HW ready message form FW
+ * @wait_pg     : wait queue for receive PG message from FW
+ * @wait_hbm_start : wait queue for receive HBM start message from FW
+ * @wait_stop_wd : wait queue for receive WD stop message from FW
+ *
+ * @reset_count : number of consecutive resets
+ * @dev_state   : device state
+ * @hbm_state   : state of host bus message protocol
+ * @init_clients_timer : HBM init handshake timeout
  *
  * @pg_event    : power gating event
- * @mem_addr    : mem mapped base register address
-
+ * @pg_domain   : runtime PM domain
+ *
+ * @rd_msg_buf  : control messages buffer
+ * @rd_msg_hdr  : read message header storage
+ *
  * @hbuf_depth  : depth of hardware host/write buffer is slots
  * @hbuf_is_ready : query if the host host/write buffer is ready
  * @wr_msg      : the buffer for hbm control messages
+ *
+ * @version     : HBM protocol version in use
+ * @hbm_f_pg_supported : hbm feature pgi protocol
+ *
+ * @me_clients  : list of FW clients
+ * @me_clients_map : FW clients bit map
+ * @host_clients_map : host clients id pool
+ * @me_client_index : last FW client index in enumeration
+ *
+ * @wd_cl       : watchdog client
+ * @wd_state    : watchdog client state
+ * @wd_pending  : watchdog command is pending
+ * @wd_timeout  : watchdog expiration timeout
+ * @wd_data     : watchdog message buffer
+ *
+ * @amthif_cmd_list : amthif list for cmd waiting
+ * @amthif_rd_complete_list : amthif list for reading completed cmd data
+ * @iamthif_file_object : file for current amthif operation
+ * @iamthif_cl  : amthif host client
+ * @iamthif_current_cb : amthif current operation callback
+ * @iamthif_open_count : number of opened amthif connections
+ * @iamthif_mtu : amthif client max message length
+ * @iamthif_timer : time stamp of current amthif command completion
+ * @iamthif_stall_timer : timer to detect amthif hang
+ * @iamthif_msg_buf : amthif current message buffer
+ * @iamthif_msg_buf_size : size of current amthif message request buffer
+ * @iamthif_msg_buf_index : current index in amthif message request buffer
+ * @iamthif_state : amthif processor state
+ * @iamthif_flow_control_pending: amthif waits for flow control
+ * @iamthif_ioctl : wait for completion if amthif control message
+ * @iamthif_canceled : current amthif command is canceled
+ *
+ * @init_work   : work item for the device init
+ * @reset_work  : work item for the device reset
+ *
+ * @device_list : mei client bus list
+ *
+ * @dbgfs_dir   : debugfs mei root directory
+ *
+ * @ops:        : hw specific operations
+ * @hw          : hw specific data
  */
 struct mei_device {
 	struct device *dev;
 	struct cdev cdev;
 	int minor;
 
-	/*
-	 * lists of queues
-	 */
-	/* array of pointers to aio lists */
-	struct mei_cl_cb read_list;		/* driver read queue */
-	struct mei_cl_cb write_list;		/* driver write queue */
-	struct mei_cl_cb write_waiting_list;	/* write waiting queue */
-	struct mei_cl_cb ctrl_wr_list;		/* managed write IOCTL list */
-	struct mei_cl_cb ctrl_rd_list;		/* managed read IOCTL list */
+	struct mei_cl_cb read_list;
+	struct mei_cl_cb write_list;
+	struct mei_cl_cb write_waiting_list;
+	struct mei_cl_cb ctrl_wr_list;
+	struct mei_cl_cb ctrl_rd_list;
 
-	/*
-	 * list of files
-	 */
 	struct list_head file_list;
 	long open_handle_count;
 
-	/*
-	 * lock for the device
-	 */
-	struct mutex device_lock; /* device lock */
-	struct delayed_work timer_work;	/* MEI timer delayed work (timeouts) */
+	struct mutex device_lock;
+	struct delayed_work timer_work;
 
 	bool recvd_hw_ready;
 	/*
@@ -452,7 +534,7 @@ struct mei_device {
 	struct dev_pm_domain pg_domain;
 #endif /* CONFIG_PM_RUNTIME */
 
-	unsigned char rd_msg_buf[MEI_RD_MSG_BUF_SIZE];	/* control messages */
+	unsigned char rd_msg_buf[MEI_RD_MSG_BUF_SIZE];
 	u32 rd_msg_hdr;
 
 	/* write buffer */
@@ -522,6 +604,7 @@ static inline unsigned long mei_secs_to_jiffies(unsigned long sec)
 /**
  * mei_data2slots - get slots - number of (dwords) from a message length
  *	+ size of the mei header
+ *
  * @length: size of the messages in bytes
  *
  * Return: number of slots
@@ -532,8 +615,10 @@ static inline u32 mei_data2slots(size_t length)
 }
 
 /**
- * mei_slots2data- get data in slots - bytes from slots
+ * mei_slots2data - get data in slots - bytes from slots
+ *
  * @slots: number of available slots
+ *
  * Return: number of bytes in slots
  */
 static inline u32 mei_slots2data(int slots)
diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 288665e..6226543 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -94,9 +94,14 @@ struct mei_nfc_hci_hdr {
  * @cl: NFC host client
  * @cl_info: NFC info host client
  * @init_work: perform connection to the info client
+ * @send_wq: send completion wait queue
  * @fw_ivn: NFC Interface Version Number
  * @vendor_id: NFC manufacturer ID
  * @radio_type: NFC radio type
+ * @bus_name: bus name
+ *
+ * @req_id:  message counter
+ * @recv_req_id: reception message counter
  */
 struct mei_nfc_dev {
 	struct mei_cl *cl;
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 532d393..badd4d8 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -98,7 +98,7 @@ static inline void mei_me_unset_pm_domain(struct mei_device *dev) {}
 #endif /* CONFIG_PM_RUNTIME */
 
 /**
- * mei_quirk_probe - probe for devices that doesn't valid ME interface
+ * mei_me_quirk_probe - probe for devices that doesn't valid ME interface
  *
  * @pdev: PCI device structure
  * @cfg: per generation config
@@ -117,7 +117,7 @@ static bool mei_me_quirk_probe(struct pci_dev *pdev,
 }
 
 /**
- * mei_probe - Device Initialization Routine
+ * mei_me_probe - Device Initialization Routine
  *
  * @pdev: PCI device structure
  * @ent: entry in kcs_pci_tbl
@@ -249,7 +249,7 @@ end:
 }
 
 /**
- * mei_remove - Device Removal Routine
+ * mei_me_remove - Device Removal Routine
  *
  * @pdev: PCI device structure
  *
-- 
1.9.3

