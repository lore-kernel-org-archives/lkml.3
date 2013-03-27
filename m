Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab3C0O7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:59:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:29553 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab3C0O7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:59:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,919,1355126400"; 
   d="scan'208";a="276679433"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/5] mei: unregister watchdog from mei_stop function
Date: Wed, 27 Mar 2013 16:58:26 +0200
Message-Id: <1364396310-10718-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364396310-10718-1-git-send-email-tomas.winkler@intel.com>
References: <1364396310-10718-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we need to unregister watchdog device both in suspend and remove
as the registration is recreated on reset

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/init.c   | 3 +++
 drivers/misc/mei/pci-me.c | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 09a9980..aced38c 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -211,6 +211,9 @@ void mei_stop(struct mei_device *dev)
 	mutex_unlock(&dev->device_lock);
 
 	flush_scheduled_work();
+
+	mei_watchdog_unregister(dev);
+
 }
 
 
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index b8b5c9c..252b1fd 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -253,8 +253,6 @@ static void mei_remove(struct pci_dev *pdev)
 
 	mei_pdev = NULL;
 
-	mei_watchdog_unregister(dev);
-
 	/* disable interrupts */
 	mei_disable_interrupts(dev);
 
-- 
1.7.11.7

