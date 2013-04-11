Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161382Ab3DKJmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 05:42:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39519 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935568Ab3DKJmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 05:42:10 -0400
Message-ID: <5166856C.3080906@ti.com>
Date: Thu, 11 Apr 2013 12:42:04 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Alan Stern <stern@rowland.harvard.edu>, "Balbi, Felipe" <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: [PATCH] USB: ehci-omap: Select USB_PHY
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

The following patch gets rid of Kbuild warnings when USB_EHCI_HCD_OMAP
is enabled.

Patch is based on your usb-next branch and is needed for 3.10.

From: Roger Quadros <rogerq@ti.com>
Date: Thu, 11 Apr 2013 12:08:19 +0300
Subject: [PATCH] USB: ehci-omap: Select USB_PHY

As we need NOP_USB_XCEIV which depends on USB_PHY
we need to select USB_PHY as well.

Gets rid of the below warnings when USB_EHCI_HCD_OMAP
is enabled.

warning: (USB_EHCI_HCD_OMAP) selects NOP_USB_XCEIV which has unmet direct dependencies (USB_SUPPORT && USB_PHY)
warning: (USB_EHCI_HCD_OMAP) selects NOP_USB_XCEIV which has unmet direct dependencies (USB_SUPPORT && USB_PHY)

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index c0be25c..931b437 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -150,6 +150,7 @@ config USB_EHCI_MXC
 config USB_EHCI_HCD_OMAP
 	tristate "EHCI support for OMAP3 and later chips"
 	depends on ARCH_OMAP
+	select USB_PHY
 	select NOP_USB_XCEIV
 	default y
 	---help---
-- 
1.7.4.1
