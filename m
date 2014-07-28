Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaG1Hmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 03:42:53 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47645 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaG1Hmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 03:42:50 -0400
From: Ethan Zhao <ethan.zhao@oracle.com>
To: jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, carolyn.wyborny@intel.com,
        donald.c.skidmore@intel.com, gregory.v.rose@intel.com,
        alexander.h.duyck@intel.com, john.ronciak@intel.com,
        mitch.a.williams@intel.com
Cc: linux.nics@intel.com, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ethan.kernel@gmail.com, Ethan Zhao <ethan.zhao@oracle.com>
Subject: [PATCH] ixgbevf: remove useless bd_number from struct ixgbevf_adapter
Date: Mon, 28 Jul 2014 15:42:01 +0800
Message-Id: <1406533321-28011-1-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is useless and buggy, just remove it.

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h      |    1 -
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |    4 ----
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h b/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h
index a0a1de9..ba96cb5 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h
@@ -385,7 +385,6 @@ struct ixgbevf_adapter {
 	/* structs defined in ixgbe_vf.h */
 	struct ixgbe_hw hw;
 	u16 msg_enable;
-	u16 bd_number;
 	/* Interrupt Throttle Rate */
 	u32 eitr_param;
 
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index d0799e8..091b106 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -3464,7 +3464,6 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ixgbevf_adapter *adapter = NULL;
 	struct ixgbe_hw *hw = NULL;
 	const struct ixgbevf_info *ii = ixgbevf_info_tbl[ent->driver_data];
-	static int cards_found;
 	int err, pci_using_dac;
 
 	err = pci_enable_device(pdev);
@@ -3525,8 +3524,6 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ixgbevf_assign_netdev_ops(netdev);
 
-	adapter->bd_number = cards_found;
-
 	/* Setup hw api */
 	memcpy(&hw->mac.ops, ii->mac_ops, sizeof(hw->mac.ops));
 	hw->mac.type  = ii->mac;
@@ -3601,7 +3598,6 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hw_dbg(hw, "MAC: %d\n", hw->mac.type);
 
 	hw_dbg(hw, "Intel(R) 82599 Virtual Function\n");
-	cards_found++;
 	return 0;
 
 err_register:
-- 
1.7.1

