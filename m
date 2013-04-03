Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491Ab3DCOYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:24:12 -0400
Received: from mail1.windriver.com ([147.11.146.13]:54774 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab3DCOYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:24:09 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, <linux-sh@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH-mmotm] sh4: make the bios early console support depend on EARLY_PRINTK
Date: Wed, 3 Apr 2013 10:23:09 -0400
Message-ID: <1364998989-27357-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit "early_printk: consolidate random copies of identical code"
introduces a build failure for the lboxre2_defconfig because arch/sh
unconditionally assumes that there will be an early_console struct
present that it can populate with bios routines to drive the
early printk support.

Making this whole block conditional on EARLY_PRINTK solves the
problem and gets rid of unused runtime code for when the feature
is disabled at the same time.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

Related mmotm patches:
   * early_printk-consolidate-random-copies-of-identical-code.patch
   * early_printk-consolidate-random-copies-of-identical-code-v3.patch
   * early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
   * include-linux-printkh-include-stdargh.patch
   
 arch/sh/kernel/sh_bios.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sh/kernel/sh_bios.c b/arch/sh/kernel/sh_bios.c
index a5b51b9..fe584e5 100644
--- a/arch/sh/kernel/sh_bios.c
+++ b/arch/sh/kernel/sh_bios.c
@@ -104,6 +104,7 @@ void sh_bios_vbr_reload(void)
 		);
 }
 
+#ifdef CONFIG_EARLY_PRINTK
 /*
  *	Print a string through the BIOS
  */
@@ -168,3 +169,4 @@ static int __init setup_early_printk(char *buf)
 	return 0;
 }
 early_param("earlyprintk", setup_early_printk);
+#endif
-- 
1.8.1.2

