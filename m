Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946463Ab3BHM3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:29:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:24039 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946392Ab3BHM3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:29:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,629,1355126400"; 
   d="scan'208";a="284477800"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 07/11 V2] mei: bus: Implement bus driver data setter/getter
Date: Fri,  8 Feb 2013 14:28:20 +0200
Message-Id: <1360326504-17041-8-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1360326504-17041-1-git-send-email-tomas.winkler@intel.com>
References: <1360326504-17041-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

MEI bus drivers should be able to carry their private data around.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c  |   12 ++++++++++++
 include/linux/mei_bus.h |    3 +++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 5a700cd..a787e48 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -448,6 +448,18 @@ int mei_bus_register_event_cb(struct mei_bus_client *client,
 }
 EXPORT_SYMBOL(mei_bus_register_event_cb);
 
+void *mei_bus_get_clientdata(const struct mei_bus_client *client)
+{
+	return dev_get_drvdata(&client->dev);
+}
+EXPORT_SYMBOL(mei_bus_get_clientdata);
+
+void mei_bus_set_clientdata(struct mei_bus_client *client, void *data)
+{
+	dev_set_drvdata(&client->dev, data);
+}
+EXPORT_SYMBOL(mei_bus_set_clientdata);
+
 void mei_bus_rx_event(struct mei_cl *cl)
 {
 	struct mei_bus_client *client = cl->client;
diff --git a/include/linux/mei_bus.h b/include/linux/mei_bus.h
index 738e073..912c84e 100644
--- a/include/linux/mei_bus.h
+++ b/include/linux/mei_bus.h
@@ -102,4 +102,7 @@ typedef void (*mei_bus_event_cb_t)(struct mei_bus_client *client,
 int mei_bus_register_event_cb(struct mei_bus_client *client,
 			      mei_bus_event_cb_t read_cb, void *context);
 
+void *mei_bus_get_clientdata(const struct mei_bus_client *client);
+void mei_bus_set_clientdata(struct mei_bus_client *client, void *data);
+
 #endif /* _LINUX_MEI_BUS_H */
-- 
1.7.4.4

