Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaFEETt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:19:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaFEETo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:19:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Farina <sidhayn@gmail.com>, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.4 007/214] Revert "USB: serial: add usbid for dell wwan card to sierra.c"
Date: Wed,  4 Jun 2014 21:16:10 -0700
Message-Id: <20140605041640.712839423@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 2e01280d2801c72878cf3a7119eac30077b463d5 upstream.

This reverts commit 1ebca9dad5abe8b2ed4dbd186cd657fb47c1f321.

This device was erroneously added to the sierra driver even though it's
not a Sierra device and was already handled by the option driver.

Cc: Richard Farina <sidhayn@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/sierra.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -305,7 +305,6 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x0f3d, 0x68A3), 	/* Airprime/Sierra Wireless Direct IP modems */
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
-       { USB_DEVICE(0x413C, 0x08133) }, /* Dell Computer Corp. Wireless 5720 VZW Mobile Broadband (EVDO Rev-A) Minicard GPS Port */
 
 	{ }
 };


