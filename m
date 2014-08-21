Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbaHUNQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:16:04 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:61563 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaHUNQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:16:02 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Alistair Popple <alistair@popple.id.au>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] powerpc: Fix build failure when CONFIG_USB=y
Date: Thu, 21 Aug 2014 09:16:04 -0400
Message-Id: <1408626964-31554-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are enabling USB unconditionally which results in following build failure

drivers/built-in.o: In function `tb_drom_read': 
(.text+0x1b62b70): undefined reference to `usb_speed_string'
make: *** [vmlinux] Error 

Enable USB only if USB_SUPPORT is set to avoid such failures

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/powerpc/platforms/44x/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index 3e7deb2..82f2da2 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -215,7 +215,7 @@ config AKEBONO
 	select NET_VENDOR_IBM
 	select IBM_EMAC_EMAC4
 	select IBM_EMAC_RGMII_WOL
-	select USB
+	select USB if USB_SUPPORT
 	select USB_OHCI_HCD_PLATFORM if USB_OHCI_HCD
 	select USB_EHCI_HCD_PLATFORM if USB_EHCI_HCD
 	select MMC_SDHCI
-- 
1.9.1

