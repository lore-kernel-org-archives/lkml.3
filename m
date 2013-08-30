Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3H3CH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 22:07:58 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:25371 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3H3CH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 22:07:57 -0400
Message-ID: <521FFE3B.7040801@huawei.com>
Date: Fri, 30 Aug 2013 10:06:51 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <linux-parisc@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <sparclinux@vger.kernel.org>,
        <x86@kernel.org>
Subject: [PATCH 4/4] mm/arch: use NUMA_NODE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more appropriate NUMA_NO_NODE instead of -1 in some archs' module_alloc()

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
---
 arch/arm/kernel/module.c    |    2 +-
 arch/arm64/kernel/module.c  |    2 +-
 arch/mips/kernel/module.c   |    2 +-
 arch/parisc/kernel/module.c |    2 +-
 arch/s390/kernel/module.c   |    2 +-
 arch/sparc/kernel/module.c  |    2 +-
 arch/x86/kernel/module.c    |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index 85c3fb6..8f4cff3 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -40,7 +40,7 @@
 void *module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				GFP_KERNEL, PAGE_KERNEL_EXEC, -1,
+				GFP_KERNEL, PAGE_KERNEL_EXEC, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
 #endif
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index ca0e3d5..8f898bd 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -29,7 +29,7 @@
 void *module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				    GFP_KERNEL, PAGE_KERNEL_EXEC, -1,
+				    GFP_KERNEL, PAGE_KERNEL_EXEC, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
 
diff --git a/arch/mips/kernel/module.c b/arch/mips/kernel/module.c
index 977a623..b507e07 100644
--- a/arch/mips/kernel/module.c
+++ b/arch/mips/kernel/module.c
@@ -46,7 +46,7 @@ static DEFINE_SPINLOCK(dbe_lock);
 void *module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, MODULE_START, MODULE_END,
-				GFP_KERNEL, PAGE_KERNEL, -1,
+				GFP_KERNEL, PAGE_KERNEL, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
 #endif
diff --git a/arch/parisc/kernel/module.c b/arch/parisc/kernel/module.c
index 2a625fb..50dfafc 100644
--- a/arch/parisc/kernel/module.c
+++ b/arch/parisc/kernel/module.c
@@ -219,7 +219,7 @@ void *module_alloc(unsigned long size)
 	 * init_data correctly */
 	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
 				    GFP_KERNEL | __GFP_HIGHMEM,
-				    PAGE_KERNEL_RWX, -1,
+				    PAGE_KERNEL_RWX, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
 
diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index 7845e15..b89b591 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -50,7 +50,7 @@ void *module_alloc(unsigned long size)
 	if (PAGE_ALIGN(size) > MODULES_LEN)
 		return NULL;
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				    GFP_KERNEL, PAGE_KERNEL, -1,
+				    GFP_KERNEL, PAGE_KERNEL, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
 #endif
diff --git a/arch/sparc/kernel/module.c b/arch/sparc/kernel/module.c
index 4435488..97655e0 100644
--- a/arch/sparc/kernel/module.c
+++ b/arch/sparc/kernel/module.c
@@ -29,7 +29,7 @@ static void *module_map(unsigned long size)
 	if (PAGE_ALIGN(size) > MODULES_LEN)
 		return NULL;
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				GFP_KERNEL, PAGE_KERNEL, -1,
+				GFP_KERNEL, PAGE_KERNEL, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
 #else
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 216a4d7..18be189 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -49,7 +49,7 @@ void *module_alloc(unsigned long size)
 		return NULL;
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
 				GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC,
-				-1, __builtin_return_address(0));
+				NUMA_NO_NODE, __builtin_return_address(0));
 }
 
 #ifdef CONFIG_X86_32
-- 
1.7.1


