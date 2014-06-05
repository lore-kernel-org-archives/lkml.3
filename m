Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbaFEFEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 01:04:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaFEEU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniele Forsi <dforsi@gmail.com>
Subject: [PATCH 3.4 053/214] usb: storage: shuttle_usbat: fix discs being detected twice
Date: Wed,  4 Jun 2014 21:16:56 -0700
Message-Id: <20140605041646.579703815@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Forsi <dforsi@gmail.com>

commit df602c2d2358f02c6e49cffc5b49b9daa16db033 upstream.

Even if the USB-to-ATAPI converter supported multiple LUNs, this
driver would always detect the same physical device or media because
it doesn't use srb->device->lun in any way.
Tested with an Hewlett-Packard CD-Writer Plus 8200e.

Signed-off-by: Daniele Forsi <dforsi@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/shuttle_usbat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -1846,7 +1846,7 @@ static int usbat_probe(struct usb_interf
 	us->transport_name = "Shuttle USBAT";
 	us->transport = usbat_flash_transport;
 	us->transport_reset = usb_stor_CB_reset;
-	us->max_lun = 1;
+	us->max_lun = 0;
 
 	result = usb_stor_probe2(us);
 	return result;


