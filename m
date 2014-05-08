Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbaEHKWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:22:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54442 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbaEHKWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:22:51 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH] usb: musb: Kconfig: Select the DMA driver if DMA mode of MUSB is enabled
Date: Thu, 8 May 2014 15:50:54 +0530
Message-ID: <1399544454-15045-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AM335x MUSB supports both PIO and DMA mode. When DMA mode is
selected users need to explicitly enable the DMA driver. To avoid the
extra configuration select the DMA driver if DMA mode is set for AM335x MUSB.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/musb/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 8b78979..6b2a4b8 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -141,6 +141,7 @@ config USB_TI_CPPI_DMA
 config USB_TI_CPPI41_DMA
 	bool 'TI CPPI 4.1 (AM335x)'
 	depends on ARCH_OMAP
+	select TI_CPPI41
 
 config USB_TUSB_OMAP_DMA
 	bool 'TUSB 6010'
-- 
1.8.3.1

