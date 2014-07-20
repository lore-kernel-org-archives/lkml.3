Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbaGTO05 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:26:57 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:37955 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157AbaGTO0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:26:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIKAEfRy1NXQ0aj/2dsb2JhbABZgw6BKa4jAQEBAQEFAW6dSAGBBBd2hAQBBScvIxBROR4ZiEYBsDSQcReFe4lQBxaEMAWbJZQvg0Y7Lw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Linux NICS <linux.nics@intel.com>, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org
Subject: [PATCH 19/30] e1000e: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:25:20 +0200
Message-Id: <1405866332-24652-10-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405866332-24652-1-git-send-email-fabf@skynet.be>
References: <1405866332-24652-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/intel/e1000e/82571.c   | 4 ----
 drivers/net/ethernet/intel/e1000e/ethtool.c | 2 --
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 1 -
 drivers/net/ethernet/intel/e1000e/mac.c     | 1 -
 4 files changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/82571.c b/drivers/net/ethernet/intel/e1000e/82571.c
index 218481e..dc79ed8 100644
--- a/drivers/net/ethernet/intel/e1000e/82571.c
+++ b/drivers/net/ethernet/intel/e1000e/82571.c
@@ -95,7 +95,6 @@ static s32 e1000_init_phy_params_82571(struct e1000_hw *hw)
 		break;
 	default:
 		return -E1000_ERR_PHY;
-		break;
 	}
 
 	/* This can only be done after all function pointers are setup. */
@@ -422,7 +421,6 @@ static s32 e1000_get_phy_id_82571(struct e1000_hw *hw)
 		break;
 	case e1000_82573:
 		return e1000e_get_phy_id(hw);
-		break;
 	case e1000_82574:
 	case e1000_82583:
 		ret_val = e1e_rphy(hw, MII_PHYSID1, &phy_id);
@@ -440,7 +438,6 @@ static s32 e1000_get_phy_id_82571(struct e1000_hw *hw)
 		break;
 	default:
 		return -E1000_ERR_PHY;
-		break;
 	}
 
 	return 0;
@@ -1458,7 +1455,6 @@ static s32 e1000_setup_copper_link_82571(struct e1000_hw *hw)
 		break;
 	default:
 		return -E1000_ERR_PHY;
-		break;
 	}
 
 	if (ret_val)
diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 815e26c..865ce45 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -1521,11 +1521,9 @@ static int e1000_setup_loopback_test(struct e1000_adapter *adapter)
 		switch (hw->mac.type) {
 		case e1000_80003es2lan:
 			return e1000_set_es2lan_mac_loopback(adapter);
-			break;
 		case e1000_82571:
 		case e1000_82572:
 			return e1000_set_82571_fiber_loopback(adapter);
-			break;
 		default:
 			rctl = er32(RCTL);
 			rctl |= E1000_RCTL_LBM_TCVR;
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 8894ab8..f236861 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -572,7 +572,6 @@ static s32 e1000_init_phy_params_ich8lan(struct e1000_hw *hw)
 		break;
 	default:
 		return -E1000_ERR_PHY;
-		break;
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/intel/e1000e/mac.c b/drivers/net/ethernet/intel/e1000e/mac.c
index 8c386f3a..30b74d5 100644
--- a/drivers/net/ethernet/intel/e1000e/mac.c
+++ b/drivers/net/ethernet/intel/e1000e/mac.c
@@ -787,7 +787,6 @@ static s32 e1000_commit_fc_settings_generic(struct e1000_hw *hw)
 	default:
 		e_dbg("Flow control param set incorrectly\n");
 		return -E1000_ERR_CONFIG;
-		break;
 	}
 
 	ew32(TXCW, txcw);
-- 
1.9.1

