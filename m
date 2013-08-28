Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab3H1Xga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 19:36:30 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1998 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab3H1Xg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 19:36:29 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Graham Williams" <gwilli@broadcom.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Felipe Balbi" <balbi@ti.com>
cc: "Graham Williams" <gwilli@broadcom.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: acm gadget: Null termintate strings table
Date: Wed, 28 Aug 2013 16:36:14 -0700
Message-ID: <1377732974-10073-1-git-send-email-gwilli@broadcom.com>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
X-WSS-ID: 7E0058812L879189710-02-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gadget strings table should be null terminated.
usb_gadget_get_string() loops through the table
expecting a null at the end of the list.

Signed-off-by: Graham Williams <gwilli@broadcom.com>
---
 drivers/usb/gadget/f_acm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/f_acm.c b/drivers/usb/gadget/f_acm.c
index 4b7e33e..ab1065a 100644
--- a/drivers/usb/gadget/f_acm.c
+++ b/drivers/usb/gadget/f_acm.c
@@ -285,6 +285,7 @@ static struct usb_string acm_string_defs[] = {
 	[ACM_CTRL_IDX].s = "CDC Abstract Control Model (ACM)",
 	[ACM_DATA_IDX].s = "CDC ACM Data",
 	[ACM_IAD_IDX ].s = "CDC Serial",
+	{  } /* end of list */
 };
 
 static struct usb_gadget_strings acm_string_table = {
-- 
1.8.0.1


