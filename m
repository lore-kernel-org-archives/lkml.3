Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3LNMO4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 07:14:56 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:63856 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3LNMOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 07:14:48 -0500
Date: Sat, 14 Dec 2013 17:44:36 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        Matthew Vick <matthew.vick@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH v2 1/9] drivers: net: Remove unused function
 igb_get_eee_status_i354() in e1000_82575.c
Message-ID: <a610f6ee6bb992b91e43bdc851f3db62fc3decd5.1386911123.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the function igb_get_eee_status_i354() in
e1000_82575.c because it is unused.

It thus eliminates the following warning in
ethernet/intel/igb/e1000_82575.c:
drivers/net/ethernet/intel/igb/e1000_82575.c:2591:5: warning: no previous prototype for ‘igb_get_eee_status_i354’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/net/ethernet/intel/igb/e1000_82575.c |   32 --------------------------
 1 file changed, 32 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.c b/drivers/net/ethernet/intel/igb/e1000_82575.c
index 47c2d10..18e5200 100644
--- a/drivers/net/ethernet/intel/igb/e1000_82575.c
+++ b/drivers/net/ethernet/intel/igb/e1000_82575.c
@@ -2580,38 +2580,6 @@ out:
 	return ret_val;
 }
 
-/**
- *  igb_get_eee_status_i354 - Get EEE status
- *  @hw: pointer to the HW structure
- *  @status: EEE status
- *
- *  Get EEE status by guessing based on whether Tx or Rx LPI indications have
- *  been received.
- **/
-s32 igb_get_eee_status_i354(struct e1000_hw *hw, bool *status)
-{
-	struct e1000_phy_info *phy = &hw->phy;
-	s32 ret_val = 0;
-	u16 phy_data;
-
-	/* Check if EEE is supported on this device. */
-	if ((hw->phy.media_type != e1000_media_type_copper) ||
-	    (phy->id != M88E1543_E_PHY_ID))
-		goto out;
-
-	ret_val = igb_read_xmdio_reg(hw, E1000_PCS_STATUS_ADDR_I354,
-				     E1000_PCS_STATUS_DEV_I354,
-				     &phy_data);
-	if (ret_val)
-		goto out;
-
-	*status = phy_data & (E1000_PCS_STATUS_TX_LPI_RCVD |
-			      E1000_PCS_STATUS_RX_LPI_RCVD) ? true : false;
-
-out:
-	return ret_val;
-}
-
 static const u8 e1000_emc_temp_data[4] = {
 	E1000_EMC_INTERNAL_DATA,
 	E1000_EMC_DIODE1_DATA,
-- 
1.7.9.5

