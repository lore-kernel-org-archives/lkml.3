Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290Ab3DBXIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:08:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933214Ab3DBWMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ming Lei <tom.leiming@gmail.com>, Johan Hovold <jhovold@gmail.com>
Subject: [ 060/124] USB: serial: fix hang when opening port
Date: Tue,  2 Apr 2013 15:10:42 -0700
Message-Id: <20130402221111.143148005@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/serial/usb-serial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -897,6 +897,7 @@ static int usb_serial_probe(struct usb_i
 		port->port.ops = &serial_port_ops;
 		port->serial = serial;
 		spin_lock_init(&port->lock);
+		init_waitqueue_head(&port->delta_msr_wait);
 		/* Keep this for private driver use for the moment but
 		   should probably go away */
 		INIT_WORK(&port->work, usb_serial_port_work);


