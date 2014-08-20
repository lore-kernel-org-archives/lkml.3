Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaHTLvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:51:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59005 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Fujinaka, Todd" <todd.fujinaka@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 086/104] igb: Don't let ethtool try to write to iNVM in i210/i211
Date: Wed, 20 Aug 2014 13:43:49 +0200
Message-Id: <2de264873cb1027f8bae30d320005ac1fd391d10.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Fujinaka, Todd" <todd.fujinaka@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a71fc313c4f569be5788caff07ef1fe346842c5b upstream.

Don't let ethtool try to write to iNVM in i210/i211.

This fixes an issue seen by Marek Vasut.

Reported-by: Marek Vasut <marex@denx.de>
Signed-off-by: Todd Fujinaka <todd.fujinaka@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 7bcf1ce59b41..6a5b67ba45c8 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -771,8 +771,10 @@ static int igb_set_eeprom(struct net_device *netdev,
 	if (eeprom->len == 0)
 		return -EOPNOTSUPP;
 
-	if (hw->mac.type == e1000_i211)
+	if ((hw->mac.type >= e1000_i210) &&
+	    !igb_get_flash_presence_i210(hw)) {
 		return -EOPNOTSUPP;
+	}
 
 	if (eeprom->magic != (hw->vendor_id | (hw->device_id << 16)))
 		return -EFAULT;
-- 
2.0.4

