Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751008AbaKYIsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 03:48:08 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:51835 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaKYIsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 03:48:06 -0500
Message-ID: <54744242.8050209@gmail.com>
Date: Tue, 25 Nov 2014 11:48:02 +0300
From: Dmitry Tunin <hanipouspilot@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH v5] ath3k: Add support of MCI 13d3:3408 bt device
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for bluetooth MCI WB335 (AR9565) Wi-Fi+bt module.
This bluetooth module requires loading patch and sysconfig by ath3k driver.

CC: stable@vger.kernel.org
Signed-off-by: Dmitry Tunin <hanipouspilot@gmail.com>

---

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index d85ced2..086240c 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -105,6 +105,7 @@ static const struct usb_device_id ath3k_table[] = {
  	{ USB_DEVICE(0x13d3, 0x3375) },
  	{ USB_DEVICE(0x13d3, 0x3393) },
  	{ USB_DEVICE(0x13d3, 0x3402) },
+	{ USB_DEVICE(0x13d3, 0x3408) },
  	{ USB_DEVICE(0x13d3, 0x3432) },

  	/* Atheros AR5BBU12 with sflash firmware */
@@ -156,6 +157,7 @@ static const struct usb_device_id ath3k_blist_tbl[] = {
  	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
  	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
  	{ USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3408), .driver_info = BTUSB_ATH3012 },
  	{ USB_DEVICE(0x13d3, 0x3432), .driver_info = BTUSB_ATH3012 },

  	/* Atheros AR5BBU22 with sflash firmware */
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index edfc17b..091c813 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -182,6 +182,7 @@ static const struct usb_device_id blacklist_table[] = {
  	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
  	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
  	{ USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3408), .driver_info = BTUSB_ATH3012 },
  	{ USB_DEVICE(0x13d3, 0x3432), .driver_info = BTUSB_ATH3012 },

  	/* Atheros AR5BBU12 with sflash firmware */

-- 
