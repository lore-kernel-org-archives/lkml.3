Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab3E1S3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 14:29:12 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:36748 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab3E1S3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 14:29:10 -0400
MIME-Version: 1.0
Date: Tue, 28 May 2013 14:29:09 -0400
Message-ID: <CANsc=4W8cW3jQs8yN_j8DZyEo7GkMejNc4Vw65A4iW+GuasBaw@mail.gmail.com>
Subject: [PATCH] ARM: omap2plus_defconfig: enable USB_PHY and NOP_USB_XCEIV
From: =?UTF-8?Q?Adrien_Verg=C3=A9?= <adrienverge@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        AnilKumar Ch <anilkumar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Roger Quadros <rogerq@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On OMAP2+ platforms, USB support needs physical layer signalling and
the NOP USB Transceiver driver since v3.10. This patch enables USB_PHY
and NOP_USB_XCEIV in omap2plus_defconfig. These two are harmless to
the kernel stability, and useful since they are required for USB and
Ethernet (over USB) support.

We do not enable USB_EHCI_HCD here because all features aren't fully
supported yet.

This patch applies to Linux 3.10-rc3.

Cc: Roger Quadros <rogerq@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Adrien Vergé <adrienverge@gmail.com>
---
 arch/arm/configs/omap2plus_defconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/omap2plus_defconfig
b/arch/arm/configs/omap2plus_defconfig
index abbe319..2ac0ffb 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -210,6 +210,8 @@ CONFIG_USB_WDM=y
 CONFIG_USB_STORAGE=y
 CONFIG_USB_LIBUSUAL=y
 CONFIG_USB_TEST=y
+CONFIG_USB_PHY=y
+CONFIG_NOP_USB_XCEIV=y
 CONFIG_USB_GADGET=y
 CONFIG_USB_GADGET_DEBUG=y
 CONFIG_USB_GADGET_DEBUG_FILES=y
-- 
1.7.10.4
