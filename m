Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934453AbaGXIUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 04:20:36 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:17892 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934313AbaGXISV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:18:21 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoJAFjA0FNXQzwl/2dsb2JhbABZgw6BKa8XAQEBAQEBBQFuAaA5AYEJF3eEBAEFJy8jEFE5HhmIRgHADheFe4lQBxaEMAWbM5RCg0o7Lw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, gregkh@linuxfoundation.org,
        Fabian Frederick <fabf@skynet.be>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org
Subject: [PATCH 04/10 linux-next] usb: gadget: remove unnecessary break after return
Date: Thu, 24 Jul 2014 10:18:52 +0200
Message-Id: <1406189939-6433-5-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1406189939-6433-1-git-send-email-fabf@skynet.be>
References: <1406189939-6433-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/usb/gadget/legacy/tcm_usb_gadget.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/gadget/legacy/tcm_usb_gadget.c b/drivers/usb/gadget/legacy/tcm_usb_gadget.c
index 6cdb7a5..fb7cbb4 100644
--- a/drivers/usb/gadget/legacy/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/legacy/tcm_usb_gadget.c
@@ -465,13 +465,11 @@ static int usbg_bot_setup(struct usb_function *f,
 		*ret_lun = luns;
 		cdev->req->length = 1;
 		return usb_ep_queue(cdev->gadget->ep0, cdev->req, GFP_ATOMIC);
-		break;
 
 	case US_BULK_RESET_REQUEST:
 		/* XXX maybe we should remove previous requests for IN + OUT */
 		bot_enqueue_cmd_cbw(fu);
 		return 0;
-		break;
 	}
 	return -ENOTSUPP;
 }
-- 
1.8.4.5

