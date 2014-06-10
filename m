Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbaFJUKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:10:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35390 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbaFJTwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:52:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniele Forsi <dforsi@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 145/160] usb: storage: shuttle_usbat: fix discs being detected twice
Date: Tue, 10 Jun 2014 12:46:25 -0700
Message-Id: <1402429600-20477-146-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

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
index 4ef2a80..008d805 100644
--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -1851,7 +1851,7 @@ static int usbat_probe(struct usb_interface *intf,
 	us->transport_name = "Shuttle USBAT";
 	us->transport = usbat_flash_transport;
 	us->transport_reset = usb_stor_CB_reset;
-	us->max_lun = 1;
+	us->max_lun = 0;
 
 	result = usb_stor_probe2(us);
 	return result;
-- 
1.9.1

