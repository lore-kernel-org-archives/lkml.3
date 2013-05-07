Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296Ab3EGB4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:56:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:37944 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933110Ab3EGB4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:56:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,624,1363158000"; 
   d="scan'208";a="298596800"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 09/10] ntb_netdev: remove from list on exit
Date: Mon,  6 May 2013 18:55:28 -0700
Message-Id: <1367891729-11738-10-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367891729-11738-1-git-send-email-jon.mason@intel.com>
References: <1367891729-11738-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ntb_netdev device is not removed from the global list of devices
upon device removal.  If the device is re-added, the removal code would
find the first instance and try to remove an already removed device.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/net/ntb_netdev.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index ed947dd..f3cdf64 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -375,6 +375,8 @@ static void ntb_netdev_remove(struct pci_dev *pdev)
 	if (dev == NULL)
 		return;
 
+	list_del(&dev->list);
+
 	ndev = dev->ndev;
 
 	unregister_netdev(ndev);
-- 
1.7.9.5

