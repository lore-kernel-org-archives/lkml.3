Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaHTLvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:51:36 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59010 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 087/104] igb: Fixed Wake On LAN support
Date: Wed, 20 Aug 2014 13:43:50 +0200
Message-Id: <f98ddec61f529efe8f31282dcbaf29c2b893a31f.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 42ce4126d8bc2e128e1f207cf79bb0623fac498f upstream.

This patch fixes Wake on LAN being reported as supported on some Ethernet
ports, in contrary to Hardware capability.

Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 6a5b67ba45c8..3eb020c9a081 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -2059,14 +2059,15 @@ static void igb_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
 
-	wol->supported = WAKE_UCAST | WAKE_MCAST |
-			 WAKE_BCAST | WAKE_MAGIC |
-			 WAKE_PHY;
 	wol->wolopts = 0;
 
 	if (!(adapter->flags & IGB_FLAG_WOL_SUPPORTED))
 		return;
 
+	wol->supported = WAKE_UCAST | WAKE_MCAST |
+			 WAKE_BCAST | WAKE_MAGIC |
+			 WAKE_PHY;
+
 	/* apply any specific unsupported masks here */
 	switch (adapter->hw.device_id) {
 	default:
-- 
2.0.4

