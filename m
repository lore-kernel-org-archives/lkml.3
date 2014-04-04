Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaDDWQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 18:16:15 -0400
Received: from smtprelay0219.hostedemail.com ([216.40.44.219]:57919 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753061AbaDDWQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 18:16:12 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:1801:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3868:4321:4385:4605:5007:6261:10004:10026:10848:11026:11473:11658:11914:12043:12438:12517:12519:12555:13138:13231:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dirt82_70214c7f9f836
X-Filterd-Recvd-Size: 2215
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] usb: ftdi-elan: Fix format fragments
Date: Fri,  4 Apr 2014 15:16:03 -0700
Message-Id: <0c0769682b3eee3b02c0d85688c936c7c6103691.1396649386.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1396649386.git.joe@perches.com>
References: <cover.1396649386.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Breaking formats into fragments with a split
between % and field types should be coalesced.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/misc/ftdi-elan.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index a4a3c7c..314e597 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -729,8 +729,8 @@ static void ftdi_elan_write_bulk_callback(struct urb *urb)
 
 	if (status && !(status == -ENOENT || status == -ECONNRESET ||
 	    status == -ESHUTDOWN)) {
-                dev_err(&ftdi->udev->dev, "urb=%p write bulk status received: %"
-                        "d\n", urb, status);
+		dev_err(&ftdi->udev->dev,
+			"urb=%p write bulk status received: %d\n", urb, status);
         }
         usb_free_coherent(urb->dev, urb->transfer_buffer_length,
                 urb->transfer_buffer, urb->transfer_dma);
@@ -1181,8 +1181,8 @@ static ssize_t ftdi_elan_write(struct file *file,
         urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
         retval = usb_submit_urb(urb, GFP_KERNEL);
         if (retval) {
-                dev_err(&ftdi->udev->dev, "failed submitting write urb, error %"
-                        "d\n", retval);
+		dev_err(&ftdi->udev->dev,
+			"failed submitting write urb, error %d\n", retval);
                 goto error_3;
         }
         usb_free_urb(urb);
-- 
1.8.1.2.459.gbcd45b4.dirty

