Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaI3Q1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:27:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbaI3Q0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:26:05 -0400
From: Frantisek Hrbata <fhrbata@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, oleg@redhat.com, kamaleshb@in.ibm.com,
        hechjie@cn.ibm.com, akpm@linux-foundation.org, dave.hansen@intel.com,
        dvlasenk@redhat.com, prarit@redhat.com, lwoodman@redhat.com,
        hannsj_uhl@de.ibm.com, torvalds@linux-foundation.org
Subject: [PATCH v2 4/4] x86: remove high_memory check from valid_phys_addr_range
Date: Tue, 30 Sep 2014 18:25:03 +0200
Message-Id: <1412094303-28183-5-git-send-email-fhrbata@redhat.com>
In-Reply-To: <1412094303-28183-1-git-send-email-fhrbata@redhat.com>
References: <1411990382-11902-1-git-send-email-fhrbata@redhat.com>
 <1412094303-28183-1-git-send-email-fhrbata@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to block read/write access to /dev/mem for phys. addr. above
high_memory for non-system RAM. The only limitation should be
boot_cpu_data.x86_phys_bits(max phys. addr. size).

Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
---
 arch/x86/mm/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 77a13f8..788f2b7 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -127,7 +127,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 
 int valid_phys_addr_range(phys_addr_t addr, size_t count)
 {
-	return addr + count <= __pa(high_memory);
+	return arch_pfn_possible((addr + count) >> PAGE_SHIFT);
 }
 
 int valid_mmap_phys_addr_range(unsigned long pfn, size_t len_bytes)
-- 
1.9.3

