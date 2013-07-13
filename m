Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab3GMA6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 20:58:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:11972 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757957Ab3GMA62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 20:58:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,656,1367996400"; 
   d="scan'208";a="330686418"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH 2/3] pch_gbe: Use PCH_GBE_PHY_REGS_LEN instead of 32
Date: Fri, 12 Jul 2013 17:58:06 -0700
Message-Id: <7320fe759f7076354707346a6d98b031f64f4039.1373676797.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1373677087-7747-1-git-send-email-dvhart@linux.intel.com>
References: <1373677087-7747-1-git-send-email-dvhart@linux.intel.com>
In-Reply-To: <ce5dd365d05f8747d269aa74e0bb929935d9cdee.1373676797.git.dvhart@linux.intel.com>
References: <ce5dd365d05f8747d269aa74e0bb929935d9cdee.1373676797.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid using magic numbers when we have perfectly good defines just lying
around.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Waskiewicz <peter.p.waskiewicz.jr@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index ab1039a..749ddd9 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -682,7 +682,7 @@ static int pch_gbe_init_phy(struct pch_gbe_adapter *adapter)
 	}
 	adapter->hw.phy.addr = adapter->mii.phy_id;
 	netdev_dbg(netdev, "phy_addr = %d\n", adapter->mii.phy_id);
-	if (addr == 32)
+	if (addr == PCH_GBE_PHY_REGS_LEN)
 		return -EAGAIN;
 	/* Selected the phy and isolate the rest */
 	for (addr = 0; addr < PCH_GBE_PHY_REGS_LEN; addr++) {
-- 
1.8.3.1

