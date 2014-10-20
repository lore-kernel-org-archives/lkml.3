Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaJTNMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:12:44 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:52428 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725AbaJTNMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:12:43 -0400
From: Stefan Hengelein <stefan.hengelein@fau.de>
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org, geert@linux-m68k.org,
        Stefan Hengelein <stefan.hengelein@fau.de>
Subject: [PATCH] MIPS: ath79: fix compilation error when CONFIG_PCI is disabled
Date: Mon, 20 Oct 2014 15:11:39 +0200
Message-Id: <1413810699-44465-1-git-send-email-stefan.hengelein@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <CAMuHMdV3cGsW3iONgHHsMgVcoOqjLDoiE5u-+62M=6+fOYsj4Q@mail.gmail.com>
References: <CAMuHMdV3cGsW3iONgHHsMgVcoOqjLDoiE5u-+62M=6+fOYsj4Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_PCI is disabled, 'db120_pci_init()' had a different
signature than when was enabled. Therefore, compilation failed when
CONFIG_PCI was not present.

arch/mips/ath79/mach-db120.c:132: error: too many arguments to function 'db120_pci_init'

This error was found with vampyr.

Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>

---
Changelog:
v2: fix prototype instead of removing the caller
---
 arch/mips/ath79/mach-db120.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/ath79/mach-db120.c b/arch/mips/ath79/mach-db120.c
index 4d661a1..9423f5a 100644
--- a/arch/mips/ath79/mach-db120.c
+++ b/arch/mips/ath79/mach-db120.c
@@ -113,7 +113,7 @@ static void __init db120_pci_init(u8 *eeprom)
 	ath79_register_pci();
 }
 #else
-static inline void db120_pci_init(void) {}
+static inline void db120_pci_init(u8 *eeprom) {}
 #endif /* CONFIG_PCI */
 
 static void __init db120_setup(void)
-- 
1.9.1

