Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab3HBKPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:15:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030579Ab3HBKMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:12:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rong Wang <Rong.Wang@csr.com>, Barry Song <Baohua.Song@csr.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 89/99] usb: gadget: udc-core: fix the typo of udc state attribute
Date: Fri,  2 Aug 2013 18:08:42 +0800
Message-Id: <20130802100238.336195876@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Wang <Rong.Wang@csr.com>

commit 1894870eb4240399fabc6f0cb8c6fff4e6edbe83 upstream.

The name of udc state attribute file under sysfs is registered as
"state", while usb_gadget_set_state take it as "status" when it's
going to update. This patch fixes the typo.

Signed-off-by: Rong Wang <Rong.Wang@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -105,7 +105,7 @@ void usb_gadget_set_state(struct usb_gad
 		enum usb_device_state state)
 {
 	gadget->state = state;
-	sysfs_notify(&gadget->dev.kobj, NULL, "status");
+	sysfs_notify(&gadget->dev.kobj, NULL, "state");
 }
 EXPORT_SYMBOL_GPL(usb_gadget_set_state);
 


