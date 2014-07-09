Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbaGILRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:17:11 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43665 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbaGILKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:10:23 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-31-53bd2318958d
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH -next 06/21] x86: mm: init: allocate shadow memory for kasan
Date: Wed, 09 Jul 2014 15:01:03 +0400
Message-id: <1404903678-8257-7-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t/xy7oSynuDDa4vMrXY9usRm8XlXXPY
	HJg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK2PSzuCCbywVU2esYWpg7GLpYuTkkBAwkVi9
	p58ZwhaTuHBvPVsXIxeHkMBSRol/ZxezgiSEBPqYJLo/gjWwCehJ/Ju1nQ3EFhFQkNjc+wys
	hllAR2LjtVYmEFtYIEBi28Rd7CA2i4CqxMzPPUD1HBy8Aq4Sh15VQOxSkFi2fCZYK6eAm0RP
	zwImiFWuEqs/b2OcwMi7gJFhFaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZIAHzdwbj0mNUh
	RgEORiUe3he79wQLsSaWFVfmHmKU4GBWEuG1Fd0bLMSbklhZlVqUH19UmpNafIiRiYNTqoEx
	WpjRRFz6ztrEuFmbDm8PTHaQeSZ04+nFf+ncFYdLm6NrLp9tdq1iU77b4TXp0IQPaqF7Mj08
	JrOu/x9ceuKUh/CiDXGfH27NvP3O2vXQyfevJq5q5l30Tzqf0+/0nvv919SsfJn3CUxvDbdc
	UxZp+NpRsEU3PKLDQOu189x9cTycqf+PnPymxFKckWioxVxUnAgA/94eLN4BAAA=
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

