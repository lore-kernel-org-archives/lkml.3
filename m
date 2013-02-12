Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827Ab3BLSim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:38:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:52524 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933775Ab3BLSiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:38:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="201566619"
From: Samuel Ortiz <sameo@linux.intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [char-misc-next 08/12 v3] mei: bus: Implement bus driver data setter/getter
Date: Tue, 12 Feb 2013 19:36:58 +0100
Message-Id: <1360694222-27632-9-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
References: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MEI drivers should be able to carry their private data around.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c  |   12 ++++++++++++
 include/linux/mei_bus.h |    3 +++
 2 files changed, 15 insertions(+)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 85ca872..163da66 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -440,6 +440,18 @@ int mei_register_event_cb(struct mei_device *device,
 }
 EXPORT_SYMBOL_GPL(mei_register_event_cb);
 
+void *mei_get_clientdata(const struct mei_device *device)
+{
+	return dev_get_drvdata(&device->dev);
+}
+EXPORT_SYMBOL_GPL(mei_get_clientdata);
+
+void mei_set_clientdata(struct mei_device *device, void *data)
+{
+	dev_set_drvdata(&device->dev, data);
+}
+EXPORT_SYMBOL_GPL(mei_set_clientdata);
+
 void mei_bus_rx_event(struct mei_cl *cl)
 {
 	struct mei_device *device = cl->device;
diff --git a/include/linux/mei_bus.h b/include/linux/mei_bus.h
index 4ce6301..e14182a 100644
--- a/include/linux/mei_bus.h
+++ b/include/linux/mei_bus.h
@@ -106,4 +106,7 @@ typedef void (*mei_event_cb_t)(struct mei_device *device,
 int mei_register_event_cb(struct mei_device *device,
 			  mei_event_cb_t read_cb, void *context);
 
+void *mei_get_clientdata(const struct mei_device *device);
+void mei_set_clientdata(struct mei_device *device, void *data);
+
 #endif /* _LINUX_MEI_BUS_H */
-- 
1.7.10.4

