Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3C0Pfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:35:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:57439 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab3C0PbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:31:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,920,1355126400"; 
   d="scan'208";a="308170166"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 07/11 V5] mei: bus: Implement bus driver data setter/getter
Date: Wed, 27 Mar 2013 17:29:59 +0200
Message-Id: <1364398203-11159-8-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364398203-11159-1-git-send-email-tomas.winkler@intel.com>
References: <1364398203-11159-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

MEI drivers should be able to carry their private data around.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c     | 12 ++++++++++++
 include/linux/mei_cl_bus.h |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 2b4b5b3..8dbcb15 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -461,6 +461,18 @@ int mei_cl_register_event_cb(struct mei_cl_device *device,
 }
 EXPORT_SYMBOL_GPL(mei_cl_register_event_cb);
 
+void *mei_cl_get_drvdata(const struct mei_cl_device *device)
+{
+	return dev_get_drvdata(&device->dev);
+}
+EXPORT_SYMBOL_GPL(mei_cl_get_drvdata);
+
+void mei_cl_set_drvdata(struct mei_cl_device *device, void *data)
+{
+	dev_set_drvdata(&device->dev, data);
+}
+EXPORT_SYMBOL_GPL(mei_cl_set_drvdata);
+
 void mei_cl_bus_rx_event(struct mei_cl *cl)
 {
 	struct mei_cl_device *device = cl->device;
diff --git a/include/linux/mei_cl_bus.h b/include/linux/mei_cl_bus.h
index d9958c3..1bece18 100644
--- a/include/linux/mei_cl_bus.h
+++ b/include/linux/mei_cl_bus.h
@@ -35,4 +35,7 @@ int mei_cl_register_event_cb(struct mei_cl_device *device,
 #define MEI_CL_EVENT_RX 0
 #define MEI_CL_EVENT_TX 1
 
+void *mei_cl_get_drvdata(const struct mei_cl_device *device);
+void mei_cl_set_drvdata(struct mei_cl_device *device, void *data);
+
 #endif /* _LINUX_MEI_CL_BUS_H */
-- 
1.7.11.7

