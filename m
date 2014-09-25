Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaIYPl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:41:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:38793 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660AbaIYPlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:41:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,597,1406617200"; 
   d="scan'208";a="605317656"
From: Octavian Purdila <octavian.purdila@intel.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, johan@kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v4 3/3] mfd: viperboard: remove unused platform_device
Date: Thu, 25 Sep 2014 18:41:37 +0300
Message-Id: <1411659697-27258-4-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411659697-27258-1-git-send-email-octavian.purdila@intel.com>
References: <1411659697-27258-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove pdev field from struct vpbrd as it is not used in the MFD
driver or in any of the sub-drivers.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/mfd/viperboard.c       | 1 -
 include/linux/mfd/viperboard.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
index 0d46d05..f4dcba6 100644
--- a/drivers/mfd/viperboard.c
+++ b/drivers/mfd/viperboard.c
@@ -73,7 +73,6 @@ static int vprbrd_probe(struct usb_interface *interface,
 
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

