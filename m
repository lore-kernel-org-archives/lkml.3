Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab3KLTo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:44:26 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:47269 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab3KLTmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:42:47 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jonas Bonn <jonas@southpole.se>, linux@openrisc.net
Subject: [PATCH 13/17] openrisc: Refactor or32_early_setup()
Date: Tue, 12 Nov 2013 20:42:23 +0100
Message-Id: <1384285347-13506-14-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - Change fdt pointer (passed from head.S) from unsigned int to void *,
    which allows to kill a cast, and makes it compatible with __dtb_start.
  - Use pr_info(),
  - Extract common part.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: linux@lists.openrisc.net
---
 arch/openrisc/kernel/setup.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
index d0e7693c67a3..4fc7ccc0a2cf 100644
--- a/arch/openrisc/kernel/setup.c
+++ b/arch/openrisc/kernel/setup.c
@@ -208,15 +208,15 @@ void __init setup_cpuinfo(void)
  * Falls back on built-in device tree in case null pointer is passed.
  */
 
-void __init or32_early_setup(unsigned int fdt)
+void __init or32_early_setup(void *fdt)
 {
-	if (fdt) {
-		early_init_devtree((void*) fdt);
-		printk(KERN_INFO "FDT at 0x%08x\n", fdt);
-	} else {
-		early_init_devtree(__dtb_start);
-		printk(KERN_INFO "Compiled-in FDT at %p\n", __dtb_start);
+	if (fdt)
+		pr_info("FDT at %p\n", fdt);
+	else {
+		fdt = __dtb_start;
+		pr_info("Compiled-in FDT at %p\n", fdt);
 	}
+	early_init_devtree(fdt);
 }
 
 static int __init openrisc_device_probe(void)
-- 
1.7.9.5

