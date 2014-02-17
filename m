Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaBQFJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 00:09:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:41607 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaBQFJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 00:09:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,858,1384329600"; 
   d="scan'208";a="484510074"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Doug Thompson <dougthompson@xmission.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sb_edac: degrade log level for "EDAC sbridge: Seeking for: dev 1d.3 PCI ID xxxx"
Date: Mon, 17 Feb 2014 13:10:23 +0800
Message-Id: <1392613824-11230-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a system with four Intel processor, it generates too many messages
"EDAC sbridge: Seeking for: dev 1d.3 PCI ID xxxx". And it doesn't
give many useful information for normal users, so change log level
from INFO to DEBUG.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/edac/sb_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 54e2abe..347c7a1 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1263,7 +1263,7 @@ static int sbridge_get_onedevice(struct pci_dev **prev,
 	struct pci_dev *pdev = NULL;
 	u8 bus = 0;
 
-	sbridge_printk(KERN_INFO,
+	sbridge_printk(KERN_DEBUG,
 		"Seeking for: dev %02x.%d PCI ID %04x:%04x\n",
 		dev_descr->dev, dev_descr->func,
 		PCI_VENDOR_ID_INTEL, dev_descr->dev_id);
-- 
1.7.10.4

