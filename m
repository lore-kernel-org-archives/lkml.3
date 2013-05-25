Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab3EYEnE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 00:43:04 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:43079 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3EYEnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 00:43:03 -0400
MIME-Version: 1.0
In-Reply-To: <CANsc=4W7ZVuCoimeALsv6xEQAURYc=QYsCvXd_kZD-A52aTL5w@mail.gmail.com>
References: <CANsc=4W7ZVuCoimeALsv6xEQAURYc=QYsCvXd_kZD-A52aTL5w@mail.gmail.com>
Date: Sat, 25 May 2013 00:43:01 -0400
Message-ID: <CANsc=4WDM0q=RwaN2ZrcNqgJ=fDsgGHcBDcufnDek4EVWcnGfw@mail.gmail.com>
Subject: [PATCH] ARM: OMAP4: USB_EHCI_HCD needs USB_PHY and NOP_USB_XCEIV
From: =?UTF-8?Q?Adrien_Verg=C3=A9?= <adrienverge@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Florian Fainelli <florian@openwrt.org>, Arnd Bergmann <arnd@arndb.de>,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Yannick Brosseau <yannick.brosseau@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On OMAP4 platforms, EHCI HCD needs the physical layer signalling
activated, along with the NOP USB Transceiver driver. Otherwise, the
kernel boots without registering any USB device.

This patch applies to Linux 3.10-rc2.

Signed-off-by: Adrien Vergé <adrienverge@gmail.com>
---
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index de94f26..47959d7 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -44,6 +44,8 @@ endif # USB_XHCI_HCD
 config USB_EHCI_HCD
 	tristate "EHCI HCD (USB 2.0) support"
 	depends on USB_ARCH_HAS_EHCI
+	select USB_PHY if ARCH_OMAP4
+	select NOP_USB_XCEIV if ARCH_OMAP4
 	---help---
 	  The Enhanced Host Controller Interface (EHCI) is standard for USB 2.0
 	  "high speed" (480 Mbit/sec, 60 Mbyte/sec) host controller hardware.
