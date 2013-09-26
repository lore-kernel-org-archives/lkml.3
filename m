Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab3IZSva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:51:30 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:55410 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab3IZSvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:51:24 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        James Hogan <james.hogan@imgtec.com>, linux-metag@vger.kernel.org
Subject: [PATCH 08/21] metag: move setup_machine_fdt declaration from prom.h
Date: Thu, 26 Sep 2013 13:50:43 -0500
Message-Id: <1380221456-11192-9-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Move setup_machine_fdt out of prom.h and into asm/setup.h in preparation
to remove prom.h.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: linux-metag@vger.kernel.org
---
 arch/metag/include/asm/prom.h  | 2 --
 arch/metag/include/asm/setup.h | 1 +
 arch/metag/kernel/setup.c      | 1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/metag/include/asm/prom.h b/arch/metag/include/asm/prom.h
index d2aa35d..e19022c 100644
--- a/arch/metag/include/asm/prom.h
+++ b/arch/metag/include/asm/prom.h
@@ -14,10 +14,8 @@
 #ifndef __ASM_METAG_PROM_H
 #define __ASM_METAG_PROM_H
 
-#include <asm/setup.h>
 #define HAVE_ARCH_DEVTREE_FIXUPS
 
-extern struct machine_desc *setup_machine_fdt(void *dt);
 extern void copy_fdt(void);
 
 #endif /* __ASM_METAG_PROM_H */
diff --git a/arch/metag/include/asm/setup.h b/arch/metag/include/asm/setup.h
index e13083b..c7aedd4 100644
--- a/arch/metag/include/asm/setup.h
+++ b/arch/metag/include/asm/setup.h
@@ -3,6 +3,7 @@
 
 #include <uapi/asm/setup.h>
 
+extern struct machine_desc *setup_machine_fdt(void *dt);
 void per_cpu_trap_init(unsigned long);
 extern void __init dump_machine_table(void);
 #endif /* _ASM_METAG_SETUP_H */
diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
index c396cd0..5d5c2b8 100644
--- a/arch/metag/kernel/setup.c
+++ b/arch/metag/kernel/setup.c
@@ -42,7 +42,6 @@
 #include <asm/mmu.h>
 #include <asm/mmzone.h>
 #include <asm/processor.h>
-#include <asm/prom.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/traps.h>
-- 
1.8.1.2

