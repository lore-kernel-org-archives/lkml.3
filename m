Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889Ab3BKSiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 13:38:09 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:55050 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758777Ab3BKSiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 13:38:07 -0500
Message-ID: <1360607885.2028.39.camel@joe-AO722>
Subject: [PATCH] staging: media: Remove unnecessary OOM messages
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 11 Feb 2013 10:38:05 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc failures already get standardized OOM
messages and a dump_stack.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/media/as102/as102_usb_drv.c |  4 +---
 drivers/staging/media/go7007/go7007-fw.c    | 24 +++++++-----------------
 drivers/staging/media/go7007/s2250-loader.c |  5 ++---
 drivers/staging/media/lirc/lirc_imon.c      |  3 ---
 drivers/staging/media/lirc/lirc_sasem.c     |  6 ------
 5 files changed, 10 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index aaf1bc2..9f275f0 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -374,10 +374,8 @@ static int as102_usb_probe(struct usb_interface *intf,
 	}
 
 	as102_dev = kzalloc(sizeof(struct as102_dev_t), GFP_KERNEL);
-	if (as102_dev == NULL) {
-		dev_err(&intf->dev, "%s: kzalloc failed\n", __func__);
+	if (as102_dev == NULL)
 		return -ENOMEM;
-	}
 
 	/* Assign the user-friendly device name */
 	for (i = 0; i < ARRAY_SIZE(as102_usb_id_table); i++) {
diff --git a/drivers/staging/media/go7007/go7007-fw.c b/drivers/staging/media/go7007/go7007-fw.c
index f99c05b..a5ede1c 100644
--- a/drivers/staging/media/go7007/go7007-fw.c
+++ b/drivers/staging/media/go7007/go7007-fw.c
@@ -381,11 +381,8 @@ static int gen_mjpeghdr_to_package(struct go7007 *go, __le16 *code, int space)
 	int size = 0, i, off = 0, chunk;
 
 	buf = kzalloc(4096, GFP_KERNEL);
-	if (buf == NULL) {
-		dev_err(go->dev,
-			"unable to allocate 4096 bytes for firmware construction\n");
+	if (buf == NULL)
 		return -1;
-	}
 
 	for (i = 1; i < 32; ++i) {
 		mjpeg_frame_header(go, buf + size, i);
@@ -651,11 +648,9 @@ static int gen_mpeg1hdr_to_package(struct go7007 *go,
 	int i, off = 0, chunk;
 
 	buf = kzalloc(5120, GFP_KERNEL);
-	if (buf == NULL) {
-		dev_err(go->dev,
-			"unable to allocate 5120 bytes for firmware construction\n");
+	if (buf == NULL)
 		return -1;
-	}
+
 	framelen[0] = mpeg1_frame_header(go, buf, 0, 1, PFRAME);
 	if (go->interlace_coding)
 		framelen[0] += mpeg1_frame_header(go, buf + framelen[0] / 8,
@@ -838,11 +833,9 @@ static int gen_mpeg4hdr_to_package(struct go7007 *go,
 	int i, off = 0, chunk;
 
 	buf = kzalloc(5120, GFP_KERNEL);
-	if (buf == NULL) {
-		dev_err(go->dev,
-			"unable to allocate 5120 bytes for firmware construction\n");
+	if (buf == NULL)
 		return -1;
-	}
+
 	framelen[0] = mpeg4_frame_header(go, buf, 0, PFRAME);
 	i = 368;
 	framelen[1] = mpeg4_frame_header(go, buf + i, 0, BFRAME_PRE);
@@ -1582,12 +1575,9 @@ int go7007_construct_fw_image(struct go7007 *go, u8 **fw, int *fwlen)
 		return -1;
 	}
 	code = kzalloc(codespace * 2, GFP_KERNEL);
-	if (code == NULL) {
-		dev_err(go->dev,
-			"unable to allocate %d bytes for firmware construction\n",
-			codespace * 2);
+	if (code == NULL)
 		goto fw_failed;
-	}
+
 	src = (__le16 *)fw_entry->data;
 	srclen = fw_entry->size / 2;
 	while (srclen >= 2) {
diff --git a/drivers/staging/media/go7007/s2250-loader.c b/drivers/staging/media/go7007/s2250-loader.c
index f57eb3b..72e5175 100644
--- a/drivers/staging/media/go7007/s2250-loader.c
+++ b/drivers/staging/media/go7007/s2250-loader.c
@@ -81,10 +81,9 @@ static int s2250loader_probe(struct usb_interface *interface,
 
 	/* Allocate dev data structure */
 	s = kmalloc(sizeof(device_extension_t), GFP_KERNEL);
-	if (s == NULL) {
-		dev_err(&interface->dev, "Out of memory\n");
+	if (s == NULL)
 		goto failed;
-	}
+
 	s2250_dev_table[minor] = s;
 
 	dev_info(&interface->dev,
diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index 343c622..0a2c45d 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -744,7 +744,6 @@ static int imon_probe(struct usb_interface *interface,
 
 	context = kzalloc(sizeof(struct imon_context), GFP_KERNEL);
 	if (!context) {
-		dev_err(dev, "%s: kzalloc failed for context\n", __func__);
 		alloc_status = 1;
 		goto alloc_status_switch;
 	}
@@ -826,13 +825,11 @@ static int imon_probe(struct usb_interface *interface,
 
 	driver = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
 	if (!driver) {
-		dev_err(dev, "%s: kzalloc failed for lirc_driver\n", __func__);
 		alloc_status = 2;
 		goto alloc_status_switch;
 	}
 	rbuf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
 	if (!rbuf) {
-		dev_err(dev, "%s: kmalloc failed for lirc_buffer\n", __func__);
 		alloc_status = 3;
 		goto alloc_status_switch;
 	}
diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
index b3fe21e..68acca7 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -759,22 +759,16 @@ static int sasem_probe(struct usb_interface *interface,
 
 	context = kzalloc(sizeof(struct sasem_context), GFP_KERNEL);
 	if (!context) {
-		dev_err(&interface->dev,
-			"%s: kzalloc failed for context\n", __func__);
 		alloc_status = 1;
 		goto alloc_status_switch;
 	}
 	driver = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
 	if (!driver) {
-		dev_err(&interface->dev,
-			"%s: kzalloc failed for lirc_driver\n", __func__);
 		alloc_status = 2;
 		goto alloc_status_switch;
 	}
 	rbuf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
 	if (!rbuf) {
-		dev_err(&interface->dev,
-			"%s: kmalloc failed for lirc_buffer\n", __func__);
 		alloc_status = 3;
 		goto alloc_status_switch;
 	}


