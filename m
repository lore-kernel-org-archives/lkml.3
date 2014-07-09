Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbaGILgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:36:39 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:45126 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbaGILgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:36:36 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-90-53bd2940cdc9
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
Subject: [RFC/PATCH RESEND -next 09/21] mm: Makefile: kasan: don't instrument
 slub.c and slab_common.c files
Date: Wed, 09 Jul 2014 15:30:03 +0400
Message-id: <1404905415-9046-10-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t/xy7oOmnuDDRYcsLHY9usRm8XvvTNZ
	LeasX8Nmcf3bG0aLCQ/b2C1WdjezWWx/9pbJYmXnA1aLTY+vsVr82bWDyeLyrjlsFvfW/Ge1
	uH2Z1+LSgQVMFi37LjBZtH3+x2qxb+V5IGvJRiaLxUduM1u8ezaZ2WLzpqnMFj82PGZ1EPNo
	ae5h89g56y67x4JNpR6bVnWyeWz6NIndo+vtFSaPd+fOsXucmPGbxePJlelMHpuX1Ht8fHqL
	xeP9vqtsHn1bVjF6nFlwhN3j8ya5AP4oLpuU1JzMstQifbsEroy3u1+xFSxmqZg2tZu5gXE3
	cxcjJ4eEgInE/O39bBC2mMSFe+vBbCGBpYwSG1YodDFyAdl9TBLfd29nAUmwCehJ/Ju1HaxI
	REBBYnPvM1aQImaBZjaJ9o4PrCAJYYE8iZdv9oDZLAKqEpv+N4Jt4xVwk/jcspMdYpuCxLLl
	M8FqOIHiE6ZfA6rhANrmKjFhhdoERt4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUIi
	6esOxqXHrA4xCnAwKvHwvti9J1iINbGsuDL3EKMEB7OSCK+t6N5gId6UxMqq1KL8+KLSnNTi
	Q4xMHJxSDYxhu5qK3op5WF14r2bRVryG9XJlQ83yTYlSp6UVnsZyNros8ZGpfPP+VMlJ36w8
	+WAbt781elbmibUX7t2wt3Mz+evW95Xp6Nu1ywISv5yeveKS0HZ28R2RzeWRYQv333TZGKY0
	qWM1z7dEXRmeG0VSW5ZY8NpNLzpg8+NIesLl3Ycfdd2J11FiKc5INNRiLipOBACuBTowggIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code in slub.c and slab_common.c files could validly access to object's
redzones

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 mm/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/Makefile b/mm/Makefile
index 6a9c3f8..59cc184 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -3,6 +3,8 @@
 #
 
 KASAN_SANITIZE_page_alloc.o := n
+KASAN_SANITIZE_slab_common.o := n
+KASAN_SANITIZE_slub.o := n
 
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= gup.o highmem.o madvise.o memory.o mincore.o \
-- 
1.8.5.5

