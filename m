Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab3KSLOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 06:14:22 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:34602 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab3KSLMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 06:12:45 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org
Subject: [PATCH 3/9] c6x: Remove duplicate DT selection logic
Date: Tue, 19 Nov 2013 12:12:28 +0100
Message-Id: <1384859554-27268-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384859554-27268-1-git-send-email-geert@linux-m68k.org>
References: <5283A000.8090007@gmail.com>
 <1384859554-27268-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

early_init_dt_scan() now takes care of falling back to the built-in DTB.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: linux-c6x-dev@linux-c6x.org
---
 arch/c6x/kernel/setup.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/c6x/kernel/setup.c b/arch/c6x/kernel/setup.c
index 414353027ba9..ad7c5d73bb3c 100644
--- a/arch/c6x/kernel/setup.c
+++ b/arch/c6x/kernel/setup.c
@@ -266,7 +266,6 @@ int __init c6x_add_memory(phys_addr_t start, unsigned long size)
 notrace void __init machine_init(unsigned long dt_ptr)
 {
 	struct boot_param_header *dtb = __va(dt_ptr);
-	struct boot_param_header *fdt = &__dtb_start;
 
 	/* interrupts must be masked */
 	set_creg(IER, 2);
@@ -279,15 +278,8 @@ notrace void __init machine_init(unsigned long dt_ptr)
 
 	lockdep_init();
 
-	/*
-	 * dtb is passed in from bootloader.
-	 * fdt is linked in blob.
-	 */
-	if (dtb && dtb != fdt)
-		fdt = dtb;
-
 	/* Do some early initialization based on the flat device tree */
-	early_init_dt_scan(fdt);
+	early_init_dt_scan(dtb);
 
 	parse_early_param();
 }
-- 
1.7.9.5

