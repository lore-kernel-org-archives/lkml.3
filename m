Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbaI2NdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:33:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:46945 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404AbaI2NdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:33:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393029999"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [RESEND char-misc-next 07/18] mei: kill error message for allocation failure
Date: Mon, 29 Sep 2014 16:31:39 +0300
Message-Id: <1411997510-29094-8-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
References: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to log memory allocation errors as
this is already done by the memory subsystem.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    | 4 +---
 drivers/misc/mei/interrupt.c | 1 -
 drivers/misc/mei/main.c      | 1 -
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 46241a6..1f80873 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -96,10 +96,8 @@ int mei_amthif_host_init(struct mei_device *dev)
 	/* allocate storage for ME message buffer */
 	msg_buf = kcalloc(dev->iamthif_mtu,
 			sizeof(unsigned char), GFP_KERNEL);
-	if (!msg_buf) {
-		dev_err(&dev->pdev->dev, "amthif: memory allocation for ME message buffer failed.\n");
+	if (!msg_buf)
 		return -ENOMEM;
-	}
 
 	dev->iamthif_msg_buf = msg_buf;
 
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 1b6c14b..b8d9cfe 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -126,7 +126,6 @@ static int mei_cl_irq_read_msg(struct mei_device *dev,
 					  GFP_KERNEL);
 
 			if (!buffer) {
-				cl_err(dev, cl, "allocation failed.\n");
 				list_del(&cb->list);
 				return -ENOMEM;
 			}
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index d60621e..244fb6b 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -377,7 +377,6 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 
 	write_cb = mei_io_cb_init(cl, file);
 	if (!write_cb) {
-		dev_err(&dev->pdev->dev, "write cb allocation failed\n");
 		rets = -ENOMEM;
 		goto out;
 	}
-- 
1.9.3

