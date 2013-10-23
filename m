Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab3JWTQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 15:16:58 -0400
Received: from smtprelay0212.hostedemail.com ([216.40.44.212]:51336 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753239Ab3JWTPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 15:15:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3302:3353:3868:4250:4605:5007:6261:10004:10026:10848:11026:11232:11657:11658:11914:12043:12114:12296:12438:12517:12519:12555:13095:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: title23_6da5521ba6520
X-Filterd-Recvd-Size: 3252
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
Subject: [PATCH 5/8] media: Remove OOM message after input_allocate_device
Date: Wed, 23 Oct 2013 12:14:51 -0700
Message-Id: <7ee413793a1f3926952dcd6338f55d61511e56e6.1382555436.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382555436.git.joe@perches.com>
References: <cover.1382555436.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emitting an OOM message isn't necessary after input_allocate_device
as there's a generic OOM and a dump_stack already done.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/rc/imon.c                 | 8 ++------
 drivers/media/usb/em28xx/em28xx-input.c | 4 +---
 drivers/media/usb/pwc/pwc-if.c          | 1 -
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 72e3fa6..5e8e06c 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1909,10 +1909,8 @@ static struct input_dev *imon_init_idev(struct imon_context *ictx)
 	int ret, i;
 
 	idev = input_allocate_device();
-	if (!idev) {
-		dev_err(ictx->dev, "input dev allocation failed\n");
+	if (!idev)
 		goto out;
-	}
 
 	snprintf(ictx->name_idev, sizeof(ictx->name_idev),
 		 "iMON Panel, Knob and Mouse(%04x:%04x)",
@@ -1960,10 +1958,8 @@ static struct input_dev *imon_init_touch(struct imon_context *ictx)
 	int ret;
 
 	touch = input_allocate_device();
-	if (!touch) {
-		dev_err(ictx->dev, "touchscreen input dev allocation failed\n");
+	if (!touch)
 		goto touch_alloc_failed;
-	}
 
 	snprintf(ictx->name_touch, sizeof(ictx->name_touch),
 		 "iMON USB Touchscreen (%04x:%04x)",
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index ea181e4..13938ba 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -508,10 +508,8 @@ static void em28xx_register_snapshot_button(struct em28xx *dev)
 
 	em28xx_info("Registering snapshot button...\n");
 	input_dev = input_allocate_device();
-	if (!input_dev) {
-		em28xx_errdev("input_allocate_device failed\n");
+	if (!input_dev)
 		return;
-	}
 
 	usb_make_path(dev->udev, dev->snapshot_button_path,
 		      sizeof(dev->snapshot_button_path));
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 77bbf78..49406ef 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -1078,7 +1078,6 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	/* register webcam snapshot button input device */
 	pdev->button_dev = input_allocate_device();
 	if (!pdev->button_dev) {
-		PWC_ERROR("Err, insufficient memory for webcam snapshot button device.");
 		rc = -ENOMEM;
 		goto err_video_unreg;
 	}
-- 
1.8.1.2.459.gbcd45b4.dirty

