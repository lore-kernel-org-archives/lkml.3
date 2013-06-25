Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab3FYTmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:42:15 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:53272 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab3FYTmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 15:42:10 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Creasey <sammy@sammy.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] m68k: Mark functions only called from setup_arch() __init
Date: Tue, 25 Jun 2013 21:42:05 +0200
Message-Id: <1372189326-12230-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some functions that are only called (indirectly) from setup_arch() lack
__init annotations.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/emu/natfeat.c   |    3 ++-
 arch/m68k/sun3/dvma.c     |    6 ++----
 arch/m68k/sun3/mmu_emu.c  |    3 ++-
 arch/m68k/sun3/sun3dvma.c |    3 ++-
 4 files changed, 8 insertions(+), 7 deletions(-)

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

