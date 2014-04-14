Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaDNK4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 06:56:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669AbaDNK4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:56:36 -0400
Date: Mon, 14 Apr 2014 12:56:34 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] driver core: dev_set_drvdata returns void
Message-ID: <20140414125634.546c97ef@endymion.delvare>
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

dev_set_drvdata can no longer fail, so it could return void.

All callers have hopefully been updated to no longer check for the
return value.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/dd.c      |    3 +--
 include/linux/device.h |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

--- linux-3.15-rc1.orig/drivers/base/dd.c	2014-04-14 12:52:52.957743343 +0200
+++ linux-3.15-rc1/drivers/base/dd.c	2014-04-14 12:54:21.520907390 +0200
@@ -583,9 +583,8 @@ void *dev_get_drvdata(const struct devic
 }
 EXPORT_SYMBOL(dev_get_drvdata);
 
-int dev_set_drvdata(struct device *dev, void *data)
+void dev_set_drvdata(struct device *dev, void *data)
 {
 	dev->driver_data = data;
-	return 0;
 }
 EXPORT_SYMBOL(dev_set_drvdata);
--- linux-3.15-rc1.orig/include/linux/device.h	2014-04-14 12:53:10.284166917 +0200
+++ linux-3.15-rc1/include/linux/device.h	2014-04-14 12:54:18.863842502 +0200
@@ -917,7 +917,7 @@ extern const char *device_get_devnode(st
 				      umode_t *mode, kuid_t *uid, kgid_t *gid,
 				      const char **tmp);
 extern void *dev_get_drvdata(const struct device *dev);
-extern int dev_set_drvdata(struct device *dev, void *data);
+extern void dev_set_drvdata(struct device *dev, void *data);
 
 static inline bool device_supports_offline(struct device *dev)
 {

-- 
Jean Delvare
SUSE L3 Support
