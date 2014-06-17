Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159AbaFQQZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:25:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50854 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933848AbaFQQZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:25:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniele Forsi <dforsi@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 113/121] usb: storage: shuttle_usbat: fix discs being detected twice
Date: Tue, 17 Jun 2014 09:18:11 -0700
Message-Id: <1403021899-16708-86-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Forsi <dforsi@gmail.com>

commit df602c2d2358f02c6e49cffc5b49b9daa16db033 upstream.

Even if the USB-to-ATAPI converter supported multiple LUNs, this
driver would always detect the same physical device or media because
it doesn't use srb->device->lun in any way.
Tested with an Hewlett-Packard CD-Writer Plus 8200e.

Signed-off-by: Daniele Forsi <dforsi@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/storage/shuttle_usbat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/shuttle_usbat.c b/drivers/usb/storage/shuttle_usbat.c
index daf2fc5..f714816 100644
--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -1846,7 +1846,7 @@ static int usbat_probe(struct usb_interface *intf,
 	us->transport_name = "Shuttle USBAT";
 	us->transport = usbat_flash_transport;
 	us->transport_reset = usb_stor_CB_reset;
-	us->max_lun = 1;
+	us->max_lun = 0;
 
 	result = usb_stor_probe2(us);
 	return result;
-- 
1.9.1

