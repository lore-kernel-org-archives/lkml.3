Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbaDHAzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 20:55:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:3720 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbaDHAzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 20:55:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,814,1389772800"; 
   d="scan'208";a="516267389"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] NTB: Code Style Clean-up
Date: Mon,  7 Apr 2014 17:52:51 -0700
Message-Id: <1396918374-5196-7-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396918374-5196-1-git-send-email-jon.mason@intel.com>
References: <1396918374-5196-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some white space and 80 char overruns corrected.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/net/ntb_netdev.c    |  2 +-
 drivers/ntb/ntb_hw.c        | 19 ++++++++++---------
 drivers/ntb/ntb_hw.h        |  2 +-
 drivers/ntb/ntb_transport.c | 19 +++++++++----------
 include/linux/ntb.h         | 14 +++++++-------
 5 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index 14570b2..63aa9d9 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -377,7 +377,7 @@ static void ntb_netdev_remove(struct pci_dev *pdev)
 {
 	struct net_device *ndev;
 	struct ntb_netdev *dev;
-	bool found  = false;
+	bool found = false;
 
 	list_for_each_entry(dev, &dev_list, list) {
 		if (dev->pdev == pdev) {
diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 0e8ae70..eba1ed5 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -91,7 +91,7 @@ static struct dentry *debugfs_dir;
 /* Translate memory window 0,1 to BAR 2,4 */
 #define MW_TO_BAR(mw)	(mw * NTB_MAX_NUM_MW + 2)
 
-static DEFINE_PCI_DEVICE_TABLE(ntb_pci_tbl) = {
+static const struct pci_device_id ntb_pci_tbl[] = {
 	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_B2B_BWD)},
 	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_B2B_JSF)},
 	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_B2B_SNB)},
@@ -120,7 +120,8 @@ MODULE_DEVICE_TABLE(pci, ntb_pci_tbl);
  * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
  */
 int ntb_register_event_callback(struct ntb_device *ndev,
-			    void (*func)(void *handle, enum ntb_hw_event event))
+				void (*func)(void *handle,
+					     enum ntb_hw_event event))
 {
 	if (ndev->event_cb)
 		return -EINVAL;
@@ -715,9 +716,9 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 			       SNB_PBAR4LMT_OFFSET);
 			/* HW errata on the Limit registers.  They can only be
 			 * written when the base register is 4GB aligned and
-			 * < 32bit.  This should already be the case based on the
-			 * driver defaults, but write the Limit registers first
-			 * just in case.
+			 * < 32bit.  This should already be the case based on
+			 * the driver defaults, but write the Limit registers
+			 * first just in case.
 			 */
 		} else {
 			ndev->limits.max_mw = SNB_MAX_MW;
@@ -739,9 +740,9 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 			writeq(0, ndev->reg_base + SNB_PBAR4LMT_OFFSET);
 			/* HW errata on the Limit registers.  They can only be
 			 * written when the base register is 4GB aligned and
-			 * < 32bit.  This should already be the case based on the
-			 * driver defaults, but write the Limit registers first
-			 * just in case.
+			 * < 32bit.  This should already be the case based on
+			 * the driver defaults, but write the Limit registers
+			 * first just in case.
 			 */
 		}
 
@@ -803,7 +804,7 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 		ndev->conn_type = NTB_CONN_RP;
 
 		if (xeon_errata_workaround) {
-			dev_err(&ndev->pdev->dev, 
+			dev_err(&ndev->pdev->dev,
 				"NTB-RP disabled due to hardware errata.  To disregard this warning and potentially lock-up the system, add the parameter 'xeon_errata_workaround=0'.\n");
 			return -EINVAL;
 		}
diff --git a/drivers/ntb/ntb_hw.h b/drivers/ntb/ntb_hw.h
index d1960ff..923a0fb 100644
--- a/drivers/ntb/ntb_hw.h
+++ b/drivers/ntb/ntb_hw.h
@@ -231,7 +231,7 @@ int ntb_register_db_callback(struct ntb_device *ndev, unsigned int idx,
 							   int db_num));
 void ntb_unregister_db_callback(struct ntb_device *ndev, unsigned int idx);
 int ntb_register_event_callback(struct ntb_device *ndev,
-				void (*event_cb_func) (void *handle,
+				void (*event_cb_func)(void *handle,
 						      enum ntb_hw_event event));
 void ntb_unregister_event_callback(struct ntb_device *ndev);
 int ntb_get_max_spads(struct ntb_device *ndev);
diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 042fb3d..9dd63b8 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -106,8 +106,8 @@ struct ntb_transport_qp {
 	struct ntb_rx_info __iomem *rx_info;
 	struct ntb_rx_info *remote_rx_info;
 
-	void (*tx_handler) (struct ntb_transport_qp *qp, void *qp_data,
-			    void *data, int len);
+	void (*tx_handler)(struct ntb_transport_qp *qp, void *qp_data,
+			   void *data, int len);
 	struct list_head tx_free_q;
 	spinlock_t ntb_tx_free_q_lock;
 	void __iomem *tx_mw;
@@ -116,8 +116,8 @@ struct ntb_transport_qp {
 	unsigned int tx_max_entry;
 	unsigned int tx_max_frame;
 
-	void (*rx_handler) (struct ntb_transport_qp *qp, void *qp_data,
-			    void *data, int len);
+	void (*rx_handler)(struct ntb_transport_qp *qp, void *qp_data,
+			   void *data, int len);
 	struct list_head rx_pend_q;
 	struct list_head rx_free_q;
 	spinlock_t ntb_rx_pend_q_lock;
@@ -128,7 +128,7 @@ struct ntb_transport_qp {
 	unsigned int rx_max_frame;
 	dma_cookie_t last_cookie;
 
-	void (*event_handler) (void *data, int status);
+	void (*event_handler)(void *data, int status);
 	struct delayed_work link_work;
 	struct work_struct link_cleanup;
 
@@ -479,7 +479,7 @@ static void ntb_list_add(spinlock_t *lock, struct list_head *entry,
 }
 
 static struct ntb_queue_entry *ntb_list_rm(spinlock_t *lock,
-						struct list_head *list)
+					   struct list_head *list)
 {
 	struct ntb_queue_entry *entry;
 	unsigned long flags;
@@ -838,7 +838,7 @@ static void ntb_qp_link_work(struct work_struct *work)
 }
 
 static int ntb_transport_init_queue(struct ntb_transport *nt,
-				     unsigned int qp_num)
+				    unsigned int qp_num)
 {
 	struct ntb_transport_qp *qp;
 	unsigned int num_qps_mw, tx_size;
@@ -1054,7 +1054,7 @@ static void ntb_async_rx(struct ntb_queue_entry *entry, void *offset,
 	if (!chan)
 		goto err;
 
-	if (len < copy_bytes) 
+	if (len < copy_bytes)
 		goto err_wait;
 
 	device = chan->device;
@@ -1189,8 +1189,7 @@ out:
 	return 0;
 
 err:
-	ntb_list_add(&qp->ntb_rx_pend_q_lock, &entry->entry,
-		     &qp->rx_pend_q);
+	ntb_list_add(&qp->ntb_rx_pend_q_lock, &entry->entry, &qp->rx_pend_q);
 	/* Ensure that the data is fully copied out before clearing the flag */
 	wmb();
 	hdr->flags = 0;
diff --git a/include/linux/ntb.h b/include/linux/ntb.h
index cbc792c..9ac1a62 100644
--- a/include/linux/ntb.h
+++ b/include/linux/ntb.h
@@ -50,8 +50,8 @@ struct ntb_transport_qp;
 
 struct ntb_client {
 	struct device_driver driver;
-	int (*probe) (struct pci_dev *pdev);
-	void (*remove) (struct pci_dev *pdev);
+	int (*probe)(struct pci_dev *pdev);
+	void (*remove)(struct pci_dev *pdev);
 };
 
 enum {
@@ -65,11 +65,11 @@ int ntb_register_client_dev(char *device_name);
 void ntb_unregister_client_dev(char *device_name);
 
 struct ntb_queue_handlers {
-	void (*rx_handler) (struct ntb_transport_qp *qp, void *qp_data,
-			    void *data, int len);
-	void (*tx_handler) (struct ntb_transport_qp *qp, void *qp_data,
-			    void *data, int len);
-	void (*event_handler) (void *data, int status);
+	void (*rx_handler)(struct ntb_transport_qp *qp, void *qp_data,
+			   void *data, int len);
+	void (*tx_handler)(struct ntb_transport_qp *qp, void *qp_data,
+			   void *data, int len);
+	void (*event_handler)(void *data, int status);
 };
 
 unsigned char ntb_transport_qp_num(struct ntb_transport_qp *qp);
-- 
1.8.3.2

