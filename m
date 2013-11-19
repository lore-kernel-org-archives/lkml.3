Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab3KSLNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 06:13:35 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:42776 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3KSLMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 06:12:45 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 5/9] microblaze: Use NULL as the default DTB
Date: Tue, 19 Nov 2013 12:12:30 +0100
Message-Id: <1384859554-27268-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384859554-27268-1-git-send-email-geert@linux-m68k.org>
References: <5283A000.8090007@gmail.com>
 <1384859554-27268-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

early_init_dt_scan() now takes care of falling back to the built-in DTB,
and printing what it did.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au
---
Note: I did not remove the now-unused fdt parameter from
      machine_early_init(), as this would require quite some changes
      to head.S. BTW, cmdline is also unused.

 arch/microblaze/kernel/setup.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/setup.c
index a4534f584be0..a9a9f8baa94a 100644
--- a/arch/microblaze/kernel/setup.c
+++ b/arch/microblaze/kernel/setup.c
@@ -136,7 +136,7 @@ void __init machine_early_init(const char *cmdline, unsigned int ram,
 	lockdep_init();
 
 /* initialize device tree for usage in early_printk */
-	early_init_devtree(&__dtb_start);
+	early_init_devtree(NULL);
 
 #ifdef CONFIG_EARLY_PRINTK
 	setup_early_printk(NULL);
@@ -149,10 +149,6 @@ void __init machine_early_init(const char *cmdline, unsigned int ram,
 							tlb1, kernel_tlb); */
 
 	pr_info("Ramdisk addr 0x%08x, ", ram);
-	if (fdt)
-		pr_info("FDT at 0x%08x\n", fdt);
-	else
-		pr_info("Compiled-in FDT at %p\n", &__dtb_start);
 
 #ifdef CONFIG_MTD_UCLINUX
 	pr_info("Found romfs @ 0x%08x (0x%08x)\n",
-- 
1.7.9.5

