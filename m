Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbaGHTFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:05:55 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:61651 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932329AbaGHTFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:05:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgNAORAvFNXQDwH/2dsb2JhbABZgw6tJQEBAQEBAQUBbgGZWQGBFxd1hAQBBSdSEFE5HhmIRgHIJheFeolIBxaELQWadpQMg0U7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 2/9] ixgbe: remove unnecessary break after goto
Date: Tue,  8 Jul 2014 21:05:22 +0200
Message-Id: <1404846329-19235-3-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1404846329-19235-1-git-send-email-fabf@skynet.be>
References: <1404846329-19235-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c  | 1 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c  | 4 ----
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c | 2 --
 3 files changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c
index 1560933..206171f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c
@@ -430,7 +430,6 @@ static s32 ixgbe_fc_enable_82598(struct ixgbe_hw *hw)
 		hw_dbg(hw, "Flow control param set incorrectly\n");
 		ret_val = IXGBE_ERR_CONFIG;
 		goto out;
-		break;
 	}
 
 	/* Set 802.3x based flow control settings. */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
index bc7c924..0373a5b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
@@ -432,7 +432,6 @@ static s32 ixgbe_get_link_capabilities_82599(struct ixgbe_hw *hw,
 	default:
 		status = IXGBE_ERR_LINK_SETUP;
 		goto out;
-		break;
 	}
 
 	if (hw->phy.multispeed_fiber) {
@@ -2035,7 +2034,6 @@ static u32 ixgbe_get_supported_physical_layer_82599(struct ixgbe_hw *hw)
 		else if (pma_pmd_10g_parallel == IXGBE_AUTOC_10G_XAUI)
 			physical_layer = IXGBE_PHYSICAL_LAYER_10GBASE_XAUI;
 		goto out;
-		break;
 	case IXGBE_AUTOC_LMS_10G_SERIAL:
 		if (pma_pmd_10g_serial == IXGBE_AUTOC2_10G_KR) {
 			physical_layer = IXGBE_PHYSICAL_LAYER_10GBASE_KR;
@@ -2052,10 +2050,8 @@ static u32 ixgbe_get_supported_physical_layer_82599(struct ixgbe_hw *hw)
 		if (autoc & IXGBE_AUTOC_KR_SUPP)
 			physical_layer |= IXGBE_PHYSICAL_LAYER_10GBASE_KR;
 		goto out;
-		break;
 	default:
 		goto out;
-		break;
 	}
 
 sfp_check:
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
index 4e5385a..3f318c5 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
@@ -216,7 +216,6 @@ static s32 ixgbe_setup_fc(struct ixgbe_hw *hw)
 		hw_dbg(hw, "Flow control param set incorrectly\n");
 		ret_val = IXGBE_ERR_CONFIG;
 		goto out;
-		break;
 	}
 
 	if (hw->mac.type != ixgbe_mac_X540) {
@@ -2179,7 +2178,6 @@ s32 ixgbe_fc_enable_generic(struct ixgbe_hw *hw)
 		hw_dbg(hw, "Flow control param set incorrectly\n");
 		ret_val = IXGBE_ERR_CONFIG;
 		goto out;
-		break;
 	}
 
 	/* Set 802.3x based flow control settings. */
-- 
1.8.4.5

