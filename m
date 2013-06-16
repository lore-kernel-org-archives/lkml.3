Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab3FPUHF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 16:07:05 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:53418 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab3FPUGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 16:06:41 -0400
From: ddaney.cavm@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com
Cc: david.s.daney@gmail.com, David Daney <david.daney@cavium.com>
Subject: [PATCH 2/2] mn10300: Fix include dependency in irqflags.h
Date: Sun, 16 Jun 2013 13:06:29 -0700
Message-Id: <1371413189-2568-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1371413189-2568-1-git-send-email-ddaney.cavm@gmail.com>
References: <1371413189-2568-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

We need to pick up the definition of raw_smp_processor_id() from
asm/smp.h.  For the !SMP case, we need to supply a definition of
raw_smp_processor_id().

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mn10300/include/asm/irqflags.h | 3 ++-
 arch/mn10300/include/asm/smp.h      | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/mn10300/include/asm/irqflags.h b/arch/mn10300/include/asm/irqflags.h
index 678f68d..06e0a17 100644
--- a/arch/mn10300/include/asm/irqflags.h
+++ b/arch/mn10300/include/asm/irqflags.h
@@ -14,7 +14,8 @@
 
 #include <asm/cpu-regs.h>
 #ifndef __ASSEMBLY__
-#include <linux/smp.h>
+/* linux/smp.h <- linux/irqflags.h needs asm/smp.h first */
+#include <asm/smp.h>
 #endif
 
 /*
diff --git a/arch/mn10300/include/asm/smp.h b/arch/mn10300/include/asm/smp.h
index 6745dbe..498e5ab 100644
--- a/arch/mn10300/include/asm/smp.h
+++ b/arch/mn10300/include/asm/smp.h
@@ -100,6 +100,7 @@ extern void __cpu_die(unsigned int cpu);
 #ifndef __ASSEMBLY__
 
 static inline void smp_init_cpus(void) {}
+#define raw_smp_processor_id() 0
 
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_SMP */
-- 
1.7.11.7

