Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965940Ab3E2LoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:44:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55027 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965842Ab3E2Lny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:43:54 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <balbi@ti.com>, <stern@rowland.harvard.edu>, <kishon@ti.com>,
        <arnd@arndb.de>, <adrienverge@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 5/5] USB: OMAP: USB_OMAP need not depend USB_PHY
Date: Wed, 29 May 2013 14:43:31 +0300
Message-ID: <1369827811-534-6-git-send-email-rogerq@ti.com>
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
PHY driver i.e. ISP1301_OMAP in this case.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/gadget/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 2b98bce..86d5d80 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -194,7 +194,6 @@ config USB_FUSB300
 config USB_OMAP
 	tristate "OMAP USB Device Controller"
 	depends on ARCH_OMAP1
-	depends on USB_PHY
 	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3 || MACH_OMAP_H4_OTG
 	help
 	   Many Texas Instruments OMAP processors have flexible full
-- 
1.7.4.1

