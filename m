Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaJAO05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:26:57 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:37132 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaJAO04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:26:56 -0400
MIME-Version: 1.0
Date: Wed, 1 Oct 2014 22:26:55 +0800
Message-ID: <CAHkaATTho2U=cy8Ee0BD2oSp=4Vpb0GhTqUzEOCW0Jdw8u0ENw@mail.gmail.com>
Subject: [PATCH] Use phys_addr_t type for physical address (arm64)
From: Min-Hua Chen <orca.chen@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found that valid_phys_addr_range does not use
phys_addr_t to describe physical address.
Is it better to change the type from unsigned long to phys_addr_t?

Thanks,
Min-Hua


Signed-off-by: Min-Hua Chen<orca.chen@gmail.com>
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index e0ecdcf..f771e8b 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -243,7 +243,7 @@ extern void __iomem *ioremap_cache(phys_addr_t
phys_addr, size_t size);
  * (PHYS_OFFSET and PHYS_MASK taken into account).
  */
 #define ARCH_HAS_VALID_PHYS_ADDR_RANGE
-extern int valid_phys_addr_range(unsigned long addr, size_t size);
+extern int valid_phys_addr_range(phys_addr_t addr, size_t size);
 extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);

 extern int devmem_is_allowed(unsigned long pfn);
diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index 8ed6cb1..1d73662 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -102,7 +102,7 @@ EXPORT_SYMBOL_GPL(arch_pick_mmap_layout);
  * You really shouldn't be using read() or write() on /dev/mem.  This might go
  * away in the future.
  */
-int valid_phys_addr_range(unsigned long addr, size_t size)
+int valid_phys_addr_range(phys_addr_t addr, size_t size)
 {
     if (addr < PHYS_OFFSET)
         return 0;
-- 
1.7.10.4
