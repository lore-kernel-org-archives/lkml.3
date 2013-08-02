Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab3HBQuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:50:37 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:47574 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3HBQue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:50:34 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        matt.fleming@intel.com, tony.luck@gmail.com, patches@linaro.org,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v2 1/5] ia64: add early_memremap() alias for early_ioremap()
Date: Fri,  2 Aug 2013 17:56:18 +0100
Message-Id: <1375462582-16423-2-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375462582-16423-1-git-send-email-leif.lindholm@linaro.org>
References: <1375462582-16423-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

early_ioremap() on IA64 chooses its mapping type based on the EFI
memory map. This patch adds an alias "early_memremap()" to be used
where the targeted location is memory rather than an i/o device.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 arch/ia64/include/asm/io.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
index 74a7cc3..0d2bcb3 100644
--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -424,6 +424,7 @@ extern void __iomem * ioremap(unsigned long offset, unsigned long size);
 extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long size);
 extern void iounmap (volatile void __iomem *addr);
 extern void __iomem * early_ioremap (unsigned long phys_addr, unsigned long size);
+#define early_memremap(phys_addr, size)        early_ioremap(phys_addr, size)
 extern void early_iounmap (volatile void __iomem *addr, unsigned long size);
 static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned long size)
 {
-- 
1.7.10.4

