Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539Ab3ERC5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:57:16 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:59373 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab3ERC5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:57:15 -0400
From: Jonghwan Choi <jhbird.choi@gmail.com>
To: Jon Mason <jon.mason@intel.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH 3.9-stable] ntb_netdev: remove from list on exit
Date: Sat, 18 May 2013 11:55:06 +0900
Message-Id: <1368845706-4300-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Mason <jon.mason@intel.com>

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Jon Mason <jon.mason@intel.com>"

commit 904435cf76a9bdd5eb41b1c4e049d5a64f3a8400 upstream

The ntb_netdev device is not removed from the global list of devices
upon device removal.  If the device is re-added, the removal code would
find the first instance and try to remove an already removed device.

Cc: <stable@vger.kernel.org> # 3.9.x: ad3e2751: ntb: off by one
Cc: <stable@vger.kernel.org> # 3.9.x: cc0f868d: NTB: fix pointer math
Cc: <stable@vger.kernel.org> # 3.9.x: 113fc505: NTB: Handle 64bit BAR
Cc: <stable@vger.kernel.org> # 3.9.x: b77b2637: NTB: Link toggle memory
Cc: <stable@vger.kernel.org> # 3.9.x: 90f9e934: NTB: reset tx_index on
Cc: <stable@vger.kernel.org> # 3.9.x: c9d534c8: NTB: Correctly handle receive
Cc: <stable@vger.kernel.org> # 3.9.x: c336acd3: NTB: memcpy lockup workaround
Signed-off-by: Jon Mason <jon.mason@intel.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/net/ntb_netdev.c | 2 ++
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
1.8.1.2

