Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaGTO0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:26:52 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:37955 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157AbaGTO0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:26:49 -0400
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
Subject: [PATCH 17/30] e1000: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:25:18 +0200
Message-Id: <1405866332-24652-8-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405866332-24652-1-git-send-email-fabf@skynet.be>
References: <1405866332-24652-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c | 3 ---
 drivers/net/ethernet/intel/e1000/e1000_hw.c      | 2 --
 2 files changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
index d50f78a..cca5bca 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -1316,7 +1316,6 @@ static int e1000_set_phy_loopback(struct e1000_adapter *adapter)
 	case e1000_82547:
 	case e1000_82547_rev_2:
 		return e1000_integrated_phy_loopback(adapter);
-		break;
 	default:
 		/* Default PHY loopback work is to read the MII
 		 * control register and assert bit 14 (loopback mode).
@@ -1325,7 +1324,6 @@ static int e1000_set_phy_loopback(struct e1000_adapter *adapter)
 		phy_reg |= MII_CR_LOOPBACK;
 		e1000_write_phy_reg(hw, PHY_CTRL, phy_reg);
 		return 0;
-		break;
 	}
 
 	return 8;
@@ -1344,7 +1342,6 @@ static int e1000_setup_loopback_test(struct e1000_adapter *adapter)
 		case e1000_82545_rev_3:
 		case e1000_82546_rev_3:
 			return e1000_set_phy_loopback(adapter);
-			break;
 		default:
 			rctl = er32(RCTL);
 			rctl |= E1000_RCTL_LBM_TCVR;
diff --git a/drivers/net/ethernet/intel/e1000/e1000_hw.c b/drivers/net/ethernet/intel/e1000/e1000_hw.c
index e9b07cc..1acf503 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_hw.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_hw.c
@@ -902,7 +902,6 @@ static s32 e1000_setup_fiber_serdes_link(struct e1000_hw *hw)
 	default:
 		e_dbg("Flow control param set incorrectly\n");
 		return -E1000_ERR_CONFIG;
-		break;
 	}
 
 	/* Since auto-negotiation is enabled, take the link out of reset (the
@@ -5041,7 +5040,6 @@ static s32 e1000_get_cable_length(struct e1000_hw *hw, u16 *min_length,
 			break;
 		default:
 			return -E1000_ERR_PHY;
-			break;
 		}
 	} else if (hw->phy_type == e1000_phy_igp) {	/* For IGP PHY */
 		u16 cur_agc_value;
-- 
1.9.1

