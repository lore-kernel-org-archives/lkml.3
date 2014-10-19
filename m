Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaJSRnb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 13:43:31 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:44786 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490AbaJSRn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 13:43:29 -0400
From: Stefan Hengelein <stefan.hengelein@fau.de>
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        Stefan Hengelein <stefan.hengelein@fau.de>
Subject: [PATCH] MIPS: ath79: fix compilation error when CONFIG_PCI is disabled
Date: Sun, 19 Oct 2014 19:43:14 +0200
Message-Id: <1413740594-15579-1-git-send-email-stefan.hengelein@fau.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_PCI is disabled, 'db120_pci_init()' had a different
signature than when was enabled. Therefore, compilation failed when
CONFIG_PCI was not present.

arch/mips/ath79/mach-db120.c:132: error: too many arguments to function 'db120_pci_init'

Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>
---
 arch/mips/ath79/mach-db120.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/ath79/mach-db120.c b/arch/mips/ath79/mach-db120.c
index 4d661a1..d1a783d 100644
--- a/arch/mips/ath79/mach-db120.c
+++ b/arch/mips/ath79/mach-db120.c
@@ -112,8 +112,6 @@ static void __init db120_pci_init(u8 *eeprom)
 	ath79_pci_set_plat_dev_init(db120_pci_plat_dev_init);
 	ath79_register_pci();
 }
-#else
-static inline void db120_pci_init(void) {}
 #endif /* CONFIG_PCI */
 
 static void __init db120_setup(void)
@@ -129,7 +127,9 @@ static void __init db120_setup(void)
 			   ARRAY_SIZE(db120_spi_info));
 	ath79_register_usb();
 	ath79_register_wmac(art + DB120_WMAC_CALDATA_OFFSET);
+#ifdef CONFIG_PCI
 	db120_pci_init(art + DB120_PCIE_CALDATA_OFFSET);
+#endif
 }
 
 MIPS_MACHINE(ATH79_MACH_DB120, "DB120", "Atheros DB120 reference board",
-- 
1.9.1

