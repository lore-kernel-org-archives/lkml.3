Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab3HNMgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:36:42 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:47421 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759861Ab3HNMgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:36:41 -0400
From: Xiaolong Ye <yexl@marvell.com>
To: <hjk@hansjkoch.de>, <greg@kroah.com>, <linux-kernel@vger.kernel.org>
CC: Xiaolong Ye <yexl@marvell.com>
Subject: [PATCH] uio: add uio_event_sync interface
Date: Wed, 14 Aug 2013 20:30:23 +0800
Message-ID: <1376483423-603-2-git-send-email-yexl@marvell.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376483423-603-1-git-send-email-yexl@marvell.com>
References: <1376483423-603-1-git-send-email-yexl@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This interface is called to sync listener->event_count and device
event count in multi-instances case.

Change-Id: Ibb1e4888ce55b4993394b61e4bcd6dce8b8291f0
Signed-off-by: Xiaolong Ye <yexl@marvell.com>
---
 drivers/uio/uio.c          |   12 ++++++++++++
 include/linux/uio_driver.h |    1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index ba47563..95d559f 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -408,6 +408,18 @@ void uio_event_notify(struct uio_info *info)
 EXPORT_SYMBOL_GPL(uio_event_notify);
 
 /**
+ * uio_event_sync - sync listener's event count with UIO device
+ * @listener: uio_listener structure
+ */
+void uio_event_sync(struct uio_listener *listener)
+{
+	struct uio_device *idev = listener->dev;
+
+	listener->event_count = atomic_read(&idev->event);
+}
+EXPORT_SYMBOL_GPL(uio_event_sync);
+
+/**
  * uio_interrupt - hardware interrupt handler
  * @irq: IRQ number, can be UIO_IRQ_CYCLIC for cyclic timer
  * @dev_id: Pointer to the devices uio_device structure
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 1ad4724..d10e634 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -108,6 +108,7 @@ extern int __must_check
 
 extern void uio_unregister_device(struct uio_info *info);
 extern void uio_event_notify(struct uio_info *info);
+extern void uio_event_sync(struct uio_listener *listener);
 
 /* defines for uio_info->irq */
 #define UIO_IRQ_CUSTOM	-1
-- 
1.7.9.5

