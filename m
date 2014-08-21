Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbaHUNEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:04:30 -0400
Received: from mail-yk0-f169.google.com ([209.85.160.169]:50040 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbaHUNE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:04:28 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Alistair Popple <alistair@popple.id.au>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] powerpc: Fix build failure
Date: Thu, 21 Aug 2014 09:04:31 -0400
Message-Id: <1408626271-13519-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build failure

drivers/built-in.o: In function `nhi_init':
nhi.c:(.init.text+0x63390): undefined reference to `ehci_init_driver'

by adding a dependency on USB_EHCI_HCD which supplies the ehci_init_driver().

Also we need to depend on USB_OHCI_HCD similarly

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/powerpc/platforms/44x/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index 4d88f6a..3e7deb2 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -216,8 +216,8 @@ config AKEBONO
 	select IBM_EMAC_EMAC4
 	select IBM_EMAC_RGMII_WOL
 	select USB
-	select USB_OHCI_HCD_PLATFORM
-	select USB_EHCI_HCD_PLATFORM
+	select USB_OHCI_HCD_PLATFORM if USB_OHCI_HCD
+	select USB_EHCI_HCD_PLATFORM if USB_EHCI_HCD
 	select MMC_SDHCI
 	select MMC_SDHCI_PLTFM
 	select MMC_SDHCI_OF_476GTR
-- 
1.9.1

