Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760312Ab3HNTub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:50:31 -0400
Received: from 8bytes.org ([85.214.48.195]:51371 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760261Ab3HNTua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:50:30 -0400
From: Joerg Roedel <joro@8bytes.org>
To: Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] ARM: integrator: Make sure INTEGRATOR_AP depends on PCI
Date: Wed, 14 Aug 2013 21:50:18 +0200
Message-Id: <1376509818-22163-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Aug 14 21:50:28 2013
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 520bdf8420865169947975
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add this dependency to the Kconfig file to fix the following
build error when CONFIG_INTEGRATOR_AP is set but CONFIG_PCI
is not:

  LD      init/built-in.o
arch/arm/mach-integrator/built-in.o: In function `ap_map_io':
integrator_cp.c:(.init.text+0x570): undefined reference to `pci_v3_early_init'
make[1]: *** [vmlinux] Error 1
make: *** [sub-make] Error 2

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 arch/arm/mach-integrator/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-integrator/Kconfig b/arch/arm/mach-integrator/Kconfig
index abeff25..be16569 100644
--- a/arch/arm/mach-integrator/Kconfig
+++ b/arch/arm/mach-integrator/Kconfig
@@ -9,6 +9,7 @@ config ARCH_INTEGRATOR_AP
 	select SERIAL_AMBA_PL010
 	select SERIAL_AMBA_PL010_CONSOLE
 	select SOC_BUS
+	depends on PCI
 	help
 	  Include support for the ARM(R) Integrator/AP and
 	  Integrator/PP2 platforms.
-- 
1.7.9.5


