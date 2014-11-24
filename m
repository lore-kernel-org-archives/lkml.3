Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaKXQOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 11:14:42 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:39328 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbaKXQOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 11:14:39 -0500
Message-ID: <5473596C.6000100@gmail.com>
Date: Mon, 24 Nov 2014 19:14:36 +0300
From: Dmitry Tunin <hanipouspilot@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v4] ath3k: Add support of MCI 13d3:3408 bt device
References: <5471CFE9.9070109@gmail.com> <4BD80C85-0288-404D-AB39-485359414DC9@holtmann.org> <5471FD0E.4060305@gmail.com>
In-Reply-To: <5471FD0E.4060305@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
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
+    { USB_DEVICE(0x13d3, 0x3408) },
      { USB_DEVICE(0x13d3, 0x3432) },

      /* Atheros AR5BBU12 with sflash firmware */
@@ -156,6 +157,7 @@ static const struct usb_device_id ath3k_blist_tbl[] = {
      { USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
      { USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
      { USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
+    { USB_DEVICE(0x13d3, 0x3408), .driver_info = BTUSB_ATH3012 },
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
+    { USB_DEVICE(0x13d3, 0x3408), .driver_info = BTUSB_ATH3012 },
      { USB_DEVICE(0x13d3, 0x3432), .driver_info = BTUSB_ATH3012 },

      /* Atheros AR5BBU12 with sflash firmware */

--

Canonical people asked to CC: stable@vger.kernel.org

Regards,
	Dmitry.

