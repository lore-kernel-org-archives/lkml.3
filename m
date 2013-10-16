Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760488Ab3JPKMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 06:12:25 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:35373 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758281Ab3JPKMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 06:12:23 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2] m68k/setup: Use pr_*() and __func__ instead of plain printk()
Date: Wed, 16 Oct 2013 12:12:15 +0200
Message-Id: <1381918335-23545-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v2:
  - Use __func__

 arch/m68k/kernel/setup_mm.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c
index 4f6158aa8d48..2299080d77f2 100644
--- a/arch/m68k/kernel/setup_mm.c
+++ b/arch/m68k/kernel/setup_mm.c
@@ -163,7 +163,8 @@ static void __init m68k_parse_bootinfo(const struct bi_record *record)
 				m68k_memory[m68k_num_memory].size = data[1];
 				m68k_num_memory++;
 			} else
-				printk("m68k_parse_bootinfo: too many memory chunks\n");
+				pr_warn("%s: too many memory chunks\n",
+					__func__);
 			break;
 
 		case BI_RAMDISK:
@@ -199,8 +200,8 @@ static void __init m68k_parse_bootinfo(const struct bi_record *record)
 				unknown = 1;
 		}
 		if (unknown)
-			printk("m68k_parse_bootinfo: unknown tag 0x%04x ignored\n",
-			       record->tag);
+			pr_warn("%s: unknown tag 0x%04x ignored\n", __func__,
+				   record->tag);
 		record = (struct bi_record *)((unsigned long)record +
 					      record->size);
 	}
@@ -208,8 +209,8 @@ static void __init m68k_parse_bootinfo(const struct bi_record *record)
 	m68k_realnum_memory = m68k_num_memory;
 #ifdef CONFIG_SINGLE_MEMORY_CHUNK
 	if (m68k_num_memory > 1) {
-		printk("Ignoring last %i chunks of physical memory\n",
-		       (m68k_num_memory - 1));
+		pr_warn("%s: ignoring last %i chunks of physical memory\n",
+			__func__, (m68k_num_memory - 1));
 		m68k_num_memory = 1;
 	}
 #endif
@@ -249,7 +250,7 @@ void __init setup_arch(char **cmdline_p)
 		asm (".chip 68060; movec %%pcr,%0; .chip 68k"
 		     : "=d" (pcr));
 		if (((pcr >> 8) & 0xff) <= 5) {
-			printk("Enabling workaround for errata I14\n");
+			pr_warn("Enabling workaround for errata I14\n");
 			asm (".chip 68060; movec %0,%%pcr; .chip 68k"
 			     : : "d" (pcr | 0x20));
 		}
@@ -355,7 +356,7 @@ void __init setup_arch(char **cmdline_p)
 				     BOOTMEM_DEFAULT);
 		initrd_start = (unsigned long)phys_to_virt(m68k_ramdisk.addr);
 		initrd_end = initrd_start + m68k_ramdisk.size;
-		printk("initrd: %08lx - %08lx\n", initrd_start, initrd_end);
+		pr_info("initrd: %08lx - %08lx\n", initrd_start, initrd_end);
 	}
 #endif
 
@@ -540,9 +541,9 @@ void check_bugs(void)
 {
 #ifndef CONFIG_M68KFPU_EMU
 	if (m68k_fputype == 0) {
-		printk(KERN_EMERG "*** YOU DO NOT HAVE A FLOATING POINT UNIT, "
+		pr_emerg("*** YOU DO NOT HAVE A FLOATING POINT UNIT, "
 			"WHICH IS REQUIRED BY LINUX/M68K ***\n");
-		printk(KERN_EMERG "Upgrade your hardware or join the FPU "
+		pr_emerg("Upgrade your hardware or join the FPU "
 			"emulation project\n");
 		panic("no FPU");
 	}
-- 
1.7.9.5

