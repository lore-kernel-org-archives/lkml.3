Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab3FERzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:55:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3FERzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:55:13 -0400
Date: Wed, 5 Jun 2013 10:55:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] USB: serial: increase the number of devices we support
Message-ID: <20130605175512.GC13461@kroah.com>
References: <20130605175426.GA13461@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130605175426.GA13461@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

We had the limit of 255 USB to serial devices on one system for almost
15 years, with no complaints.  But now it's time to move on from these
tiny "baby" systems, and bump the number up to 3000, which should last
us a few more years.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/usb-serial.c |    8 ++++++--
 include/linux/usb/serial.h      |    4 ----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -43,6 +43,10 @@
 #define DRIVER_AUTHOR "Greg Kroah-Hartman <gregkh@linuxfoundation.org>"
 #define DRIVER_DESC "USB Serial Driver core"
 
+#define SERIAL_TTY_MAJOR	188
+#define SERIAL_TTY_MINORS	3000	/* should be enough for a while */
+#define SERIAL_TTY_NO_MINOR	(SERIAL_TTY_MINORS + 1)
+
 /* There is no MODULE_DEVICE_TABLE for usbserial.c.  Instead
    the MODULE_DEVICE_TABLE declarations in each serial driver
    cause the "hotplug" program to pull in whatever module is necessary
@@ -105,12 +109,12 @@ static int get_free_serial(struct usb_se
 
 	dev_dbg(&serial->interface->dev, "%s %d\n", __func__, num_ports);
 
-	*minor = 0xffffffff;
+	*minor = SERIAL_TTY_NO_MINOR;
 	for (i = 0; i < num_ports; ++i) {
 		x = get_free_port(serial->port[i]);
 		if (x < 0)
 			goto error;
-		if (*minor == 0xffffffff)
+		if (*minor == SERIAL_TTY_NO_MINOR)
 			*minor = x;
 		serial->port[i]->port_number = i;
 	}
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -19,10 +19,6 @@
 #include <linux/sysrq.h>
 #include <linux/kfifo.h>
 
-#define SERIAL_TTY_MAJOR	188	/* Nice legal number now */
-#define SERIAL_TTY_MINORS	254	/* loads of devices :) */
-#define SERIAL_TTY_NO_MINOR	0xffffffff	/* No minor was assigned */
-
 /* The maximum number of ports one device can grab at once */
 #define MAX_NUM_PORTS		8
 
