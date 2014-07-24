Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934388AbaGXISa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 04:18:30 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:52587 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934120AbaGXISY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:18:24 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoJAFjA0FNXQzwl/2dsb2JhbABZgw6BKa8XAQEBAQEBBQFuAaA5AYEJF3eEBAEFJy8jEFE5HhmIRgHADheFe4lQBxaEMAWbM5RCg0o7Lw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, gregkh@linuxfoundation.org,
        Fabian Frederick <fabf@skynet.be>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org
Subject: [PATCH 05/10 linux-next] usb: gadget: remove unnecessary break after goto
Date: Thu, 24 Jul 2014 10:18:53 +0200
Message-Id: <1406189939-6433-6-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1406189939-6433-1-git-send-email-fabf@skynet.be>
References: <1406189939-6433-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/usb/gadget/function/f_hid.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index a95290a..21c4b9c 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -386,25 +386,21 @@ static int hidg_setup(struct usb_function *f,
 		memset(req->buf, 0x0, length);
 
 		goto respond;
-		break;
 
 	case ((USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8
 		  | HID_REQ_GET_PROTOCOL):
 		VDBG(cdev, "get_protocol\n");
 		goto stall;
-		break;
 
 	case ((USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8
 		  | HID_REQ_SET_REPORT):
 		VDBG(cdev, "set_report | wLenght=%d\n", ctrl->wLength);
 		goto stall;
-		break;
 
 	case ((USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8
 		  | HID_REQ_SET_PROTOCOL):
 		VDBG(cdev, "set_protocol\n");
 		goto stall;
-		break;
 
 	case ((USB_DIR_IN | USB_TYPE_STANDARD | USB_RECIP_INTERFACE) << 8
 		  | USB_REQ_GET_DESCRIPTOR):
@@ -415,20 +411,17 @@ static int hidg_setup(struct usb_function *f,
 						   hidg_desc.bLength);
 			memcpy(req->buf, &hidg_desc, length);
 			goto respond;
-			break;
 		case HID_DT_REPORT:
 			VDBG(cdev, "USB_REQ_GET_DESCRIPTOR: REPORT\n");
 			length = min_t(unsigned short, length,
 						   hidg->report_desc_length);
 			memcpy(req->buf, hidg->report_desc, length);
 			goto respond;
-			break;
 
 		default:
 			VDBG(cdev, "Unknown descriptor request 0x%x\n",
 				 value >> 8);
 			goto stall;
-			break;
 		}
 		break;
 
@@ -436,7 +429,6 @@ static int hidg_setup(struct usb_function *f,
 		VDBG(cdev, "Unknown request 0x%x\n",
 			 ctrl->bRequest);
 		goto stall;
-		break;
 	}
 
 stall:
-- 
1.8.4.5

