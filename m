Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaKAWku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:40:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60357 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856AbaKAWje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:34 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Taylor Braun-Jones" <taylor.braun-jones@ge.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <johan@kernel.org>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.41928806@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 031/102] USB: ftdi_sio: Add support for GE Healthcare
 Nemo Tracker device
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Taylor Braun-Jones <taylor.braun-jones@ge.com>

commit 9c491c372d677b6420e0f8c6361fe422791662cc upstream.

Signed-off-by: Taylor Braun-Jones <taylor.braun-jones@ge.com>
Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -962,6 +962,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_4_PID) },
 	/* ekey Devices */
 	{ USB_DEVICE(FTDI_VID, FTDI_EKEY_CONV_USB_PID) },
+	/* GE Healthcare devices */
+	{ USB_DEVICE(GE_HEALTHCARE_VID, GE_HEALTHCARE_NEMO_TRACKER_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1385,3 +1385,9 @@
  * ekey biometric systems GmbH (http://ekey.net/)
  */
 #define FTDI_EKEY_CONV_USB_PID		0xCB08	/* Converter USB */
+
+/*
+ * GE Healthcare devices
+ */
+#define GE_HEALTHCARE_VID		0x1901
+#define GE_HEALTHCARE_NEMO_TRACKER_PID	0x0015

