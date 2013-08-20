Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab3HTPRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:17:45 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3287 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab3HTPRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:17:44 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Graham Williams" <gwilli@broadcom.com>
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] usb: acm gadget: Null termintate strings table
Thread-Topic: [PATCH] usb: acm gadget: Null termintate strings table
Thread-Index: Ac6duEwifWTJ4zn7RoOxb6qb5Az/Qg==
Date: Tue, 20 Aug 2013 15:17:37 +0000
Message-ID: <063828A851006E448B735F1021E028962ACE2FE9@SJEXCHMB09.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7E0D59B82L876133803-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gadget strings table should be null terminated.
usb_gadget_get_string() loops through the table
expecting a null at the end of the list.

Signed-off-by: Graham <gwilli@broadcom.com>
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
+       {  } /* end of list */
 };

 static struct usb_gadget_strings acm_string_table = {
--
1.8.0.1

