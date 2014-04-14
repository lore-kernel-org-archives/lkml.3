Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbaDNK67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 06:58:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbaDNK64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:58:56 -0400
Date: Mon, 14 Apr 2014 12:58:53 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] driver core: Inline dev_set/get_drvdata
Message-ID: <20140414125853.1bc4c702@endymion.delvare>
In-Reply-To: <20140414124802.2859439e@endymion.delvare>
References: <20140414124802.2859439e@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_set_drvdata and dev_get_drvdata are now simple enough again that
we can inline them as they used to be before commit b40284378.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/dd.c      |   16 ----------------
 include/linux/device.h |   12 ++++++++++--
 2 files changed, 10 insertions(+), 18 deletions(-)

--- linux-3.15-rc1.orig/drivers/base/dd.c	2014-04-14 12:54:23.994967807 +0200
+++ linux-3.15-rc1/drivers/base/dd.c	2014-04-14 12:54:24.491979944 +0200
@@ -570,19 +570,3 @@ void driver_detach(struct device_driver
 		put_device(dev);
 	}
 }
-
-/*
- * These exports can't be _GPL due to .h files using this within them, and it
- * might break something that was previously working...
- */
-void *dev_get_drvdata(const struct device *dev)
-{
-	return dev->driver_data;
-}
-EXPORT_SYMBOL(dev_get_drvdata);
-
-void dev_set_drvdata(struct device *dev, void *data)
-{
-	dev->driver_data = data;
-}
-EXPORT_SYMBOL(dev_set_drvdata);
--- linux-3.15-rc1.orig/include/linux/device.h	2014-04-14 12:54:18.863842502 +0200
+++ linux-3.15-rc1/include/linux/device.h	2014-04-14 12:54:24.492979969 +0200
@@ -832,6 +832,16 @@ static inline void set_dev_node(struct d
 }
 #endif
 
+static inline void *dev_get_drvdata(const struct device *dev)
+{
+	return dev->driver_data;
+}
+
+static inline void dev_set_drvdata(struct device *dev, void *data)
+{
+	dev->driver_data = data;
+}
+
 static inline struct pm_subsys_data *dev_to_psd(struct device *dev)
 {
 	return dev ? dev->power.subsys_data : NULL;
@@ -916,8 +926,6 @@ extern int device_move(struct device *de
 extern const char *device_get_devnode(struct device *dev,
 				      umode_t *mode, kuid_t *uid, kgid_t *gid,
 				      const char **tmp);
-extern void *dev_get_drvdata(const struct device *dev);
-extern void dev_set_drvdata(struct device *dev, void *data);
 
 static inline bool device_supports_offline(struct device *dev)
 {

-- 
Jean Delvare
SUSE L3 Support
