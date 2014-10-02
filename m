Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbaJBO5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:57:01 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:39193 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbaJBO5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:57:00 -0400
MIME-Version: 1.0
Date: Thu, 2 Oct 2014 22:56:59 +0800
Message-ID: <CAHkaATT2=WYuUA9yyWJbjChT43Fp-WZqgpgS-Twyd+AKHLHwxQ@mail.gmail.com>
Subject: [PATCH] [RESEND]arm64: Use phys_addr_t type for physical address
From: Min-Hua Chen <orca.chen@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the type of physical address from unsigned long to phys_addr_t,
make valid_phys_addr_range more readable.

Signed-off-by: Min-Hua Chen <orca.chen@gmail.com>
---
 arch/arm64/include/asm/io.h |    2 +-
 arch/arm64/mm/mmap.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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
