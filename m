Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbaGILi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:38:59 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:45164 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608AbaGILgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:36:47 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-10-53bd294d92e2
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH RESEND -next 18/21] arm: mm: reserve shadow memory for kasan
Date: Wed, 09 Jul 2014 15:30:12 +0400
Message-id: <1404905415-9046-19-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t/xy7q+mnuDDZa+N7bY9usRm8XvvTNZ
	LeasX8Nmcf3bG0aLCQ/b2C1WdjezWWx/9pbJYmXnA1aLTY+vsVr82bWDyeLyrjlsFvfW/Ge1
	uH2Z1+LSgQVMFi37LjBZtH3+x2qxb+V5IGvJRiaLxUduM1u8ezaZ2WLzpqnMFj82PGZ1EPNo
	ae5h89g56y67x4JNpR6bVnWyeWz6NIndo+vtFSaPd+fOsXucmPGbxePJlelMHpuX1Ht8fHqL
	xeP9vqtsHn1bVjF6nFlwhN3j8ya5AP4oLpuU1JzMstQifbsErownU+ML7rJWLH/xibmB8QVL
	FyMnh4SAicTl3ZOZIWwxiQv31rN1MXJxCAksZZT4PG0CC4TTxyRx5OhTdpAqNgE9iX+ztrOB
	2CICChKbe5+xghQxCzSzSbR3fGAFSQgLBEgc23WREcRmEVCVuH3iGBOIzSvgJrHo91Q2iHUK
	EsuWzwSr5wSKT5h+DegMDqBtrhITVqhNYORdwMiwilE0tTS5oDgpPddQrzgxt7g0L10vOT93
	EyMkkr7sYFx8zOoQowAHoxIPr0bt7mAh1sSy4srcQ4wSHMxKIry2onuDhXhTEiurUovy44tK
	c1KLDzEycXBKNTBavhBICcyVW22//0dTXGvyqydVV/znKbLueCPJt0NyR8GBcMHS8MhSl4TN
	ff9C7svl2XI8nVltpx3JyVEvd/hiX9mjx/nuqh/cC/LMmHNdAuyuTX7+1tudeSajZdGaOf2i
	gbveGWzf4s+9sGvGphxXtW3uUgxHeGZsjZr8OnxapqtkbbPyCiWW4oxEQy3mouJEAEWCUpmC	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/arm/mm/init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 659c75d..02fce2c 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -22,6 +22,7 @@
 #include <linux/memblock.h>
 #include <linux/dma-contiguous.h>
 #include <linux/sizes.h>
+#include <linux/kasan.h>
 
 #include <asm/cp15.h>
 #include <asm/mach-types.h>
@@ -324,6 +325,8 @@ void __init arm_memblock_init(const struct machine_desc *mdesc)
 	 */
 	dma_contiguous_reserve(min(arm_dma_limit, arm_lowmem_limit));
 
+	kasan_alloc_shadow();
+
 	arm_memblock_steal_permitted = false;
 	memblock_dump_all();
 }
-- 
1.8.5.5

