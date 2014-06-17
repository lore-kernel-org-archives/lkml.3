Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965785AbaFQRDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:03:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50368 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933621AbaFQQPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:15:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Farina <sidhayn@gmail.com>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 012/121] Revert "USB: serial: add usbid for dell wwan card to sierra.c"
Date: Tue, 17 Jun 2014 09:13:25 -0700
Message-Id: <1403021714-16320-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021714-16320-1-git-send-email-kamal@canonical.com>
References: <1403021714-16320-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 2e01280d2801c72878cf3a7119eac30077b463d5 upstream.

This reverts commit 1ebca9dad5abe8b2ed4dbd186cd657fb47c1f321.

This device was erroneously added to the sierra driver even though it's
not a Sierra device and was already handled by the option driver.

Cc: Richard Farina <sidhayn@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/sierra.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index d4426c0..380d571 100644
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
1.9.1

