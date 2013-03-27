Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab3C0O7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:59:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:29553 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab3C0O7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:59:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,919,1355126400"; 
   d="scan'208";a="276679452"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/5] mei: ME structures should be initialized in mei_device_init
Date: Wed, 27 Mar 2013 16:58:27 +0200
Message-Id: <1364396310-10718-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364396310-10718-1-git-send-email-tomas.winkler@intel.com>
References: <1364396310-10718-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mei_timer and mei_host_client_init belongs to mei framework
and are not ME hw specific.
AMTHIF and WD are available only for ME but are above the hardware layer
so move the initialization back from mei_me_dev_init to mei_device_init.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c | 8 --------
 drivers/misc/mei/init.c  | 9 +++++++++
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 7c2b14d..12c2fa1 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -583,14 +583,6 @@ struct mei_device *mei_me_dev_init(struct pci_dev *pdev)
 
 	mei_device_init(dev);
 
-	INIT_LIST_HEAD(&dev->wd_cl.link);
-	INIT_LIST_HEAD(&dev->iamthif_cl.link);
-	mei_io_list_init(&dev->amthif_cmd_list);
-	mei_io_list_init(&dev->amthif_rd_complete_list);
-
-	INIT_DELAYED_WORK(&dev->timer_work, mei_timer);
-	INIT_WORK(&dev->init_work, mei_host_client_init);
-
 	dev->ops = &mei_me_hw_ops;
 
 	dev->pdev = pdev;
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index aced38c..33f5630 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -57,6 +57,15 @@ void mei_device_init(struct mei_device *dev)
 	mei_io_list_init(&dev->write_waiting_list);
 	mei_io_list_init(&dev->ctrl_wr_list);
 	mei_io_list_init(&dev->ctrl_rd_list);
+
+	INIT_DELAYED_WORK(&dev->timer_work, mei_timer);
+	INIT_WORK(&dev->init_work, mei_host_client_init);
+
+	INIT_LIST_HEAD(&dev->wd_cl.link);
+	INIT_LIST_HEAD(&dev->iamthif_cl.link);
+	mei_io_list_init(&dev->amthif_cmd_list);
+	mei_io_list_init(&dev->amthif_rd_complete_list);
+
 }
 
 /**
-- 
1.7.11.7

