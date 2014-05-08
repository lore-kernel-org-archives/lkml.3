Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbaEHNwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:52:42 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:49352 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaEHNwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:52:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, linux-omap@vger.kernel.org
Subject: [PATCH 2/8] usb: musb: tusb-dma can't be built-in if tusb is not
Date: Thu,  8 May 2014 15:52:15 +0200
Message-Id: <1399557141-1346645-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399557141-1346645-1-git-send-email-arnd@arndb.de>
References: <1399557141-1346645-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:iFRq6WZNp6XxuYJMGV0j/fmr9htWBTALaOUDqZnfIZu
 H4JqBmmZvG4ZSUHJWIxowL0e6JRRlZPqyu6brLP2XH4+Vhe0/6
 /99gKLVPOjlXZnsgiCYlvPBSEXtuG1snVz5JCzu0f289uRROMY
 bQ/PRNIpif7L2OAsTvVrH8XEMrHCTkAqyz6rg6TC05e8/iiiu1
 Q9WVxENU7P07kwxKIoF3hYEGlTdIwNIidKQ1NczMg7C19sVg7V
 Kq73VzfafiWJ9zEp29aPr4lU4ESW7lfwn2HTQHky1NvX+chnYz
 uu0w28aa+hmx0woWt4IkuVJ5GbORO/u8vjvtrbUgxwbj3xckwO
 X5dk4gEPGCBCABenWatI/cRHdz791p7j9ed6IKFTp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A configuration with CONFIG_USB_MUSB_HDRC=y, CONFIG_USB_TUSB_OMAP_DMA=y
and CONFIG_USB_MUSB_TUSB6010=m causes a link failure because of the
dependency on the tusb_get_revision symbol:

(.text+0x154ce8): undefined reference to `tusb_get_revision'

This patch ensures that either MUSB_HDRC and MUSB_TUSB6010 are
both modules or both built-in, which are the valid configurations.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-omap@vger.kernel.org
---
 drivers/usb/musb/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 8b78979..618b152 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -144,7 +144,7 @@ config USB_TI_CPPI41_DMA
 
 config USB_TUSB_OMAP_DMA
 	bool 'TUSB 6010'
-	depends on USB_MUSB_TUSB6010
+	depends on USB_MUSB_TUSB6010 = USB_MUSB_HDRC # both built-in or both modules
 	depends on ARCH_OMAP
 	help
 	  Enable DMA transfers on TUSB 6010 when OMAP DMA is available.
-- 
1.8.3.2

