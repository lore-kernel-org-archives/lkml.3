Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967786Ab3HICSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:18:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967492Ab3HIB6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 029/102] USB: mos7840: fix pointer casts
Date: Thu,  8 Aug 2013 18:57:05 -0700
Message-Id: <20130809015016.684644718@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 683a0e4d7971c3186dc4d429027debfe309129aa upstream.

Silence compiler warnings on 64-bit systems introduced by commit
05cf0dec ("USB: mos7840: fix race in led handling") which uses the
usb-serial data pointer to temporarily store the device type during
probe but failed to add the required casts.

[gregkh - change uintptr_t to unsigned long]

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7840.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2236,14 +2236,14 @@ static int mos7840_probe(struct usb_seri
 
 	kfree(buf);
 out:
-	usb_set_serial_data(serial, (void *)device_type);
+	usb_set_serial_data(serial, (void *)(unsigned long)device_type);
 
 	return 0;
 }
 
 static int mos7840_calc_num_ports(struct usb_serial *serial)
 {
-	int device_type = (int)usb_get_serial_data(serial);
+	int device_type = (unsigned long)usb_get_serial_data(serial);
 	int mos7840_num_ports;
 
 	mos7840_num_ports = (device_type >> 4) & 0x000F;
@@ -2254,7 +2254,7 @@ static int mos7840_calc_num_ports(struct
 static int mos7840_port_probe(struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
-	int device_type = (int)usb_get_serial_data(serial);
+	int device_type = (unsigned long)usb_get_serial_data(serial);
 	struct moschip_port *mos7840_port;
 	int status;
 	int pnum;


