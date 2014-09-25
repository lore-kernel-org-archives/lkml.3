Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaIYOn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:43:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:31564 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbaIYOn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:43:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,597,1406617200"; 
   d="scan'208";a="578908405"
From: Octavian Purdila <octavian.purdila@intel.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, johan@kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v3 3/3] mfd: viperboard: remove unused platform_device
Date: Thu, 25 Sep 2014 17:43:17 +0300
Message-Id: <1411656197-26517-4-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411656197-26517-1-git-send-email-octavian.purdila@intel.com>
References: <1411656197-26517-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/mfd/viperboard.c       | 1 -
 include/linux/mfd/viperboard.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
index 57fac1d..1e7c316 100644
--- a/drivers/mfd/viperboard.c
+++ b/drivers/mfd/viperboard.c
@@ -74,7 +74,6 @@ static int vprbrd_probe(struct usb_interface *interface,
 
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(interface, vb);
-	dev_set_drvdata(&vb->pdev.dev, vb);
 
 	/* get version information, major first, minor then */
 	pipe = usb_rcvctrlpipe(vb->usb_dev, 0);
diff --git a/include/linux/mfd/viperboard.h b/include/linux/mfd/viperboard.h
index af928d0..afc14ed 100644
--- a/include/linux/mfd/viperboard.h
+++ b/include/linux/mfd/viperboard.h
@@ -104,7 +104,6 @@ struct vprbrd {
 	struct usb_device *usb_dev; /* the usb device for this device */
 	struct mutex lock;
 	u8 *buf;
-	struct platform_device pdev;
 };
 
 #endif /* __MFD_VIPERBOARD_H__ */
-- 
1.9.1

