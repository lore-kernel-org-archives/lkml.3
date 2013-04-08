Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935596Ab3DHJvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:51:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42722 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935522Ab3DHJvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ming Lei <tom.leiming@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 029/102] USB: serial: fix hang when opening port
Date: Mon,  8 Apr 2013 10:49:44 +0100
Message-Id: <1365414657-29191-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/usb-serial.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 2418551..fb09885 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -899,6 +899,7 @@ static int usb_serial_probe(struct usb_interface *interface,
 		port->port.ops = &serial_port_ops;
 		port->serial = serial;
 		spin_lock_init(&port->lock);
+		init_waitqueue_head(&port->delta_msr_wait);
 		/* Keep this for private driver use for the moment but
 		   should probably go away */
 		INIT_WORK(&port->work, usb_serial_port_work);
-- 
1.8.1.2

