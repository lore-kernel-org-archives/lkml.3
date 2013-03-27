Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab3C0PAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:00:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:29553 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521Ab3C0O7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:59:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,919,1355126400"; 
   d="scan'208";a="276679466"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/5] mei: rename function mei_hw_init to mei_start
Date: Wed, 27 Mar 2013 16:58:28 +0200
Message-Id: <1364396310-10718-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364396310-10718-1-git-send-email-tomas.winkler@intel.com>
References: <1364396310-10718-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hw initialization is now done as part of
hw specific code this makes the name mei_hw_init little misleading.

We rename it to mei_start in spirit of already existing
functions mei_stop and mei_reset.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/init.c    | 4 ++--
 drivers/misc/mei/mei_dev.h | 2 +-
 drivers/misc/mei/pci-me.c  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 33f5630..b3f7c3e 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -69,13 +69,13 @@ void mei_device_init(struct mei_device *dev)
 }
 
 /**
- * mei_hw_init - initializes host and fw to start work.
+ * mei_start - initializes host and fw to start work.
  *
  * @dev: the device structure
  *
  * returns 0 on success, <0 on failure.
  */
-int mei_hw_init(struct mei_device *dev)
+int mei_start(struct mei_device *dev)
 {
 	int ret = 0;
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 091f50af..b5d6607 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -393,7 +393,7 @@ static inline u32 mei_data2slots(size_t length)
  */
 void mei_device_init(struct mei_device *dev);
 void mei_reset(struct mei_device *dev, int interrupts);
-int mei_hw_init(struct mei_device *dev);
+int mei_start(struct mei_device *dev);
 void mei_stop(struct mei_device *dev);
 
 /*
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 252b1fd..985afd0 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -184,7 +184,7 @@ static int mei_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto disable_msi;
 	}
 
-	if (mei_hw_init(dev)) {
+	if (mei_start(dev)) {
 		dev_err(&pdev->dev, "init hw failure.\n");
 		err = -ENODEV;
 		goto release_irq;
-- 
1.7.11.7

