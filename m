Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaBZTMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:12:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:20204 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbaBZTJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:09:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,549,1389772800"; 
   d="scan'208";a="490301619"
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/4] x86: Use clflushopt in clflush_cache_range
Date: Wed, 26 Feb 2014 12:06:50 -0700
Message-Id: <1393441612-19729-3-git-send-email-ross.zwisler@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1393441612-19729-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1393441612-19729-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If clflushopt is available on the system, use it instead of clflush in
clflush_cache_range.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: H Peter Anvin <h.peter.anvin@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/mm/pageattr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index bb32480..11d500a 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -125,8 +125,8 @@ within(unsigned long addr, unsigned long start, unsigned long end)
  * @vaddr:	virtual start address
  * @size:	number of bytes to flush
  *
- * clflush is an unordered instruction which needs fencing with mfence
- * to avoid ordering issues.
+ * clflushopt is an unordered instruction which needs fencing with mfence or
+ * sfence to avoid ordering issues.
  */
 void clflush_cache_range(void *vaddr, unsigned int size)
 {
@@ -135,11 +135,11 @@ void clflush_cache_range(void *vaddr, unsigned int size)
 	mb();
 
 	for (; vaddr < vend; vaddr += boot_cpu_data.x86_clflush_size)
-		clflush(vaddr);
+		clflushopt(vaddr);
 	/*
 	 * Flush any possible final partial cacheline:
 	 */
-	clflush(vend);
+	clflushopt(vend);
 
 	mb();
 }
-- 
1.7.10.4

