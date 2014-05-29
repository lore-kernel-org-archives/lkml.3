Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935076AbaE2OP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:15:57 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59354 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933213AbaE2Ntb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Richard Farina <sidhayn@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 041/103] Revert "USB: serial: add usbid for dell wwan card to sierra.c"
Date: Thu, 29 May 2014 15:48:26 +0200
Message-Id: <8e3e396462c30221a7ed37cdcf065ecf585c310d.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2e01280d2801c72878cf3a7119eac30077b463d5 upstream.

This reverts commit 1ebca9dad5abe8b2ed4dbd186cd657fb47c1f321.

This device was erroneously added to the sierra driver even though it's
not a Sierra device and was already handled by the option driver.

Cc: Richard Farina <sidhayn@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/sierra.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index de958c5b52e3..b6910b7ab7e2 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -291,7 +291,6 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x0f3d, 0x68A3), 	/* Airprime/Sierra Wireless Direct IP modems */
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
-       { USB_DEVICE(0x413C, 0x08133) }, /* Dell Computer Corp. Wireless 5720 VZW Mobile Broadband (EVDO Rev-A) Minicard GPS Port */
 
 	{ }
 };
-- 
1.9.3

