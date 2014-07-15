Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551AbaGOXNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:13:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758393AbaGOXNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:13:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bert Vermeulen <bert@biot.com>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.4 03/22] USB: ftdi_sio: Add extra PID.
Date: Tue, 15 Jul 2014 16:17:08 -0700
Message-Id: <20140715231622.223426693@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231622.121816073@linuxfoundation.org>
References: <20140715231622.121816073@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bert Vermeulen <bert@biot.com>

commit 5a7fbe7e9ea0b1b9d7ffdba64db1faa3a259164c upstream.

This patch adds PID 0x0003 to the VID 0x128d (Testo). At least the
Testo 435-4 uses this, likely other gear as well.

Signed-off-by: Bert Vermeulen <bert@biot.com>
Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    3 ++-
 drivers/usb/serial/ftdi_sio_ids.h |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -731,7 +731,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_ACG_HFDUAL_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_YEI_SERVOCENTER31_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_THORLABS_PID) },
-	{ USB_DEVICE(TESTO_VID, TESTO_USB_INTERFACE_PID) },
+	{ USB_DEVICE(TESTO_VID, TESTO_1_PID) },
+	{ USB_DEVICE(TESTO_VID, TESTO_3_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_GAMMA_SCOUT_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_TACTRIX_OPENPORT_13M_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_TACTRIX_OPENPORT_13S_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -798,7 +798,8 @@
  * Submitted by Colin Leroy
  */
 #define TESTO_VID			0x128D
-#define TESTO_USB_INTERFACE_PID		0x0001
+#define TESTO_1_PID			0x0001
+#define TESTO_3_PID			0x0003
 
 /*
  * Mobility Electronics products.


