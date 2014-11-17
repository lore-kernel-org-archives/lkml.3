Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaKQS5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:57:06 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:49253 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaKQS5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:57:04 -0500
MIME-Version: 1.0
Date: Mon, 17 Nov 2014 22:57:01 +0400
Message-ID: <CANoib0GyS0oxAR-xQzuKdcFm9p=zt5=aSFXQivX9GzP_4wNXMw@mail.gmail.com>
Subject: [PATCH 1/1] ath3k: Add support of MCI 13d3:3408 bt device
From: Dmitry Tunin <hanipouspilot@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for bluetooth MCI WB335 (AR9565) Wi-Fi+bt module.

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
+ { USB_DEVICE(0x13d3, 0x3408) },
  { USB_DEVICE(0x13d3, 0x3432) },

  /* Atheros AR5BBU12 with sflash firmware */
@@ -156,6 +157,7 @@ static const struct usb_device_id ath3k_blist_tbl[] = {
  { USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
  { USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
  { USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
+ { USB_DEVICE(0x13d3, 0x3408), .driver_info = BTUSB_ATH3012 },
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
+ { USB_DEVICE(0x13d3, 0x3408), .driver_info = BTUSB_ATH3012 },
  { USB_DEVICE(0x13d3, 0x3432), .driver_info = BTUSB_ATH3012 },

  /* Atheros AR5BBU12 with sflash firmware */

---
