Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaETKeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:34:10 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:40337 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbaETKeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:34:06 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] USB: as102_usb_drv.c: Remove useless return variables
Date: Tue, 20 May 2014 12:33:46 +0200
Message-Id: <1400582028-24990-6-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove variables that are initialized with a constant,
are never updated, and are only used as parameter of return.
Return the constant instead of using a variable.

Verified by compilation only.

The coccinelle script that find and fixes this issue is:
// <smpl>
@@
type T;
constant C;
identifier ret;
@@
- T ret = C;
... when != ret
- return ret;
+ return C;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/staging/media/as102/as102_usb_drv.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index e4a6945..e6f6278 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -249,7 +249,7 @@ static void as102_free_usb_stream_buffer(struct as102_dev_t *dev)
 
 static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev)
 {
-	int i, ret = 0;
+	int i;
 
 	dev->stream = usb_alloc_coherent(dev->bus_adap.usb_dev,
 				       MAX_STREAM_URB * AS102_USB_BUF_SIZE,
@@ -280,7 +280,7 @@ static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev)
 
 		dev->stream_urb[i] = urb;
 	}
-	return ret;
+	return 0;
 }
 
 static void as102_usb_stop_stream(struct as102_dev_t *dev)
@@ -458,7 +458,6 @@ exit:
 
 static int as102_release(struct inode *inode, struct file *file)
 {
-	int ret = 0;
 	struct as102_dev_t *dev = NULL;
 
 	dev = file->private_data;
@@ -467,7 +466,7 @@ static int as102_release(struct inode *inode, struct file *file)
 		kref_put(&dev->kref, as102_usb_release);
 	}
 
-	return ret;
+	return 0;
 }
 
 MODULE_DEVICE_TABLE(usb, as102_usb_id_table);

