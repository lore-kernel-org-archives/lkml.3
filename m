Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbaKRPTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:19:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882AbaKROJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 025/206] Bluetooth: Ignore isochronous endpoints for Intel USB bootloader
Date: Tue, 18 Nov 2014 15:06:20 +0100
Message-Id: <330550885226357a59f017474091cbc45e529b10.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d92f2df0565ea04101d6ac04bdc10feeb1d93c94 upstream.

The isochronous endpoints are not valid when the Intel Bluetooth
controller boots up in bootloader mode. So just mark these endpoints
as broken and then they will not be configured.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/bluetooth/btusb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 27dd68362639..43e8b2a4ec5b 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -121,7 +121,8 @@ static struct usb_device_id btusb_table[] = {
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x13d3, 0xff, 0x01, 0x01) },
 
 	/* Intel Bluetooth USB Bootloader (RAM module) */
-	{ USB_DEVICE(0x8087, 0x0a5a), .driver_info = BTUSB_INTEL_BOOT },
+	{ USB_DEVICE(0x8087, 0x0a5a),
+	  .driver_info = BTUSB_INTEL_BOOT | BTUSB_BROKEN_ISOC },
 
 	{ }	/* Terminating entry */
 };
-- 
2.1.3

