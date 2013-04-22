Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab3DVOyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:54:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51362 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010Ab3DVO3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:14 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <jhovold@gmail.com>, "Ming Lei" <tom.leiming@gmail.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.693995059@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [02/75] USB: serial: fix hang when opening port
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/usb-serial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -905,6 +905,7 @@ int usb_serial_probe(struct usb_interfac
 		port->port.ops = &serial_port_ops;
 		port->serial = serial;
 		spin_lock_init(&port->lock);
+		init_waitqueue_head(&port->delta_msr_wait);
 		/* Keep this for private driver use for the moment but
 		   should probably go away */
 		INIT_WORK(&port->work, usb_serial_port_work);

