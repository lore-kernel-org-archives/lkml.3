Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaGZOXN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:23:13 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:44486 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaGZOXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:23:11 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Linux NICS <linux.nics@intel.com>, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: intel: ixgbe: ixgbe_main.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:24:36 +0200
Message-Id: <1406384676-2606-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index f5aa331..ccf6a81 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8161,7 +8161,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->netdev_ops = &ixgbe_netdev_ops;
 	ixgbe_set_ethtool_ops(netdev);
 	netdev->watchdog_timeo = 5 * HZ;
-	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
+	strlcpy(netdev->name, pci_name(pdev), sizeof(netdev->name));
 
 	adapter->bd_number = cards_found;
 
@@ -8388,7 +8388,7 @@ skip_sriov:
 
 	err = ixgbe_read_pba_string_generic(hw, part_str, IXGBE_PBANUM_LENGTH);
 	if (err)
-		strncpy(part_str, "Unknown", IXGBE_PBANUM_LENGTH);
+		strlcpy(part_str, "Unknown", IXGBE_PBANUM_LENGTH);
 	if (ixgbe_is_sfp(hw) && hw->phy.sfp_type != ixgbe_sfp_type_not_present)
 		e_dev_info("MAC: %d, PHY: %d, SFP+: %d, PBA No: %s\n",
 			   hw->mac.type, hw->phy.type, hw->phy.sfp_type,
-- 
1.7.10.4

