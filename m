Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab3F3Jzr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 05:55:47 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:46275 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3F3Jzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 05:55:45 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: Mark functions only called from setup_arch() __init
Date: Sun, 30 Jun 2013 11:55:42 +0200
Message-Id: <1372586142-1061-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some functions that are only called (indirectly) from setup_arch() lack
__init annotations.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v2:
  - Added various *_parse_bootinfo()
  - Added dn_setup_model(), psc_dma_die_die_die(), q40_disable_irqs()

 arch/m68k/amiga/config.c    |    2 +-
 arch/m68k/apollo/config.c   |   10 +++++-----
 arch/m68k/bvme6000/config.c |    2 +-
 arch/m68k/emu/natfeat.c     |    3 ++-
 arch/m68k/mac/psc.c         |    2 +-
 arch/m68k/mvme147/config.c  |    2 +-
 arch/m68k/mvme16x/config.c  |    2 +-
 arch/m68k/q40/config.c      |    4 ++--
 arch/m68k/sun3/dvma.c       |    6 ++----
 arch/m68k/sun3/mmu_emu.c    |    3 ++-
 arch/m68k/sun3/sun3dvma.c   |    3 ++-
 11 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index 87bbe2e..283b1f5 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -140,7 +140,7 @@ static struct resource ram_resource[NUM_MEMINFO];
      *  Parse an Amiga-specific record in the bootinfo
      */
 
-int amiga_parse_bootinfo(const struct bi_record *record)
+int __init amiga_parse_bootinfo(const struct bi_record *record)
 {
 	int unknown = 0;
 	const unsigned long *data = record->data;
diff --git a/arch/m68k/apollo/config.c b/arch/m68k/apollo/config.c
index 3ea56b9..2bdde96 100644
--- a/arch/m68k/apollo/config.c
+++ b/arch/m68k/apollo/config.c
@@ -1,3 +1,4 @@
+#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
@@ -43,8 +44,8 @@ static const char *apollo_models[] = {
 	[APOLLO_DN4500-APOLLO_DN3000] = "DN4500 (Roadrunner)"
 };
 
-int apollo_parse_bootinfo(const struct bi_record *record) {
-
+int __init apollo_parse_bootinfo(const struct bi_record *record)
+{
 	int unknown = 0;
 	const unsigned long *data = record->data;
 
@@ -60,9 +61,8 @@ int apollo_parse_bootinfo(const struct bi_record *record) {
 	return unknown;
 }
 
-void dn_setup_model(void) {
-
-
+static void __init dn_setup_model(void)
+{
 	printk("Apollo hardware found: ");
 	printk("[%s]\n", apollo_models[apollo_model - APOLLO_DN3000]);
 
diff --git a/arch/m68k/bvme6000/config.c b/arch/m68k/bvme6000/config.c
index 8943aa4..1b9e31e 100644
--- a/arch/m68k/bvme6000/config.c
+++ b/arch/m68k/bvme6000/config.c
@@ -50,7 +50,7 @@ void bvme6000_set_vectors (void);
 static irq_handler_t tick_handler;
 
 
-int bvme6000_parse_bootinfo(const struct bi_record *bi)
+int __init bvme6000_parse_bootinfo(const struct bi_record *bi)
 {
 	if (bi->tag == BI_VME_TYPE)
 		return 0;
diff --git a/arch/m68k/emu/natfeat.c b/arch/m68k/emu/natfeat.c
index 2291a7d..cb574ae 100644
--- a/arch/m68k/emu/natfeat.c
+++ b/arch/m68k/emu/natfeat.c
@@ -9,6 +9,7 @@
  * the GNU General Public License (GPL), incorporated herein by reference.
  */
 
+#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/console.h>
 #include <linux/string.h>
@@ -55,7 +56,7 @@ static void nf_poweroff(void)
 		nf_call(id);
 }
 
-void nf_init(void)
+void __init nf_init(void)
 {
 	unsigned long id, version;
 	char buf[256];
diff --git a/arch/m68k/mac/psc.c b/arch/m68k/mac/psc.c
index 6f026fc..cc9f3f0 100644
--- a/arch/m68k/mac/psc.c
+++ b/arch/m68k/mac/psc.c
@@ -54,7 +54,7 @@ static void psc_debug_dump(void)
  * expanded to cover what I think are the other 7 channels.
  */
 
-static void psc_dma_die_die_die(void)
+static __init void psc_dma_die_die_die(void)
 {
 	int i;
 
diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
index 1c62628..5c99154 100644
--- a/arch/m68k/mvme147/config.c
+++ b/arch/m68k/mvme147/config.c
@@ -51,7 +51,7 @@ static int bcd2int (unsigned char b);
 irq_handler_t tick_handler;
 
 
-int mvme147_parse_bootinfo(const struct bi_record *bi)
+int __init mvme147_parse_bootinfo(const struct bi_record *bi)
 {
 	if (bi->tag == BI_VME_TYPE || bi->tag == BI_VME_BRDINFO)
 		return 0;
diff --git a/arch/m68k/mvme16x/config.c b/arch/m68k/mvme16x/config.c
index 080a342..60d8a1b 100644
--- a/arch/m68k/mvme16x/config.c
+++ b/arch/m68k/mvme16x/config.c
@@ -60,7 +60,7 @@ unsigned short mvme16x_config;
 EXPORT_SYMBOL(mvme16x_config);
 
 
-int mvme16x_parse_bootinfo(const struct bi_record *bi)
+int __init mvme16x_parse_bootinfo(const struct bi_record *bi)
 {
 	if (bi->tag == BI_VME_TYPE || bi->tag == BI_VME_BRDINFO)
 		return 0;
diff --git a/arch/m68k/q40/config.c b/arch/m68k/q40/config.c
index 658542b..b809d35 100644
--- a/arch/m68k/q40/config.c
+++ b/arch/m68k/q40/config.c
@@ -154,7 +154,7 @@ static unsigned int serports[] =
 	0x3f8,0x2f8,0x3e8,0x2e8,0
 };
 
-static void q40_disable_irqs(void)
+static void __init q40_disable_irqs(void)
 {
 	unsigned i, j;
 
@@ -198,7 +198,7 @@ void __init config_q40(void)
 }
 
 
-int q40_parse_bootinfo(const struct bi_record *rec)
+int __init q40_parse_bootinfo(const struct bi_record *rec)
 {
 	return 1;
 }
diff --git a/arch/m68k/sun3/dvma.c b/arch/m68k/sun3/dvma.c
index d522eaa..d95506e 100644
--- a/arch/m68k/sun3/dvma.c
+++ b/arch/m68k/sun3/dvma.c
@@ -7,6 +7,7 @@
  *
  */
 
+#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/bootmem.h>
@@ -62,10 +63,7 @@ int dvma_map_iommu(unsigned long kaddr, unsigned long baddr,
 
 }
 
-void sun3_dvma_init(void)
+void __init sun3_dvma_init(void)
 {
-
 	memset(ptelist, 0, sizeof(ptelist));
-
-
 }
diff --git a/arch/m68k/sun3/mmu_emu.c b/arch/m68k/sun3/mmu_emu.c
index 8edc510..3f258e2 100644
--- a/arch/m68k/sun3/mmu_emu.c
+++ b/arch/m68k/sun3/mmu_emu.c
@@ -6,6 +6,7 @@
 ** Started 1/16/98 @ 2:22 am
 */
 
+#include <linux/init.h>
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/kernel.h>
@@ -122,7 +123,7 @@ void print_pte_vaddr (unsigned long vaddr)
 /*
  * Initialise the MMU emulator.
  */
-void mmu_emu_init(unsigned long bootmem_end)
+void __init mmu_emu_init(unsigned long bootmem_end)
 {
 	unsigned long seg, num;
 	int i,j;
diff --git a/arch/m68k/sun3/sun3dvma.c b/arch/m68k/sun3/sun3dvma.c
index cab5448..ca57966 100644
--- a/arch/m68k/sun3/sun3dvma.c
+++ b/arch/m68k/sun3/sun3dvma.c
@@ -6,6 +6,7 @@
  * Contains common routines for sun3/sun3x DVMA management.
  */
 
+#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/gfp.h>
@@ -245,7 +246,7 @@ static inline int free_baddr(unsigned long baddr)
 
 }
 
-void dvma_init(void)
+void __init dvma_init(void)
 {
 
 	struct hole *hole;
-- 
1.7.9.5

