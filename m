Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbaGILge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:36:34 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63098 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbaGILgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:36:32 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-7e-53bd293c40a6
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
Subject: [RFC/PATCH RESEND -next 06/21] x86: mm: init: allocate shadow memory
 for kasan
Date: Wed, 09 Jul 2014 15:30:00 +0400
Message-id: <1404905415-9046-7-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t/xy7o2mnuDDd4vNbPY9usRm8XvvTNZ
	LeasX8Nmcf3bG0aLCQ/b2C1WdjezWWx/9pbJYmXnA1aLTY+vsVr82bWDyeLyrjlsFvfW/Ge1
	uH2Z1+LSgQVMFi37LjBZtH3+x2qxb+V5IGvJRiaLxUduM1u8ezaZ2WLzpqnMFj82PGZ1EPNo
	ae5h89g56y67x4JNpR6bVnWyeWz6NIndo+vtFSaPd+fOsXucmPGbxePJlelMHpuX1Ht8fHqL
	xeP9vqtsHn1bVjF6nFlwhN3j8ya5AP4oLpuU1JzMstQifbsEroxJO4MLvrFUTJ2xhqmBsYul
	i5GTQ0LAROLdvu/MELaYxIV769m6GLk4hASWMko8Wf2ACcLpY5J49qiJDaSKTUBP4t+s7WC2
	iICCxObeZ6wgRcwCzWwS7R0fWEESwgKREo1vnrOD2CwCqhK73ixlBLF5BVwlbrx6zgSxTkFi
	2fKZYPWcAm4SE6ZfAzqDA2ibq8SEFWoTGHkXMDKsYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/d
	xAiJpK87GJceszrEKMDBqMTD+2L3nmAh1sSy4srcQ4wSHMxKIry2onuDhXhTEiurUovy44tK
	c1KLDzEycXBKNTDmX1u/NDzunNvyK6pCT38olC3nmVoevvrqLlfpr8ob2be12pRNUE04nluw
	TdJDI8Lx5emXicsnX0g0+MkpkulVmsikE6LzWqX99rG3K19NmcXtPK1Tn3dfwTOZWpWCBDer
	Cctsdj17MTM/oSr2K6fOYYG0Z50aUodWra5bcthy3pT6a4yH++qVWIozEg21mIuKEwHt7JFc
	ggIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/x86/mm/init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index f971306..d9925ee 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -4,6 +4,7 @@
 #include <linux/swap.h>
 #include <linux/memblock.h>
 #include <linux/bootmem.h>	/* for max_low_pfn */
+#include <linux/kasan.h>
 
 #include <asm/cacheflush.h>
 #include <asm/e820.h>
@@ -678,5 +679,7 @@ void __init zone_sizes_init(void)
 #endif
 
 	free_area_init_nodes(max_zone_pfns);
+
+	kasan_alloc_shadow();
 }
 
-- 
1.8.5.5

