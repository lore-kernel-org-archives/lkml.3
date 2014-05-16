Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaEPFZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 01:25:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:21398 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062AbaEPFZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 01:25:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1064,1389772800"; 
   d="scan'208";a="541408513"
From: Octavian Purdila <octavian.purdila@intel.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com,
        Octavian Purdila <octavian.purdila@intel.com>,
        Jun Tian <jun.j.tian@intel.com>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH staging-next] goldfish: bus: fix warnings for 32bit builds
Date: Fri, 16 May 2014 08:24:58 +0300
Message-Id: <1400217899-32261-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/platform/goldfish/pdev_bus.c: In function 'goldfish_new_pdev':
drivers/platform/goldfish/pdev_bus.c:136:14: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
  writel((u32)(u64)name, pdev_bus_base + PDEV_BUS_GET_NAME);

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jun Tian <jun.j.tian@intel.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/platform/goldfish/pdev_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/goldfish/pdev_bus.c b/drivers/platform/goldfish/pdev_bus.c
index eb25440..8c43589 100644
--- a/drivers/platform/goldfish/pdev_bus.c
+++ b/drivers/platform/goldfish/pdev_bus.c
@@ -133,7 +133,7 @@ static int goldfish_new_pdev(void)
 #ifdef CONFIG_64BIT
 	writel((u32)((u64)name>>32), pdev_bus_base + PDEV_BUS_GET_NAME_HIGH);
 #endif
-	writel((u32)(u64)name, pdev_bus_base + PDEV_BUS_GET_NAME);
+	writel((u32)(unsigned long)name, pdev_bus_base + PDEV_BUS_GET_NAME);
 	name[name_len] = '\0';
 	dev->pdev.id = readl(pdev_bus_base + PDEV_BUS_ID);
 	dev->pdev.resource[0].start = base;
-- 
1.8.3.2

