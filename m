Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbbAUQzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:55:43 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41010 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbbAUQwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:52:37 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-b4-54bfd8bab05d
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-mm@kvack.org,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux390@de.ibm.com (supporter:S390),
        "David S. Miller" <davem@davemloft.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-mips@linux-mips.org (open list:MIPS),
        linux-parisc@vger.kernel.org (open list:PARISC ARCHITECTURE),
        linux-s390@vger.kernel.org (open list:S390),
        sparclinux@vger.kernel.org (open list:SPARC + UltraSPAR...)
Subject: [PATCH v9 14/17] mm: vmalloc: pass additional vm_flags to
 __vmalloc_node_range()
Date: Wed, 21 Jan 2015 19:51:42 +0300
Message-id: <1421859105-25253-15-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.1
In-reply-to: <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyWRa0iTcRSH/b97b64GL2b1Khay9IuiaQgdrKxA8yUi+qBGBerUocKmsjXR
	PoilGN6XpaaYmlLpWjm3apmKOsxLltq8hqXOK4O8baGVZG3t23N+POf8Phya5/Iad6eTU26K
	ZSkiiZDk40N7/RN+7dNdEQHdmfDm9wIJu51VBNS0qEnondyhYONpEYKp7e8ILOZ5BDUjuTjM
	WWYQrJpMFChNeRT0TG9T0DdqxqGi9TA0F+aQMPdSRYB+ZQ2D5vx5ArSLkwSMvashQVleRsGs
	+i8BCx9GMVA+zuGBedtKwMyYAIzd9RgYO7ygsXeGB9Zh2+3swSYC1lfu80CnLbepWwM4/NQs
	EueOcepaNeJyc4pI7lXzF4zrWTCQXF3bFuLaqr9R3OZWNFevVXCNHWaM06rySU5rKaO4grVx
	jFsfHqa4gYe7OPe++QXGLY1XYlfY6/zTCWJJcrpYdjwklp80UWRAaQMnMzTzg1Q20vgVIGea
	ZYLYuk0r5uBD7OhsC1mA+LQL8wSxJmMp7hhKMFbXqeLZLZLxZ/eq9aSdXRlPVle8QtglHrPJ
	Z3NLG20STR9gbrANlgt2B2e8Wf3Hrv+7Aiac3WlvoRxtR9nWr02EnZ1tedXIPcxRdgex1l49
	qUSCeuSkQgfFivg0eVyiNNBfLpLKFSmJ/vGpUi1yvPrHW9TYF2xADI2E+wUZkV0RLoQoXZ4p
	NSCW5gldBXVTtkiQIMq8JZalxsgUErHcgDDa2T0buUWajaHLvzxFlmL55WUnby+xZ1C40Xf9
	vOYUhqTRc1n7Jj7FdrRfUpZJKisiLibdjW64piP+nM3weabw7xV3eOw45x25fcIvPfe5qnAj
	yuBRuxq1VB6WEXz1THCovv9BAB33eTo1ohb5xkR1PhqPD28rUYYYY/oLworbLW5ZQ0JcniQK
	9OHJ5KJ/njT6VcgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For instrumenting global variables KASan will shadow memory backing
memory for modules. So on module loading we will need to allocate
shadow memory and map it at exact virtual address.
__vmalloc_node_range() seems like the best fit for that purpose,
except it puts a guard hole after allocated area.

Now we have VM_NO_GUARD flag disabling guard page, so we need to
pass into __vmalloc_node_range(). Add new parameter 'vm_flags'
to __vmalloc_node_range() function.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/arm/kernel/module.c       |  2 +-
 arch/arm64/kernel/module.c     |  2 +-
 arch/mips/kernel/module.c      |  2 +-
 arch/parisc/kernel/module.c    |  2 +-
 arch/s390/kernel/module.c      |  2 +-
 arch/sparc/kernel/module.c     |  2 +-
 arch/unicore32/kernel/module.c |  2 +-
 arch/x86/kernel/module.c       |  2 +-
 include/linux/vmalloc.h        |  4 +++-
 mm/vmalloc.c                   | 10 ++++++----
 10 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index bea7db9..2e11961 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -41,7 +41,7 @@
 void *module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				GFP_KERNEL, PAGE_KERNEL_EXEC, NUMA_NO_NODE,
+				GFP_KERNEL, PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
 #endif
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index 9b6f71d..5958d6d 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -35,7 +35,7 @@
 void *module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				    GFP_KERNEL, PAGE_KERNEL_EXEC, NUMA_NO_NODE,
+				    GFP_KERNEL, PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
 
diff --git a/arch/mips/kernel/module.c b/arch/mips/kernel/module.c
index 2a52568..1833f51 100644
--- a/arch/mips/kernel/module.c
+++ b/arch/mips/kernel/module.c
@@ -47,7 +47,7 @@ static DEFINE_SPINLOCK(dbe_lock);
 void *module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, MODULE_START, MODULE_END,
-				GFP_KERNEL, PAGE_KERNEL, NUMA_NO_NODE,
+				GFP_KERNEL, PAGE_KERNEL, 0, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
 #endif
diff --git a/arch/parisc/kernel/module.c b/arch/parisc/kernel/module.c
index 50dfafc..0d498ef 100644
--- a/arch/parisc/kernel/module.c
+++ b/arch/parisc/kernel/module.c
@@ -219,7 +219,7 @@ void *module_alloc(unsigned long size)
 	 * init_data correctly */
 	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
 				    GFP_KERNEL | __GFP_HIGHMEM,
-				    PAGE_KERNEL_RWX, NUMA_NO_NODE,
+				    PAGE_KERNEL_RWX, 0, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
 
diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index b89b591..411a7ee 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -50,7 +50,7 @@ void *module_alloc(unsigned long size)
 	if (PAGE_ALIGN(size) > MODULES_LEN)
 		return NULL;
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				    GFP_KERNEL, PAGE_KERNEL, NUMA_NO_NODE,
+				    GFP_KERNEL, PAGE_KERNEL, 0, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
 #endif
diff --git a/arch/sparc/kernel/module.c b/arch/sparc/kernel/module.c
index 97655e0..192a617 100644
--- a/arch/sparc/kernel/module.c
+++ b/arch/sparc/kernel/module.c
@@ -29,7 +29,7 @@ static void *module_map(unsigned long size)
 	if (PAGE_ALIGN(size) > MODULES_LEN)
 		return NULL;
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				GFP_KERNEL, PAGE_KERNEL, NUMA_NO_NODE,
+				GFP_KERNEL, PAGE_KERNEL, 0, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
 #else
diff --git a/arch/unicore32/kernel/module.c b/arch/unicore32/kernel/module.c
index dc41f6d..e191b34 100644
--- a/arch/unicore32/kernel/module.c
+++ b/arch/unicore32/kernel/module.c
@@ -25,7 +25,7 @@
 void *module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				GFP_KERNEL, PAGE_KERNEL_EXEC, NUMA_NO_NODE,
+				GFP_KERNEL, PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
 
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index e69f988..e830e61 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -88,7 +88,7 @@ void *module_alloc(unsigned long size)
 	return __vmalloc_node_range(size, 1,
 				    MODULES_VADDR + get_module_load_offset(),
 				    MODULES_END, GFP_KERNEL | __GFP_HIGHMEM,
-				    PAGE_KERNEL_EXEC, NUMA_NO_NODE,
+				    PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
 
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 1526fe7..7d7acb3 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -76,7 +76,9 @@ extern void *vmalloc_32_user(unsigned long size);
 extern void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot);
 extern void *__vmalloc_node_range(unsigned long size, unsigned long align,
 			unsigned long start, unsigned long end, gfp_t gfp_mask,
-			pgprot_t prot, int node, const void *caller);
+			pgprot_t prot, unsigned long vm_flags, int node,
+			const void *caller);
+
 extern void vfree(const void *addr);
 
 extern void *vmap(struct page **pages, unsigned int count,
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 2e74e99..35b25e1 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1619,6 +1619,7 @@ fail:
  *	@end:		vm area range end
  *	@gfp_mask:	flags for the page level allocator
  *	@prot:		protection mask for the allocated pages
+ *	@vm_flags:	additional vm area flags (e.g. %VM_NO_GUARD)
  *	@node:		node to use for allocation or NUMA_NO_NODE
  *	@caller:	caller's return address
  *
@@ -1628,7 +1629,8 @@ fail:
  */
 void *__vmalloc_node_range(unsigned long size, unsigned long align,
 			unsigned long start, unsigned long end, gfp_t gfp_mask,
-			pgprot_t prot, int node, const void *caller)
+			pgprot_t prot, unsigned long vm_flags, int node,
+			const void *caller)
 {
 	struct vm_struct *area;
 	void *addr;
@@ -1638,8 +1640,8 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
 		goto fail;
 
-	area = __get_vm_area_node(size, align, VM_ALLOC | VM_UNINITIALIZED,
-				  start, end, node, gfp_mask, caller);
+	area = __get_vm_area_node(size, align, VM_ALLOC | VM_UNINITIALIZED |
+				vm_flags, start, end, node, gfp_mask, caller);
 	if (!area)
 		goto fail;
 
@@ -1688,7 +1690,7 @@ static void *__vmalloc_node(unsigned long size, unsigned long align,
 			    int node, const void *caller)
 {
 	return __vmalloc_node_range(size, align, VMALLOC_START, VMALLOC_END,
-				gfp_mask, prot, node, caller);
+				gfp_mask, prot, 0, node, caller);
 }
 
 void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)
-- 
2.2.1

