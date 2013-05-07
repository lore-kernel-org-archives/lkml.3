Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab3EGFwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 01:52:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:9225 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab3EGFwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 01:52:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,625,1363158000"; 
   d="scan'208";a="298673665"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: davem@davemloft.net, torvalds@linux-foundation.org
Cc: Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        gospo@redhat.com, sassmann@redhat.com, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net] e1000e: fix scheduling while atomic bug
Date: Mon,  6 May 2013 22:52:47 -0700
Message-Id: <1367905967-12824-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

A scheduling while atomic bug was introduced recently (by commit ce43a216
e1000e: cleanup USLEEP_RANGE checkpatch checks).  Revert the particular
instance of usleep_range() which causes the bug.

Reported-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000e/e1000.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
index 82f1c84..ffbc08f 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -600,7 +600,7 @@ static inline s32 __ew32_prepare(struct e1000_hw *hw)
 	s32 i = E1000_ICH_FWSM_PCIM2PCI_COUNT;
 
 	while ((er32(FWSM) & E1000_ICH_FWSM_PCIM2PCI) && --i)
-		usleep_range(50, 100);
+		udelay(50);
 
 	return i;
 }
-- 
1.7.11.7

