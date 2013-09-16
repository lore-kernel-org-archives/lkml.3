Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab3IPVYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 17:24:55 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4993 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab3IPVYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 17:24:54 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Peter Oh" <poh@broadcom.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Felipe Balbi" <balbi@ti.com>
cc: "Peter Oh" <poh@broadcom.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: reset endpoint driver data when disabled
Date: Mon, 16 Sep 2013 14:21:14 -0700
Message-ID: <1379366474-10489-1-git-send-email-poh@broadcom.com>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
X-WSS-ID: 7E29A9BA0UO7817947-20-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gadgets endpoint driver data is a criteria to judge that
whether the endpoints are in use or not. When gadget gets
assigned an endpoint from endpoint list, they check its
driver data if the driver data is NULL.
If the driver data is not NULL then they regard it as in use.
Therefore all of gadgets should reset their endpoints driver
data to NULL as they are disabled. Otherwise it causes a leak
of endpoint resource.

Signed-off-by: Peter Oh <poh@broadcom.com>
---
 drivers/usb/gadget/f_mass_storage.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 313b835..a01d7d3 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2260,10 +2260,12 @@ reset:
 		/* Disable the endpoints */
 		if (fsg->bulk_in_enabled) {
 			usb_ep_disable(fsg->bulk_in);
+			fsg->bulk_in->driver_data = NULL;
 			fsg->bulk_in_enabled = 0;
 		}
 		if (fsg->bulk_out_enabled) {
 			usb_ep_disable(fsg->bulk_out);
+			fsg->bulk_out->driver_data = NULL;
 			fsg->bulk_out_enabled = 0;
 		}
 
-- 
1.8.0.1


