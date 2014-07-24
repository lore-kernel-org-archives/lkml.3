Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934492AbaGXIWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 04:22:11 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:17892 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934304AbaGXISU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:18:20 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoJAFjA0FNXQzwl/2dsb2JhbABZgw6BKa8XAQEBAQEBBQFuAaA5AYEJF3eEBAEFJy8jEFE5HhmIRgHADheFe4lQBxaEMAWbM5RCg0o7Lw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, gregkh@linuxfoundation.org,
        Fabian Frederick <fabf@skynet.be>, linux-usb@vger.kernel.org
Subject: [PATCH 01/10 linux-next] USB: iowarrior: remove unnecessary break after goto
Date: Thu, 24 Jul 2014 10:18:49 +0200
Message-Id: <1406189939-6433-2-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1406189939-6433-1-git-send-email-fabf@skynet.be>
References: <1406189939-6433-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/usb/misc/iowarrior.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index c6bfd13..17ce9a4 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -381,7 +381,6 @@ static ssize_t iowarrior_write(struct file *file,
 		retval = usb_set_report(dev->interface, 2, 0, buf, count);
 		kfree(buf);
 		goto exit;
-		break;
 	case USB_DEVICE_ID_CODEMERCS_IOW56:
 		/* The IOW56 uses asynchronous IO and more urbs */
 		if (atomic_read(&dev->write_busy) == MAX_WRITES_IN_FLIGHT) {
@@ -447,14 +446,12 @@ static ssize_t iowarrior_write(struct file *file,
 		retval = count;
 		usb_free_urb(int_out_urb);
 		goto exit;
-		break;
 	default:
 		/* what do we have here ? An unsupported Product-ID ? */
 		dev_err(&dev->interface->dev, "%s - not supported for product=0x%x\n",
 			__func__, dev->product_id);
 		retval = -EFAULT;
 		goto exit;
-		break;
 	}
 error:
 	usb_free_coherent(dev->udev, dev->report_size, buf,
-- 
1.8.4.5

