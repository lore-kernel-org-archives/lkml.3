Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbaAGRzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:55:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37703 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbaAGRzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:55:43 -0500
Message-ID: <52CC3F9C.8090407@infradead.org>
Date: Tue, 07 Jan 2014 09:55:40 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Luca Risolia <luca.risolia@studio.unibo.it>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media <linux-media@vger.kernel.org>
Subject: [PATCH -next] staging/media: fix sn9c102 dependencies
References: <20140107173816.003dc67433cea097c097eb74@canb.auug.org.au>
In-Reply-To: <20140107173816.003dc67433cea097c097eb74@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix numerous build errors when USB is not enabled.  Examples:

drivers/built-in.o: In function `sn9c102_stop_transfer':
sn9c102_core.c:(.text+0xccbd0a): undefined reference to `usb_kill_urb'
sn9c102_core.c:(.text+0xccbd15): undefined reference to `usb_free_urb'
sn9c102_core.c:(.text+0xccbd4c): undefined reference to `usb_set_interface'
drivers/built-in.o: In function `sn9c102_urb_complete':
sn9c102_core.c:(.text+0xccdca5): undefined reference to `usb_submit_urb'
drivers/built-in.o: In function `sn9c102_release_resources':
sn9c102_core.c:(.text+0xcce62b): undefined reference to `usb_put_dev'
drivers/built-in.o: In function `sn9c102_match_id':
(.text+0xcce9d7): undefined reference to `usb_ifnum_to_if'
drivers/built-in.o: In function `sn9c102_match_id':
(.text+0xcce9de): undefined reference to `usb_match_id'
drivers/built-in.o: In function `sn9c102_write_regs':
(.text+0xccea7a): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `sn9c102_open':
sn9c102_core.c:(.text+0xcd17b4): undefined reference to `usb_altnum_to_altsetting'
sn9c102_core.c:(.text+0xcd1851): undefined reference to `usb_alloc_urb'
drivers/built-in.o: In function `sn9c102_read_reg':
(.text+0xcd1fdf): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `sn9c102_usb_probe':
sn9c102_core.c:(.text+0xcd275d): undefined reference to `usb_get_dev'
drivers/built-in.o: In function `sn9c102_usb_driver_init':
sn9c102_core.c:(.init.text+0x3e4eb): undefined reference to `usb_register_driver'
drivers/built-in.o: In function `sn9c102_usb_driver_exit':
sn9c102_core.c:(.exit.text+0x7226): undefined reference to `usb_deregister'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Luca Risolia <luca.risolia@studio.unibo.it>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/staging/media/sn9c102/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20140107.orig/drivers/staging/media/sn9c102/Kconfig
+++ linux-next-20140107/drivers/staging/media/sn9c102/Kconfig
@@ -1,6 +1,6 @@
 config USB_SN9C102
 	tristate "USB SN9C1xx PC Camera Controller support (DEPRECATED)"
-	depends on VIDEO_V4L2
+	depends on VIDEO_V4L2 && USB
 	---help---
 	  This driver is DEPRECATED, please use the gspca sonixb and
 	  sonixj modules instead.
