Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab3IEU2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:28:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111Ab3IEU2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Graham Williams <gwilli@broadcom.com>
Subject: [ 30/36] usb: acm gadget: Null termintate strings table
Date: Thu,  5 Sep 2013 13:27:59 -0700
Message-Id: <20130905202705.836291109@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202702.289738686@linuxfoundation.org>
References: <20130905202702.289738686@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Graham Williams <gwilli@broadcom.com>

commit d257221854f0b34cca3247e6c45344d0470f7398 upstream.

The gadget strings table should be null terminated.
usb_gadget_get_string() loops through the table
expecting a null at the end of the list.

Signed-off-by: Graham Williams <gwilli@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/f_acm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/f_acm.c
+++ b/drivers/usb/gadget/f_acm.c
@@ -285,6 +285,7 @@ static struct usb_string acm_string_defs
 	[ACM_CTRL_IDX].s = "CDC Abstract Control Model (ACM)",
 	[ACM_DATA_IDX].s = "CDC ACM Data",
 	[ACM_IAD_IDX ].s = "CDC Serial",
+	{  } /* end of list */
 };
 
 static struct usb_gadget_strings acm_string_table = {


