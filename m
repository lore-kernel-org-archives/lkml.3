Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965928Ab3E2LoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:44:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43350 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965849Ab3E2Lnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:43:53 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <balbi@ti.com>, <stern@rowland.harvard.edu>, <kishon@ti.com>,
        <arnd@arndb.de>, <adrienverge@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>, Roland Stigge <stigge@antcom.de>
Subject: [PATCH 4/5] USB: lpc32xx: USB_LPC32XX need not depend on USB_PHY
Date: Wed, 29 May 2013 14:43:30 +0300
Message-ID: <1369827811-534-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1369827811-534-1-git-send-email-rogerq@ti.com>
References: <1369827811-534-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the USB PHY drivers no longer depend on USB_PHY but
select it if needed, the controller drivers need not
depend on USB_PHY. They can safely select the necessary
PHY driver i.e. USB_ISP1301 in this case.

Signed-off-by: Roger Quadros <rogerq@ti.com>
CC: Roland Stigge <stigge@antcom.de>
---
 drivers/usb/gadget/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index f41aa0d..2b98bce 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -144,7 +144,6 @@ config USB_AT91
 config USB_LPC32XX
 	tristate "LPC32XX USB Peripheral Controller"
 	depends on ARCH_LPC32XX
-	depends on USB_PHY
 	select USB_ISP1301
 	help
 	   This option selects the USB device controller in the LPC32xx SoC.
-- 
1.7.4.1

