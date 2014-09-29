Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaI2Ldg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 07:33:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbaI2Ldf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 07:33:35 -0400
From: Frantisek Hrbata <fhrbata@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, oleg@redhat.com, kamaleshb@in.ibm.com,
        hechjie@cn.ibm.com, akpm@linux-foundation.org, dave.hansen@intel.com,
        dvlasenk@redhat.com, prarit@redhat.com, lwoodman@redhat.com,
        hannsj_uhl@de.ibm.com, torvalds@linux-foundation.org
Subject: [RESEND PATCH 1/4] x86: add arch_pfn_possible helper
Date: Mon, 29 Sep 2014 13:32:59 +0200
Message-Id: <1411990382-11902-2-git-send-email-fhrbata@redhat.com>
In-Reply-To: <1411990382-11902-1-git-send-email-fhrbata@redhat.com>
References: <1411990382-11902-1-git-send-email-fhrbata@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helper to check maximum possible pfn on x86. Also make the current
phys_addr_valid helper using it internally.

Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
---
 arch/x86/mm/physaddr.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/physaddr.h b/arch/x86/mm/physaddr.h
index a3cd5a0..9df8e3a 100644
--- a/arch/x86/mm/physaddr.h
+++ b/arch/x86/mm/physaddr.h
@@ -1,10 +1,15 @@
 #include <asm/processor.h>
 
-static inline int phys_addr_valid(resource_size_t addr)
+static inline int arch_pfn_possible(unsigned long pfn)
 {
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
-	return !(addr >> boot_cpu_data.x86_phys_bits);
+	return !(pfn >> (boot_cpu_data.x86_phys_bits - PAGE_SHIFT));
 #else
 	return 1;
 #endif
 }
+
+static inline int phys_addr_valid(resource_size_t addr)
+{
+	return arch_pfn_possible(addr >> PAGE_SHIFT);
+}
-- 
1.9.3

