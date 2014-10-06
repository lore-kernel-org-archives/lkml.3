Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbaJFNxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 09:53:04 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53536 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbaJFNw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 09:52:56 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Fengguang Wu <fengguang.wu@intel.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Sam Ravnborg <sam@ravnborg.org>,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] [IA64] Change xlate_dev_{kmem,mem}_ptr() prototypes
Date: Mon,  6 Oct 2014 15:52:36 +0200
Message-Id: <1412603561-27653-5-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412603561-27653-1-git-send-email-thierry.reding@gmail.com>
References: <1412603561-27653-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

xlate_dev_mem_ptr() is used to convert a physical address to an uncached
kernel virtual address mapping, so make it use phys_addr_t as type for
the physical address and return void * for the kernel virtual address.

xlate_dev_kmem_ptr() converts a cached kernel virtual address mapping to
an uncached kernel virtual address mapping, so make it use void * for
both the input parameter and return value.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/ia64/include/asm/uaccess.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/ia64/include/asm/uaccess.h b/arch/ia64/include/asm/uaccess.h
index 449c8c0fa2bd..103bedc59644 100644
--- a/arch/ia64/include/asm/uaccess.h
+++ b/arch/ia64/include/asm/uaccess.h
@@ -365,15 +365,15 @@ ia64_done_with_exception (struct pt_regs *regs)
 }
 
 #define ARCH_HAS_TRANSLATE_MEM_PTR	1
-static __inline__ char *
-xlate_dev_mem_ptr (unsigned long p)
+static __inline__ void *
+xlate_dev_mem_ptr(phys_addr_t p)
 {
 	struct page *page;
-	char * ptr;
+	void *ptr;
 
 	page = pfn_to_page(p >> PAGE_SHIFT);
 	if (PageUncached(page))
-		ptr = (char *)p + __IA64_UNCACHED_OFFSET;
+		ptr = (void *)p + __IA64_UNCACHED_OFFSET;
 	else
 		ptr = __va(p);
 
@@ -383,15 +383,15 @@ xlate_dev_mem_ptr (unsigned long p)
 /*
  * Convert a virtual cached kernel memory pointer to an uncached pointer
  */
-static __inline__ char *
-xlate_dev_kmem_ptr (char * p)
+static __inline__ void *
+xlate_dev_kmem_ptr(void *p)
 {
 	struct page *page;
-	char * ptr;
+	void *ptr;
 
 	page = virt_to_page((unsigned long)p);
 	if (PageUncached(page))
-		ptr = (char *)__pa(p) + __IA64_UNCACHED_OFFSET;
+		ptr = (void *)__pa(p) + __IA64_UNCACHED_OFFSET;
 	else
 		ptr = p;
 
-- 
2.1.0

