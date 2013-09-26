Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3IZSvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:51:42 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:49865 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab3IZSve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:51:34 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Russell King <linux@arm.linux.org.uk>,
        James Hogan <james.hogan@imgtec.com>, Michal Simek <monstr@monstr.eu>,
        Jonas Bonn <jonas@southpole.se>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 15/21] of: remove HAVE_ARCH_DEVTREE_FIXUPS
Date: Thu, 26 Sep 2013 13:50:50 -0500
Message-Id: <1380221456-11192-16-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

HAVE_ARCH_DEVTREE_FIXUPS appears to always be needed except for sparc,
but it is only used for /proc/device-teee and sparc does not enable
/proc/device-tree. So this option is redundant. Remove the option and
always enable it. This has the side effect of fixing /proc/device-tree
on arches such as arm64 which failed to define this option.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/arc/include/asm/prom.h        | 2 --
 arch/arm/include/asm/prom.h        | 2 --
 arch/metag/include/asm/prom.h      | 1 -
 arch/microblaze/include/asm/prom.h | 2 --
 arch/openrisc/include/asm/prom.h   | 2 --
 arch/powerpc/include/asm/prom.h    | 2 --
 arch/x86/include/asm/prom.h        | 2 --
 arch/xtensa/include/asm/prom.h     | 2 --
 fs/proc/proc_devtree.c             | 3 ---
 9 files changed, 18 deletions(-)

diff --git a/arch/arc/include/asm/prom.h b/arch/arc/include/asm/prom.h
index 692d0d0..1555549 100644
--- a/arch/arc/include/asm/prom.h
+++ b/arch/arc/include/asm/prom.h
@@ -9,6 +9,4 @@
 #ifndef _ASM_ARC_PROM_H_
 #define _ASM_ARC_PROM_H_
 
-#define HAVE_ARCH_DEVTREE_FIXUPS
-
 #endif
diff --git a/arch/arm/include/asm/prom.h b/arch/arm/include/asm/prom.h
index 4a2985e..b681575 100644
--- a/arch/arm/include/asm/prom.h
+++ b/arch/arm/include/asm/prom.h
@@ -11,8 +11,6 @@
 #ifndef __ASMARM_PROM_H
 #define __ASMARM_PROM_H
 
-#define HAVE_ARCH_DEVTREE_FIXUPS
-
 #ifdef CONFIG_OF
 
 extern const struct machine_desc *setup_machine_fdt(unsigned int dt_phys);
diff --git a/arch/metag/include/asm/prom.h b/arch/metag/include/asm/prom.h
index e19022c..d4be144 100644
--- a/arch/metag/include/asm/prom.h
+++ b/arch/metag/include/asm/prom.h
@@ -14,7 +14,6 @@
 #ifndef __ASM_METAG_PROM_H
 #define __ASM_METAG_PROM_H
 
-#define HAVE_ARCH_DEVTREE_FIXUPS
 
 extern void copy_fdt(void);
 
diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
index 0ebd924..2f03ac8 100644
--- a/arch/microblaze/include/asm/prom.h
+++ b/arch/microblaze/include/asm/prom.h
@@ -16,8 +16,6 @@
 
 #include <linux/of.h>
 
-#define HAVE_ARCH_DEVTREE_FIXUPS
-
 /* Other Prototypes */
 enum early_consoles {
 	UARTLITE = 1,
diff --git a/arch/openrisc/include/asm/prom.h b/arch/openrisc/include/asm/prom.h
index 93c9980..bec477b 100644
--- a/arch/openrisc/include/asm/prom.h
+++ b/arch/openrisc/include/asm/prom.h
@@ -17,6 +17,4 @@
 #ifndef _ASM_OPENRISC_PROM_H
 #define _ASM_OPENRISC_PROM_H
 
-#define HAVE_ARCH_DEVTREE_FIXUPS
-
 #endif /* _ASM_OPENRISC_PROM_H */
diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index 6707c16..43fe002 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -20,8 +20,6 @@
 #include <asm/irq.h>
 #include <linux/atomic.h>
 
-#define HAVE_ARCH_DEVTREE_FIXUPS
-
 /*
  * OF address retreival & translation
  */
diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index 8ef2ec7..fbeb06e 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -39,7 +39,5 @@ static inline void x86_dtb_init(void) { }
 
 extern char cmd_line[COMMAND_LINE_SIZE];
 
-#define HAVE_ARCH_DEVTREE_FIXUPS
-
 #endif /* __ASSEMBLY__ */
 #endif
diff --git a/arch/xtensa/include/asm/prom.h b/arch/xtensa/include/asm/prom.h
index f3d7cd2..2a87a58 100644
--- a/arch/xtensa/include/asm/prom.h
+++ b/arch/xtensa/include/asm/prom.h
@@ -1,6 +1,4 @@
 #ifndef _XTENSA_ASM_PROM_H
 #define _XTENSA_ASM_PROM_H
 
-#define HAVE_ARCH_DEVTREE_FIXUPS
-
 #endif /* _XTENSA_ASM_PROM_H */
diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
index 106a835..70779b2 100644
--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -14,16 +14,13 @@
 #include <linux/of.h>
 #include <linux/export.h>
 #include <linux/slab.h>
-#include <asm/prom.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
 static inline void set_node_proc_entry(struct device_node *np,
 				       struct proc_dir_entry *de)
 {
-#ifdef HAVE_ARCH_DEVTREE_FIXUPS
 	np->pde = de;
-#endif
 }
 
 static struct proc_dir_entry *proc_device_tree;
-- 
1.8.1.2

