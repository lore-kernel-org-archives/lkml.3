Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422943Ab3FUA4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:56:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49973 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965865Ab3FUA4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:56:20 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        James Hogan <james.hogan@imgtec.com>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <x86@kernel.org>, <arm@kernel.org>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, <bigeasy@linutronix.de>,
        <robherring2@gmail.com>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-c6x-dev@linux-c6x.org>,
        <linux-mips@linux-mips.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-xtensa@linux-xtensa.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH] of: Specify initrd location using 64-bit
Date: Thu, 20 Jun 2013 20:52:36 -0400
Message-ID: <1371775956-16453-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some PAE architectures, the entire range of physical memory could reside
outside the 32-bit limit.  These systems need the ability to specify the
initrd location using 64-bit numbers.

This patch globally modifies the early_init_dt_setup_initrd_arch() function to
use 64-bit numbers instead of the current unsigned long.

Patch is refreshed version of Cyril's original patch against 3.10-rcx which
has few more arch's which needs to be patched. Have to drop Cyril's email
id since its broken now.

Boot tested on ARM platform and just build tested for x86 platform.
Technically it should not break anything but cc list check if
it creates any issue for your arch.

Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: x86@kernel.org
Cc: arm@kernel.org
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: bigeasy@linutronix.de
Cc: robherring2@gmail.com
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>

Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-c6x-dev@linux-c6x.org
Cc: linux-mips@linux-mips.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-xtensa@linux-xtensa.org
Cc: devicetree-discuss@lists.ozlabs.org

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arc/mm/init.c            |    3 +--
 arch/arm/mm/init.c            |    2 +-
 arch/arm64/mm/init.c          |    3 +--
 arch/c6x/kernel/devicetree.c  |    3 +--
 arch/metag/mm/init.c          |    3 +--
 arch/microblaze/kernel/prom.c |    3 +--
 arch/mips/kernel/prom.c       |    3 +--
 arch/openrisc/kernel/prom.c   |    3 +--
 arch/powerpc/kernel/prom.c    |    3 +--
 arch/x86/kernel/devicetree.c  |    3 +--
 arch/xtensa/kernel/setup.c    |    3 +--
 drivers/of/fdt.c              |   10 ++++++----
 include/linux/of_fdt.h        |    3 +--
 13 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/arch/arc/mm/init.c b/arch/arc/mm/init.c
index 4a17736..3640c74 100644
--- a/arch/arc/mm/init.c
+++ b/arch/arc/mm/init.c
@@ -157,8 +157,7 @@ void __init free_initrd_mem(unsigned long start, unsigned long end)
 #endif
 
 #ifdef CONFIG_OF_FLATTREE
-void __init early_init_dt_setup_initrd_arch(unsigned long start,
-					    unsigned long end)
+void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
 {
 	pr_err("%s(%lx, %lx)\n", __func__, start, end);
 }
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 9a5cdc0..afeaef7 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -76,7 +76,7 @@ static int __init parse_tag_initrd2(const struct tag *tag)
 __tagtable(ATAG_INITRD2, parse_tag_initrd2);
 
 #ifdef CONFIG_OF_FLATTREE
-void __init early_init_dt_setup_initrd_arch(unsigned long start, unsigned long end)
+void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
 {
 	phys_initrd_start = start;
 	phys_initrd_size = end - start;
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index f497ca7..7047708 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -44,8 +44,7 @@ static unsigned long phys_initrd_size __initdata = 0;
 
 phys_addr_t memstart_addr __read_mostly = 0;
 
-void __init early_init_dt_setup_initrd_arch(unsigned long start,
-					    unsigned long end)
+void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
 {
 	phys_initrd_start = start;
 	phys_initrd_size = end - start;
diff --git a/arch/c6x/kernel/devicetree.c b/arch/c6x/kernel/devicetree.c
index bdb56f0..287d0e6 100644
--- a/arch/c6x/kernel/devicetree.c
+++ b/arch/c6x/kernel/devicetree.c
@@ -33,8 +33,7 @@ void __init early_init_devtree(void *params)
 
 
 #ifdef CONFIG_BLK_DEV_INITRD
-void __init early_init_dt_setup_initrd_arch(unsigned long start,
-		unsigned long end)
+void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
 {
 	initrd_start = (unsigned long)__va(start);
 	initrd_end = (unsigned long)__va(end);
diff --git a/arch/metag/mm/init.c b/arch/metag/mm/init.c
index d05b845..07b4412 100644
--- a/arch/metag/mm/init.c
+++ b/arch/metag/mm/init.c
@@ -419,8 +419,7 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 #endif
 
 #ifdef CONFIG_OF_FLATTREE
-void __init early_init_dt_setup_initrd_arch(unsigned long start,
-					    unsigned long end)
+void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
 {
 	pr_err("%s(%lx, %lx)\n",
 	       __func__, start, end);
diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index 0a2c68f..62e2e8f 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -136,8 +136,7 @@ void __init early_init_devtree(void *params)
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-void __init early_init_dt_setup_initrd_arch(unsigned long start,
-		unsigned long end)
+void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
 {
 	initrd_start = (unsigned long)__va(start);
 	initrd_end = (unsigned long)__va(end);
diff --git a/arch/mips/kernel/prom.c b/arch/mips/kernel/prom.c
index 5712bb5..32b8788 100644
--- a/arch/mips/kernel/prom.c
+++ b/arch/mips/kernel/prom.c
@@ -58,8 +58,7 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-void __init early_init_dt_setup_initrd_arch(unsigned long start,
-					    unsigned long end)
+void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
 {
 	initrd_start = (unsigned long)__va(start);
 	initrd_end = (unsigned long)__va(end);
diff --git a/arch/openrisc/kernel/prom.c b/arch/openrisc/kernel/prom.c
index 5869e3f..150215a 100644
--- a/arch/openrisc/kernel/prom.c
+++ b/arch/openrisc/kernel/prom.c
@@ -96,8 +96,7 @@ void __init early_init_devtree(void *params)
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-void __init early_init_dt_setup_initrd_arch(unsigned long start,
-		unsigned long end)
+void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
 {
 	initrd_start = (unsigned long)__va(start);
 	initrd_end = (unsigned long)__va(end);
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 8b6f7a9..2f3e252 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -550,8 +550,7 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-void __init early_init_dt_setup_initrd_arch(unsigned long start,
-		unsigned long end)
+void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
 {
 	initrd_start = (unsigned long)__va(start);
 	initrd_end = (unsigned long)__va(end);
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index b158152..2fbad6b 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -52,8 +52,7 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-void __init early_init_dt_setup_initrd_arch(unsigned long start,
-					    unsigned long end)
+void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
 {
 	initrd_start = (unsigned long)__va(start);
 	initrd_end = (unsigned long)__va(end);
diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 6dd25ec..d45e602 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -170,8 +170,7 @@ static int __init parse_tag_fdt(const bp_tag_t *tag)
 
 __tagtable(BP_TAG_FDT, parse_tag_fdt);
 
-void __init early_init_dt_setup_initrd_arch(unsigned long start,
-		unsigned long end)
+void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
 {
 	initrd_start = (void *)__va(start);
 	initrd_end = (void *)__va(end);
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 808be06..21123b8 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -550,7 +550,8 @@ int __init of_flat_dt_match(unsigned long node, const char *const *compat)
  */
 void __init early_init_dt_check_for_initrd(unsigned long node)
 {
-	unsigned long start, end, len;
+	u64 start, end;
+	unsigned long len;
 	__be32 *prop;
 
 	pr_debug("Looking for initrd properties... ");
@@ -558,15 +559,16 @@ void __init early_init_dt_check_for_initrd(unsigned long node)
 	prop = of_get_flat_dt_prop(node, "linux,initrd-start", &len);
 	if (!prop)
 		return;
-	start = of_read_ulong(prop, len/4);
+	start = of_read_number(prop, len/4);
 
 	prop = of_get_flat_dt_prop(node, "linux,initrd-end", &len);
 	if (!prop)
 		return;
-	end = of_read_ulong(prop, len/4);
+	end = of_read_number(prop, len/4);
 
 	early_init_dt_setup_initrd_arch(start, end);
-	pr_debug("initrd_start=0x%lx  initrd_end=0x%lx\n", start, end);
+	pr_debug("initrd_start=0x%llx  initrd_end=0x%llx\n",
+		 (unsigned long long)start, (unsigned long long)end);
 }
 #else
 inline void early_init_dt_check_for_initrd(unsigned long node)
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index ed136ad..4a17939 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -106,8 +106,7 @@ extern u64 dt_mem_next_cell(int s, __be32 **cellp);
  * physical addresses.
  */
 #ifdef CONFIG_BLK_DEV_INITRD
-extern void early_init_dt_setup_initrd_arch(unsigned long start,
-					    unsigned long end);
+extern void early_init_dt_setup_initrd_arch(u64 start, u64 end);
 #endif
 
 /* Early flat tree scan hooks */
-- 
1.7.9.5

