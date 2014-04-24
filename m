Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbaDXJOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:14:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47075 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaDXI4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:56:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Farina <sidhayn@gmail.com>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 162/182] Revert "USB: serial: add usbid for dell wwan card to sierra.c"
Date: Thu, 24 Apr 2014 09:51:27 +0100
Message-Id: <1398329507-5911-163-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 2e01280d2801c72878cf3a7119eac30077b463d5 upstream.

This reverts commit 1ebca9dad5abe8b2ed4dbd186cd657fb47c1f321.

This device was erroneously added to the sierra driver even though it's
not a Sierra device and was already handled by the option driver.

Cc: Richard Farina <sidhayn@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/sierra.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index de958c5..b6910b7 100644
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

