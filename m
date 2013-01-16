Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab3APQAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:00:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35872 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab3APQAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:00:37 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Teichmann <lkb.teichmann@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 050/222] USB: ftdi_sio: Add support for Newport AGILIS motor drivers
Date: Wed, 16 Jan 2013 13:54:10 -0200
Message-Id: <1358351822-7675-51-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Teichmann <lkb.teichmann@gmail.com>

commit d7e14b375b40c04cd735b115713043b69a2c68ac upstream.

The Newport AGILIS model AG-UC8 compact piezo motor controller
(http://search.newport.com/?q=*&x2=sku&q2=AG-UC8)
is yet another device using an FTDI USB-to-serial chip. It works
fine with the ftdi_sio driver when adding

  options ftdi-sio product=0x3000 vendor=0x104d

to modprobe.d. udevadm reports "Newport" as the manufacturer,
and "Agilis" as the product name.

Signed-off-by: Martin Teichmann <lkb.teichmann@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index d0b8c5c..360bdeb 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -197,6 +197,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_THROTTLE_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GATEWAY_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_PID) },
+	{ USB_DEVICE(NEWPORT_VID, NEWPORT_AGILIS_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 57c12ef..049b6e7 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -752,6 +752,12 @@
 #define TTI_VID			0x103E	/* Vendor Id */
 #define TTI_QL355P_PID		0x03E8	/* TTi QL355P power supply */
 
+/*
+ * Newport Cooperation (www.newport.com)
+ */
+#define NEWPORT_VID			0x104D
+#define NEWPORT_AGILIS_PID		0x3000
+
 /* Interbiometrics USB I/O Board */
 /* Developed for Interbiometrics by Rudolf Gugler */
 #define INTERBIOMETRICS_VID              0x1209
-- 
1.7.9.5

