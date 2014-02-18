Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbaBRCKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:10:54 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54732 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbaBRCKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:10:48 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-pci@vger.kernel.org
Cc: horms@verge.net.au, linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        valentine.barshak@cogentembedded.com, ben.dooks@codethink.co.uk,
        geert@linux-m68k.org, bhelgaas@google.com,
        Magnus Damm <magnus.damm@gmail.com>
Date: Tue, 18 Feb 2014 11:12:01 +0900
Message-Id: <20140218021201.14164.83953.sendpatchset@w520>
In-Reply-To: <20140218021041.14164.56411.sendpatchset@w520>
References: <20140218021041.14164.56411.sendpatchset@w520>
Subject: [PATCH 08/08] PCI: rcar: Make the Kconfig dependencies more generic
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Update the R-Car Generation 2 PCI driver Kconfig dependencies
to follow same style as other drivers - no SoC dependencies.

Also, update the COMPILE_TEST bits to depend on ARM. This since
the DMA bounce buffer and dma_ops handling code is ARM specific.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/pci/host/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 0010/drivers/pci/host/Kconfig
+++ work/drivers/pci/host/Kconfig	2014-02-13 11:19:19.000000000 +0900
@@ -27,7 +27,7 @@ config PCI_TEGRA
 
 config PCI_RCAR_GEN2
 	bool "Renesas R-Car Gen2 Internal PCI controller"
-	depends on ARM && (ARCH_R8A7790 || ARCH_R8A7791 || COMPILE_TEST)
+	depends on ARCH_SHMOBILE || (ARM && COMPILE_TEST)
 	select GENERIC_ALLOCATOR
 	select DMABOUNCE
 	select BOUNCE if HIGHMEM
