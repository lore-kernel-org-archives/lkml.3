Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab3LQLrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 06:47:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:38510 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab3LQLru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 06:47:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,501,1384329600"; 
   d="scan'208,223";a="453562445"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] usb/gadget: should use u16 type variable to store MaxPower
Thread-Topic: [PATCH] usb/gadget: should use u16 type variable to store
 MaxPower
Thread-Index: Ac77HaASzkUEUvjTSnG27++wi7REow==
Date: Tue, 17 Dec 2013 11:47:42 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A01A2B920@SHSMSX103.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7e827a0d300e084f74c65122baa5e3193f9a7f18 Mon Sep 17 00:00:00 2001
From: "Du, Changbin" <changbinx.du@intel.com>
Date: Mon, 16 Dec 2013 20:32:13 +0800
Subject: [PATCH] usb/gadget: should use u16 type variable to store MaxPower

The MaxPower field is of u16 type. So using u8 type variable can break
data (high byte lost).

Signed-off-by: Du, Changbin <changbinx.du@intel.com>
---
 drivers/usb/gadget/composite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 2018ba1..8a34173 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1714,7 +1714,7 @@ composite_resume(struct usb_gadget *gadget)
 {
 	struct usb_composite_dev	*cdev = get_gadget_data(gadget);
 	struct usb_function		*f;
-	u8				maxpower;
+	u16				maxpower;
 
 	/* REVISIT:  should we have config level
 	 * suspend/resume callbacks?
-- 
1.8.3.2
