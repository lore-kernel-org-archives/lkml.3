Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbaEMJpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:45:38 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60857 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760090AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        Felipe Balbi <balbi@ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 082/182] usb: gadget: zero: Fix SuperSpeed enumeration for alternate setting 1
Date: Tue, 13 May 2014 11:27:14 +0200
Message-Id: <c2ea5fba0fa6fb788a837cd42921384132c5db04.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9c1b70361e0b38e4acb8e62b54da66538cb77ff2 upstream.

It was impossible to enumerate on a SuperSpeed (XHCI) host
with alternate setting = 1 due to the wrongly set 'bMaxBurst'
field in the SuperSpeed Endpoint Companion descriptor.

Testcase:
<host> modprobe -r usbtest; modprobe usbtest alt=1
<device> modprobe g_zero
plug device to SuperSpeed port on the host.

Without this patch the host always complains like so
"usb 12-2: Not enough bandwidth for new device state.
 usb 12-2: Not enough bandwidth for altsetting 1"

Bug was introduced by commit cf9a08ae in v3.9

Fixes: cf9a08ae5aec (usb: gadget: convert source sink and loopback to
new function interface)

Reviewed-by: Felipe Balbi <balbi@ti.com>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/gadget/zero.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/zero.c b/drivers/usb/gadget/zero.c
index 0deb9d6cde26..d31814c7238f 100644
--- a/drivers/usb/gadget/zero.c
+++ b/drivers/usb/gadget/zero.c
@@ -280,7 +280,7 @@ static int __init zero_bind(struct usb_composite_dev *cdev)
 	ss_opts->isoc_interval = gzero_options.isoc_interval;
 	ss_opts->isoc_maxpacket = gzero_options.isoc_maxpacket;
 	ss_opts->isoc_mult = gzero_options.isoc_mult;
-	ss_opts->isoc_maxburst = gzero_options.isoc_maxpacket;
+	ss_opts->isoc_maxburst = gzero_options.isoc_maxburst;
 	ss_opts->bulk_buflen = gzero_options.bulk_buflen;
 
 	func_ss = usb_get_function(func_inst_ss);
-- 
1.9.3

