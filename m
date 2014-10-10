Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbaJJPQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 11:16:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49939 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbaJJPQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 11:16:12 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shilimkar@ti.com>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH] ARM: keystone: add bus notifier to set dma_pfn_offset for pci devices
Date: Fri, 10 Oct 2014 11:15:37 -0400
Message-ID: <1412954137-4567-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When PCI device driver such as that for e1000e tries to set dma mask
using dma_set_mask_and_coherent(), it fails because the dma_pfn_offset
is incorrect on a Keystone SoC. This patch fix this by adding a bus
notifier to set this correctly for PCI devices.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 arch/arm/mach-keystone/keystone.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-keystone/keystone.c b/arch/arm/mach-keystone/keystone.c
index 7f352de..13afe95 100644
--- a/arch/arm/mach-keystone/keystone.c
+++ b/arch/arm/mach-keystone/keystone.c
@@ -15,6 +15,7 @@
 #include <linux/of_platform.h>
 #include <linux/of_address.h>
 #include <linux/memblock.h>
+#include <linux/pci.h>
 
 #include <asm/setup.h>
 #include <asm/mach/map.h>
@@ -54,6 +55,8 @@ static void __init keystone_init(void)
 	keystone_pm_runtime_init();
 	if (platform_nb.notifier_call)
 		bus_register_notifier(&platform_bus_type, &platform_nb);
+	if (platform_nb.notifier_call)
+		bus_register_notifier(&pci_bus_type, &platform_nb);
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-- 
1.7.9.5

