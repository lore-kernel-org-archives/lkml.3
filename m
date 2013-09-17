Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab3IQMn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:43:56 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:33357 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab3IQMny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:43:54 -0400
From: Russ Dill <Russ.Dill@ti.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        mans@mansr.com, Shawn Guo <shawn.guo@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [RFC PATCH 01/11] asm-generic: io: Add exec versions of ioremap
Date: Tue, 17 Sep 2013 05:43:27 -0700
Message-Id: <1379421817-15759-2-git-send-email-Russ.Dill@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
References: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If code is to be copied into and area (such as SRAM) and run,
it needs to be marked as exec. Currently only an ARM version
of this exists.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
---
 arch/arm/include/asm/io.h   | 2 ++
 include/asm-generic/iomap.h | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index d070741..212d095 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -329,6 +329,8 @@ extern void _memset_io(volatile void __iomem *, int, size_t);
 #define ioremap_nocache(cookie,size)	__arm_ioremap((cookie), (size), MT_DEVICE)
 #define ioremap_cached(cookie,size)	__arm_ioremap((cookie), (size), MT_DEVICE_CACHED)
 #define ioremap_wc(cookie,size)		__arm_ioremap((cookie), (size), MT_DEVICE_WC)
+#define ioremap_exec(cookie,size)	__arm_ioremap_exec((cookie), (size), true)
+#define ioremap_exec_nocache(cookie,size) __arm_ioremap_exec((cookie), (size), false)
 #define iounmap				__arm_iounmap
 
 /*
diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index 6afd7d6..e72c451 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -66,6 +66,11 @@ extern void ioport_unmap(void __iomem *);
 #define ioremap_wc ioremap_nocache
 #endif
 
+#ifndef ARCH_HAS_IOREMAP_EXEC
+#define ioremap_exec ioremap
+#define ioremap_exec_nocache ioremap_nocache
+#endif
+
 #ifdef CONFIG_PCI
 /* Destroy a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
-- 
1.8.3.2

