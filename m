Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaLOPDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:03:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38478 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbaLOO1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 060/168] Bluetooth: Ignore isochronous endpoints for Intel USB bootloader
Date: Mon, 15 Dec 2014 14:25:14 +0000
Message-Id: <1418653622-21105-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcel Holtmann <marcel@holtmann.org>

commit d92f2df0565ea04101d6ac04bdc10feeb1d93c94 upstream.

The isochronous endpoints are not valid when the Intel Bluetooth
controller boots up in bootloader mode. So just mark these endpoints
as broken and then they will not be configured.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/bluetooth/btusb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 9c63e20a46a4..72fd005c053d 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -123,7 +123,8 @@ static const struct usb_device_id btusb_table[] = {
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x13d3, 0xff, 0x01, 0x01) },
 
 	/* Intel Bluetooth USB Bootloader (RAM module) */
-	{ USB_DEVICE(0x8087, 0x0a5a), .driver_info = BTUSB_INTEL_BOOT },
+	{ USB_DEVICE(0x8087, 0x0a5a),
+	  .driver_info = BTUSB_INTEL_BOOT | BTUSB_BROKEN_ISOC },
 
 	{ }	/* Terminating entry */
 };
-- 
2.1.3

