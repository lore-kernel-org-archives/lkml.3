Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab3IYKLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 06:11:45 -0400
Received: from 8bytes.org ([85.214.48.195]:47193 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab3IYKLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 06:11:43 -0400
From: Joerg Roedel <joro@8bytes.org>
To: arm@kernel.org, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
Subject: [PATCH] arm: mach-integrator: Add stub for pci_v3_early_init() for !CONFIG_PCI
Date: Wed, 25 Sep 2013 12:11:33 +0200
Message-Id: <1380103893-7119-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Sep 25 12:11:41 2013
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5242b6dd20861861778620
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a compile error where CONFIG_PCI is disabled:

  LD      init/built-in.o
arch/arm/mach-integrator/built-in.o: In function `ap_map_io':
integrator_cp.c:(.init.text+0x570): undefined reference to `pci_v3_early_init'
make[1]: *** [vmlinux] Error 1
make: *** [sub-make] Error 2

Cc: stable@vger.kernel.org
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 arch/arm/mach-integrator/pci_v3.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/mach-integrator/pci_v3.h b/arch/arm/mach-integrator/pci_v3.h
index 755fd29..06a9e2e 100644
--- a/arch/arm/mach-integrator/pci_v3.h
+++ b/arch/arm/mach-integrator/pci_v3.h
@@ -1,2 +1,9 @@
 /* Simple oneliner include to the PCIv3 early init */
+#ifdef CONFIG_PCI
 extern int pci_v3_early_init(void);
+#else
+static inline int pci_v3_early_init(void)
+{
+	return 0;
+}
+#endif
-- 
1.7.9.5


