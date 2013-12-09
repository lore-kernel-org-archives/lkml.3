Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab3LITSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:18:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54506 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483Ab3LITS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:18:29 -0500
Message-ID: <52A61781.6070708@infradead.org>
Date: Mon, 09 Dec 2013 11:18:25 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: USB list <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH] gadget: make USB_CONFIGFS_MASS_STORAGE depend on BLOCK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Make USB_CONFIGFS_MASS_STORAGE depend on BLOCK just like the other
gadget MASS_STORAGE options do.  This fixes the following build errors
that occur when BLOCK is not enabled:

drivers/usb/gadget/storage_common.c: In function 'fsg_lun_open':
drivers/usb/gadget/storage_common.c:241:3: error: implicit declaration of function 'bdev_logical_block_size' [-Werror=implicit-function-declaration]
drivers/usb/gadget/storage_common.c:242:3: error: implicit declaration of function 'blksize_bits' [-Werror=implicit-function-declaration]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/gadget/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-313-rc3.orig/drivers/usb/gadget/Kconfig
+++ lnx-313-rc3/drivers/usb/gadget/Kconfig
@@ -681,7 +681,7 @@ config USB_CONFIGFS_PHONET
 
 config USB_CONFIGFS_MASS_STORAGE
 	boolean "Mass storage"
-	depends on USB_CONFIGFS
+	depends on USB_CONFIGFS && BLOCK
 	select USB_F_MASS_STORAGE
 	help
 	  The Mass Storage Gadget acts as a USB Mass Storage disk drive.
