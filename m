Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbaB0Qal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:30:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57134 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaB0Qaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:30:39 -0500
Date: Thu, 27 Feb 2014 08:30:26 -0800
From: tip-bot for Ross Zwisler <tipbot@zytor.com>
Message-ID: <tip-8b80fd8b45458a7d0b726d454c51c5219e0fb2ee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ross.zwisler@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ross.zwisler@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1393441612-19729-3-git-send-email-ross.zwisler@linux.intel.com>
References: <1393441612-19729-3-git-send-email-ross.zwisler@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Use clflushopt in clflush_cache_range
Git-Commit-ID: 8b80fd8b45458a7d0b726d454c51c5219e0fb2ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b80fd8b45458a7d0b726d454c51c5219e0fb2ee
Gitweb:     http://git.kernel.org/tip/8b80fd8b45458a7d0b726d454c51c5219e0fb2ee
Author:     Ross Zwisler <ross.zwisler@linux.intel.com>
AuthorDate: Wed, 26 Feb 2014 12:06:50 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 27 Feb 2014 08:26:10 -0800

x86: Use clflushopt in clflush_cache_range

If clflushopt is available on the system, use it instead of clflush in
clflush_cache_range.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Link: http://lkml.kernel.org/r/1393441612-19729-3-git-send-email-ross.zwisler@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/pageattr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index b3b19f4..b1c4672 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -126,8 +126,8 @@ within(unsigned long addr, unsigned long start, unsigned long end)
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
@@ -136,11 +136,11 @@ void clflush_cache_range(void *vaddr, unsigned int size)
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
