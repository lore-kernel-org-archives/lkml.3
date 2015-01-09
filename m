Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbbAIKt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:49:29 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44551 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757444AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todd Fujinaka <todd.fujinaka@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Vincent Donnefort <vdonnefort@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 31/78] igb: bring link up when PHY is powered up
Date: Fri,  9 Jan 2015 11:31:40 +0100
Message-Id: <aa63bf3db43a2722d8706733af71ac3642b1e804.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Todd Fujinaka <todd.fujinaka@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit aec653c43b0c55667355e26d7de1236bda9fb4e3 upstream.

Call igb_setup_link() when the PHY is powered up.

Signed-off-by: Todd Fujinaka <todd.fujinaka@intel.com>
Reported-by: Jeff Westfahl <jeff.westfahl@ni.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Vincent Donnefort <vdonnefort@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 2b76ae55f2af..02544ce60b1f 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1587,6 +1587,8 @@ void igb_power_up_link(struct igb_adapter *adapter)
 		igb_power_up_phy_copper(&adapter->hw);
 	else
 		igb_power_up_serdes_link_82575(&adapter->hw);
+
+	igb_setup_link(&adapter->hw);
 }
 
 /**
-- 
2.2.1

