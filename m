Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164AbaHREZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 00:25:54 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:57292 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbaHREZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 00:25:52 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Vineet Gupta <vgupta@synopsys.com>, Steven Miao <realmz6@gmail.com>,
        David Howells <dhowells@redhat.com>, Richard Kuo <rkuo@codeaurora.org>,
        James Hogan <james.hogan@imgtec.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>, Noam Camus <noamc@ezchip.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tony Lu <zlu@tilera.com>, Kirill Tkhai <tkhai@yandex.ru>,
        linux-kernel@vger.kernel.org (open list),
        adi-buildroot-devel@lists.sourceforge.net (moderated list:BLACKFIN
	ARCHITEC...),
        linux-hexagon@vger.kernel.org (open list:QUALCOMM HEXAGON...),
        linux-metag@vger.kernel.org (open list:METAG ARCHITECTURE),
        linux-sh@vger.kernel.org (open list:SUPERH),
        linux-xtensa@linux-xtensa.org (open list:TENSILICA XTENSA...)
Subject: [PATCH] flush_icache_range: Export symbol to fix build errors
Date: Mon, 18 Aug 2014 00:24:49 -0400
Message-Id: <1408335898-3109-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix building errors occuring due to a missing export of flush_icache_range() in
architectures missing the export.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 arch/arc/mm/cache_arc700.c             |    1 +
 arch/blackfin/include/asm/cacheflush.h |    1 +
 arch/frv/include/asm/cacheflush.h      |    1 +
 arch/hexagon/mm/cache.c                |    1 +
 arch/metag/include/asm/cacheflush.h    |    1 +
 arch/sh/mm/cache.c                     |    1 +
 arch/tile/kernel/smp.c                 |    1 +
 arch/xtensa/kernel/smp.c               |    1 +
 8 files changed, 8 insertions(+)

diff --git a/arch/arc/mm/cache_arc700.c b/arch/arc/mm/cache_arc700.c
index 4670afc..e88ddbf 100644
--- a/arch/arc/mm/cache_arc700.c
+++ b/arch/arc/mm/cache_arc700.c
@@ -581,6 +581,7 @@ void flush_icache_range(unsigned long kstart, unsigned long kend)
 		tot_sz -= sz;
 	}
 }
+EXPORT_SYMBOL(flush_icache_range);
 
 /*
  * General purpose helper to make I and D cache lines consistent.
diff --git a/arch/blackfin/include/asm/cacheflush.h b/arch/blackfin/include/asm/cacheflush.h
index 9a5b2c5..0e2eb8c 100644
--- a/arch/blackfin/include/asm/cacheflush.h
+++ b/arch/blackfin/include/asm/cacheflush.h
@@ -70,6 +70,7 @@ static inline void flush_icache_range(unsigned start, unsigned end)
 	}
 #endif
 }
+EXPORT_SYMBOL(flush_icache_range);
 
 #define copy_to_user_page(vma, page, vaddr, dst, src, len)		\
 do { memcpy(dst, src, len);						\
diff --git a/arch/frv/include/asm/cacheflush.h b/arch/frv/include/asm/cacheflush.h
index edbac54..07ee4b3 100644
--- a/arch/frv/include/asm/cacheflush.h
+++ b/arch/frv/include/asm/cacheflush.h
@@ -72,6 +72,7 @@ static inline void flush_icache_range(unsigned long start, unsigned long end)
 {
 	frv_cache_wback_inv(start, end);
 }
+EXPORT_SYMBOL(flush_icache_range);
 
 #ifdef CONFIG_MMU
 extern void flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
diff --git a/arch/hexagon/mm/cache.c b/arch/hexagon/mm/cache.c
index fe14ccf..0c76c80 100644
--- a/arch/hexagon/mm/cache.c
+++ b/arch/hexagon/mm/cache.c
@@ -68,6 +68,7 @@ void flush_icache_range(unsigned long start, unsigned long end)
 	);
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL(flush_icache_range);
 
 void hexagon_clean_dcache_range(unsigned long start, unsigned long end)
 {
diff --git a/arch/metag/include/asm/cacheflush.h b/arch/metag/include/asm/cacheflush.h
index 7787ec5..117c212 100644
--- a/arch/metag/include/asm/cacheflush.h
+++ b/arch/metag/include/asm/cacheflush.h
@@ -124,6 +124,7 @@ static inline void flush_icache_range(unsigned long address,
 	metag_code_cache_flush((void *) address, endaddr - address);
 #endif
 }
+EXPORT_SYMBOL(flush_icache_range);
 
 static inline void flush_cache_sigtramp(unsigned long addr, int size)
 {
diff --git a/arch/sh/mm/cache.c b/arch/sh/mm/cache.c
index 097c2cd..f770e39 100644
--- a/arch/sh/mm/cache.c
+++ b/arch/sh/mm/cache.c
@@ -229,6 +229,7 @@ void flush_icache_range(unsigned long start, unsigned long end)
 
 	cacheop_on_each_cpu(local_flush_icache_range, (void *)&data, 1);
 }
+EXPORT_SYMBOL(flush_icache_range);
 
 void flush_icache_page(struct vm_area_struct *vma, struct page *page)
 {
diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
index 01e8ab2..19eaa62 100644
--- a/arch/tile/kernel/smp.c
+++ b/arch/tile/kernel/smp.c
@@ -183,6 +183,7 @@ void flush_icache_range(unsigned long start, unsigned long end)
 		preempt_enable();
 	}
 }
+EXPORT_SYMBOL(flush_icache_range);
 
 
 /* Called when smp_send_reschedule() triggers IRQ_RESCHEDULE. */
diff --git a/arch/xtensa/kernel/smp.c b/arch/xtensa/kernel/smp.c
index 40b5a37..4d02e38 100644
--- a/arch/xtensa/kernel/smp.c
+++ b/arch/xtensa/kernel/smp.c
@@ -571,6 +571,7 @@ void flush_icache_range(unsigned long start, unsigned long end)
 	};
 	on_each_cpu(ipi_flush_icache_range, &fd, 1);
 }
+EXPORT_SYMBOL(flush_icache_range);
 
 /* ------------------------------------------------------------------------- */
 
-- 
1.7.9.5

