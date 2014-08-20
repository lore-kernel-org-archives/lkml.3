Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaHTLwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:52:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58999 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 084/104] igb: Fix master/slave mode for all m88 i354 PHY's
Date: Wed, 20 Aug 2014 13:43:47 +0200
Message-Id: <0276eecbb09a106e232b11a5a31021cfe920a969.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carolyn Wyborny <carolyn.wyborny@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d1c17d806b6a52ff020322bec457717a91ea50a9 upstream.

This patch calls code to set the master/slave mode for all m88 gen 2
PHY's. This patch also removes the call to this function for I210 devices
only from the function that is not called by I210 devices.

Signed-off-by: Carolyn Wyborny <carolyn.wyborny@intel.com>
Tested-by: Jeff Pieper  <jeffrey.e.pieper@gmail.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/intel/igb/e1000_phy.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_phy.c b/drivers/net/ethernet/intel/igb/e1000_phy.c
index 556da81ab092..ad2b74d95138 100644
--- a/drivers/net/ethernet/intel/igb/e1000_phy.c
+++ b/drivers/net/ethernet/intel/igb/e1000_phy.c
@@ -708,11 +708,6 @@ s32 igb_copper_link_setup_m88(struct e1000_hw *hw)
 		hw_dbg("Error committing the PHY changes\n");
 		goto out;
 	}
-	if (phy->type == e1000_phy_i210) {
-		ret_val = igb_set_master_slave_mode(hw);
-		if (ret_val)
-			return ret_val;
-	}
 
 out:
 	return ret_val;
@@ -806,6 +801,9 @@ s32 igb_copper_link_setup_m88_gen2(struct e1000_hw *hw)
 		hw_dbg("Error committing the PHY changes\n");
 		return ret_val;
 	}
+	ret_val = igb_set_master_slave_mode(hw);
+	if (ret_val)
+		return ret_val;
 
 	return 0;
 }
-- 
2.0.4

