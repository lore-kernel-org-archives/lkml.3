Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbaBUNwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:52:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46817 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932AbaBUMtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vinayak Kale <vkale@apm.com>, Catalin Marinas <catalin.marinas@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 026/121] arm64: add DSB after icache flush in __flush_icache_all()
Date: Fri, 21 Feb 2014 12:47:30 +0000
Message-Id: <1392986945-9693-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinayak Kale <vkale@apm.com>

commit 5044bad43ee573d0b6d90e3ccb7a40c2c7d25eb4 upstream.

Add DSB after icache flush to complete the cache maintenance operation.
The function __flush_icache_all() is used only for user space mappings
and an ISB is not required because of an exception return before executing
user instructions. An exception return would behave like an ISB.

Signed-off-by: Vinayak Kale <vkale@apm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/include/asm/cacheflush.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
index fea9ee3..88932498 100644
--- a/arch/arm64/include/asm/cacheflush.h
+++ b/arch/arm64/include/asm/cacheflush.h
@@ -116,6 +116,7 @@ extern void flush_dcache_page(struct page *);
 static inline void __flush_icache_all(void)
 {
 	asm("ic	ialluis");
+	dsb();
 }
 
 #define flush_dcache_mmap_lock(mapping) \
-- 
1.9.0

