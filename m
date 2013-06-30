Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab3F3JsT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 05:48:19 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:53724 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3F3JsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 05:48:15 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k/setup: Use pr_*() instead of plain printk()
Date: Sun, 30 Jun 2013 11:48:09 +0200
Message-Id: <1372585689-29492-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/setup_mm.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c
index e67e531..a2c2c0c 100644
--- a/arch/m68k/kernel/setup_mm.c
+++ b/arch/m68k/kernel/setup_mm.c
@@ -161,7 +161,7 @@ static void __init m68k_parse_bootinfo(const struct bi_record *record)
 				m68k_memory[m68k_num_memory].size = data[1];
 				m68k_num_memory++;
 			} else
-				printk("m68k_parse_bootinfo: too many memory chunks\n");
+				pr_warn("m68k_parse_bootinfo: too many memory chunks\n");
 			break;
 
 		case BI_RAMDISK:
@@ -197,8 +197,8 @@ static void __init m68k_parse_bootinfo(const struct bi_record *record)
 				unknown = 1;
 		}
 		if (unknown)
-			printk("m68k_parse_bootinfo: unknown tag 0x%04x ignored\n",
-			       record->tag);
+			pr_warn("m68k_parse_bootinfo: unknown tag 0x%04x ignored\n",
+				   record->tag);
 		record = (struct bi_record *)((unsigned long)record +
 					      record->size);
 	}
@@ -206,8 +206,8 @@ static void __init m68k_parse_bootinfo(const struct bi_record *record)
 	m68k_realnum_memory = m68k_num_memory;
 #ifdef CONFIG_SINGLE_MEMORY_CHUNK
 	if (m68k_num_memory > 1) {
-		printk("Ignoring last %i chunks of physical memory\n",
-		       (m68k_num_memory - 1));
+		pr_warn("Ignoring last %i chunks of physical memory\n",
+			(m68k_num_memory - 1));
 		m68k_num_memory = 1;
 	}
 #endif
@@ -247,7 +247,7 @@ void __init setup_arch(char **cmdline_p)
 		asm (".chip 68060; movec %%pcr,%0; .chip 68k"
 		     : "=d" (pcr));
 		if (((pcr >> 8) & 0xff) <= 5) {
-			printk("Enabling workaround for errata I14\n");
+			pr_warn("Enabling workaround for errata I14\n");
 			asm (".chip 68060; movec %0,%%pcr; .chip 68k"
 			     : : "d" (pcr | 0x20));
 		}
@@ -353,7 +353,7 @@ void __init setup_arch(char **cmdline_p)
 				     BOOTMEM_DEFAULT);
 		initrd_start = (unsigned long)phys_to_virt(m68k_ramdisk.addr);
 		initrd_end = initrd_start + m68k_ramdisk.size;
-		printk("initrd: %08lx - %08lx\n", initrd_start, initrd_end);
+		pr_info("initrd: %08lx - %08lx\n", initrd_start, initrd_end);
 	}
 #endif
 
@@ -538,9 +538,9 @@ void check_bugs(void)
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

