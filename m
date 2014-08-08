Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbaHHUxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:53:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41320 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933086AbaHHUxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:53:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bert Vermeulen <bert@biot.com>, Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 089/259] USB: ftdi_sio: Add extra PID.
Date: Fri,  8 Aug 2014 13:38:32 -0700
Message-Id: <1407530482-4483-90-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bert Vermeulen <bert@biot.com>

commit 5a7fbe7e9ea0b1b9d7ffdba64db1faa3a259164c upstream.

This patch adds PID 0x0003 to the VID 0x128d (Testo). At least the
Testo 435-4 uses this, likely other gear as well.

Signed-off-by: Bert Vermeulen <bert@biot.com>
Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     | 3 ++-
 drivers/usb/serial/ftdi_sio_ids.h | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 244c00f..2a077ea 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -721,7 +721,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_ACG_HFDUAL_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_YEI_SERVOCENTER31_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_THORLABS_PID) },
-	{ USB_DEVICE(TESTO_VID, TESTO_USB_INTERFACE_PID) },
+	{ USB_DEVICE(TESTO_VID, TESTO_1_PID) },
+	{ USB_DEVICE(TESTO_VID, TESTO_3_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_GAMMA_SCOUT_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_TACTRIX_OPENPORT_13M_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_TACTRIX_OPENPORT_13S_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 500474c..106cc16 100644
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
-- 
1.9.1

