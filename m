Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab3ASJDY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 04:03:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:31720 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707Ab3ASJDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:03:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,498,1355126400"; 
   d="scan'208";a="278958235"
From: Jon Mason <jon.mason@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 16/21] ntb_netdev: remove init/exit from probe/remove
Date: Sat, 19 Jan 2013 02:02:30 -0700
Message-Id: <1358586155-23322-17-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
References: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove init/exit from probe/remove routines to correct warnings of
"Section mismatch".

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/net/ntb_netdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index 4e52fd2..0d4a6ee 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -373,7 +373,7 @@ err:
 	return rc;
 }
 
-static void __exit ntb_netdev_remove(struct pci_dev *pdev)
+static void ntb_netdev_remove(struct pci_dev *pdev)
 {
 	struct net_device *ndev;
 	struct ntb_netdev *dev;
-- 
1.7.9.5

