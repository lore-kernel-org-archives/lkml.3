Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbaKCRdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:33:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:20976 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbaKCRdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:33:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,308,1413270000"; 
   d="scan'208";a="625614037"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] mfd: lpc_sch: don't call mfd_remove_devices()
Date: Mon,  3 Nov 2014 19:29:23 +0200
Message-Id: <1415035763-24277-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MFD core already cares about failing registration. It will remove successfully
registered devices in case of error. Thus, no need to repeatedly call
mfd_remove_devices().

Fixes: 5829e9b64e65 (mfd: lpc_sch: Accomodate partial population of the MFD devices)
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/mfd/lpc_sch.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
index c980da4..5c38df3 100644
--- a/drivers/mfd/lpc_sch.c
+++ b/drivers/mfd/lpc_sch.c
@@ -193,11 +193,7 @@ static int lpc_sch_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		return -ENODEV;
 	}
 
-	ret = mfd_add_devices(&dev->dev, 0, lpc_sch_cells, cells, NULL, 0, NULL);
-	if (ret)
-		mfd_remove_devices(&dev->dev);
-
-	return ret;
+	return mfd_add_devices(&dev->dev, 0, lpc_sch_cells, cells, NULL, 0, NULL);
 }
 
 static void lpc_sch_remove(struct pci_dev *dev)
-- 
2.1.1

