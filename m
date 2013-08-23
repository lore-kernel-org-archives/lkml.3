Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab3HWRv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:51:26 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3882 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765Ab3HWRvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:51:24 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Graham Williams" <gwilli@broadcom.com>
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: "balbi@ti.com" <balbi@ti.com>
Subject: [PATCH] usb: acm gadget: Null termintate strings table
Thread-Topic: [PATCH] usb: acm gadget: Null termintate strings table
Thread-Index: Ac6gKUihEwnOQOzhRHCsjyOVBTkXDQ==
Date: Fri, 23 Aug 2013 17:51:12 +0000
Message-ID: <063828A851006E448B735F1021E028962ACE72A6@SJEXCHMB09.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7E097FAD31W87368762-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
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
+       {  } /* end of list */
};

static struct usb_gadget_strings acm_string_table = {
--
1.8.0.1


