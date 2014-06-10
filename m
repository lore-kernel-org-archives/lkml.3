Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaFJTww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:52:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35435 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314AbaFJTwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:52:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roger Quadros <rogerq@ti.com>, Felipe Balbi <balbi@ti.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 064/160] usb: gadget: zero: Fix SuperSpeed enumeration for alternate setting 1
Date: Tue, 10 Jun 2014 12:45:04 -0700
Message-Id: <1402429600-20477-65-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/gadget/zero.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/zero.c b/drivers/usb/gadget/zero.c
index f49b0b6..10c048e 100644
--- a/drivers/usb/gadget/zero.c
+++ b/drivers/usb/gadget/zero.c
@@ -300,7 +300,7 @@ static int __init zero_bind(struct usb_composite_dev *cdev)
 	ss_opts->isoc_interval = gzero_options.isoc_interval;
 	ss_opts->isoc_maxpacket = gzero_options.isoc_maxpacket;
 	ss_opts->isoc_mult = gzero_options.isoc_mult;
-	ss_opts->isoc_maxburst = gzero_options.isoc_maxpacket;
+	ss_opts->isoc_maxburst = gzero_options.isoc_maxburst;
 	ss_opts->bulk_buflen = gzero_options.bulk_buflen;
 
 	func_ss = usb_get_function(func_inst_ss);
-- 
1.9.1

