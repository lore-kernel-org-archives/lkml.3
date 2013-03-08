Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924Ab3CHIXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 03:23:03 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:62314 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878Ab3CHIWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 03:22:46 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAEufOVFbdWOb/2dsb2JhbABDxE2BWBZ0giwBBSdSEFFXBhOIF7sljwwHg0ADlkuJZocLgwo
X-IPAS-Result: Av8EAEufOVFbdWOb/2dsb2JhbABDxE2BWBZ0giwBBSdSEFFXBhOIF7sljwwHg0ADlkuJZocLgwo
X-IronPort-AV: E=Sophos;i="4.84,806,1355094000"; 
   d="scan'208";a="9268302"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 2/3] ipack: add ipack_get_device() ipack_put_device()
Date: Fri,  8 Mar 2013 09:21:46 +0100
Message-Id: <1362730907-10047-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362730907-10047-1-git-send-email-siglesias@igalia.com>
References: <512DCB33.6030500@igalia.com>
 <1362730907-10047-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare everything for later use.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/ipack.c |   12 ++++++++++++
 include/linux/ipack.h |    3 +++
 2 files changed, 15 insertions(+)

diff --git a/drivers/ipack/ipack.c b/drivers/ipack/ipack.c
index 599d4ff..bdac7f6 100644
--- a/drivers/ipack/ipack.c
+++ b/drivers/ipack/ipack.c
@@ -462,6 +462,18 @@ void ipack_device_unregister(struct ipack_device *dev)
 }
 EXPORT_SYMBOL_GPL(ipack_device_unregister);
 
+void ipack_get_device(struct ipack_device *dev)
+{
+	get_device(&dev->dev);
+}
+EXPORT_SYMBOL_GPL(ipack_get_device);
+
+void ipack_put_device(struct ipack_device *dev)
+{
+	put_device(&dev->dev);
+}
+EXPORT_SYMBOL_GPL(ipack_put_device);
+
 static int __init ipack_init(void)
 {
 	ida_init(&ipack_ida);
diff --git a/include/linux/ipack.h b/include/linux/ipack.h
index fea12cb..def91fd 100644
--- a/include/linux/ipack.h
+++ b/include/linux/ipack.h
@@ -221,6 +221,9 @@ void ipack_driver_unregister(struct ipack_driver *edrv);
 int ipack_device_register(struct ipack_device *dev);
 void ipack_device_unregister(struct ipack_device *dev);
 
+void ipack_get_device(struct ipack_device *dev);
+void ipack_put_device(struct ipack_device *dev);
+
 /**
  * DEFINE_IPACK_DEVICE_TABLE - macro used to describe a IndustryPack table
  * @_table: device table name
-- 
1.7.10.4

