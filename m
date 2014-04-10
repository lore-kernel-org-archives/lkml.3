Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965310AbaDJEKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:10:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934603AbaDJDWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ming Lei <tom.leiming@gmail.com>, Johan Hovold <jhovold@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 072/134] USB: serial: fix hang when opening port
Date: Wed,  9 Apr 2014 20:23:08 -0700
Message-Id: <20140410032309.273033271@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <tom.leiming@gmail.com>

commit eba0e3c3a0ba7b96f01cbe997680f6a4401a0bfc upstream.

Johan's 'fix use-after-free in TIOCMIWAIT' patchset[1] introduces
one bug which can cause kernel hang when opening port.

This patch initialized the 'port->delta_msr_wait' waitqueue head
to fix the bug which is introduced in 3.9-rc4.

[1], http://marc.info/?l=linux-usb&m=136368139627876&w=2

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Acked-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/usb-serial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -908,6 +908,7 @@ int usb_serial_probe(struct usb_interfac
 		port->port.ops = &serial_port_ops;
 		port->serial = serial;
 		spin_lock_init(&port->lock);
+		init_waitqueue_head(&port->delta_msr_wait);
 		/* Keep this for private driver use for the moment but
 		   should probably go away */
 		INIT_WORK(&port->work, usb_serial_port_work);


