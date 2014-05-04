Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaEDPmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:42:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbaEDPmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 3.10 59/86] usb: gadget: zero: Fix SuperSpeed enumeration for alternate setting 1
Date: Sun,  4 May 2014 11:41:34 -0400
Message-Id: <20140504154148.461471187@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/zero.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/zero.c
+++ b/drivers/usb/gadget/zero.c
@@ -280,7 +280,7 @@ static int __init zero_bind(struct usb_c
 	ss_opts->isoc_interval = gzero_options.isoc_interval;
 	ss_opts->isoc_maxpacket = gzero_options.isoc_maxpacket;
 	ss_opts->isoc_mult = gzero_options.isoc_mult;
-	ss_opts->isoc_maxburst = gzero_options.isoc_maxpacket;
+	ss_opts->isoc_maxburst = gzero_options.isoc_maxburst;
 	ss_opts->bulk_buflen = gzero_options.bulk_buflen;
 
 	func_ss = usb_get_function(func_inst_ss);


