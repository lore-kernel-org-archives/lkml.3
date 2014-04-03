Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaDCWR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:17:58 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:40429 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbaDCWRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:17:38 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        James Hogan <james.hogan@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-metag@vger.kernel.org, linux-mips@linux-mips.org,
        linux@openrisc.net, linux-xtensa@linux-xtensa.org
Subject: [PATCH 08/20] of/fdt: consolidate built-in dtb section variables
Date: Thu,  3 Apr 2014 17:16:51 -0500
Message-Id: <1396563423-30893-9-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Unify the various architectures __dtb_start and __dtb_end definitions
moving them into of_fdt.h.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-metag@vger.kernel.org
Cc: linux-mips@linux-mips.org
Cc: linux@lists.openrisc.net
Cc: linux-xtensa@linux-xtensa.org
---
 arch/arc/include/asm/sections.h             | 1 -
 arch/metag/kernel/setup.c                   | 4 ----
 arch/mips/include/asm/mips-boards/generic.h | 2 --
 arch/mips/lantiq/prom.h                     | 2 --
 arch/mips/netlogic/xlp/dt.c                 | 2 +-
 arch/mips/ralink/of.c                       | 2 --
 arch/openrisc/kernel/vmlinux.h              | 2 --
 arch/xtensa/kernel/setup.c                  | 1 -
 include/linux/of_fdt.h                      | 3 +++
 9 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/arc/include/asm/sections.h b/arch/arc/include/asm/sections.h
index 764f1e3..09db952 100644
--- a/arch/arc/include/asm/sections.h
+++ b/arch/arc/include/asm/sections.h
@@ -12,6 +12,5 @@
 #include <asm-generic/sections.h>
 
 extern char __arc_dccm_base[];
-extern char __dtb_start[];
 
 #endif
diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
index 129c7cd..31cf53d 100644
--- a/arch/metag/kernel/setup.c
+++ b/arch/metag/kernel/setup.c
@@ -105,10 +105,6 @@
 
 extern char _heap_start[];
 
-#ifdef CONFIG_METAG_BUILTIN_DTB
-extern u32 __dtb_start[];
-#endif
-
 #ifdef CONFIG_DA_CONSOLE
 /* Our early channel based console driver */
 extern struct console dash_console;
diff --git a/arch/mips/include/asm/mips-boards/generic.h b/arch/mips/include/asm/mips-boards/generic.h
index b969491..c904c24 100644
--- a/arch/mips/include/asm/mips-boards/generic.h
+++ b/arch/mips/include/asm/mips-boards/generic.h
@@ -67,8 +67,6 @@
 
 extern int mips_revision_sconid;
 
-extern char __dtb_start[];
-
 #ifdef CONFIG_PCI
 extern void mips_pcibios_init(void);
 #else
diff --git a/arch/mips/lantiq/prom.h b/arch/mips/lantiq/prom.h
index 69a4c58..bfd2d58 100644
--- a/arch/mips/lantiq/prom.h
+++ b/arch/mips/lantiq/prom.h
@@ -26,6 +26,4 @@ struct ltq_soc_info {
 extern void ltq_soc_detect(struct ltq_soc_info *i);
 extern void ltq_soc_init(void);
 
-extern char __dtb_start[];
-
 #endif
diff --git a/arch/mips/netlogic/xlp/dt.c b/arch/mips/netlogic/xlp/dt.c
index 7f9615a..bdde331 100644
--- a/arch/mips/netlogic/xlp/dt.c
+++ b/arch/mips/netlogic/xlp/dt.c
@@ -42,7 +42,7 @@
 #include <asm/prom.h>
 
 extern u32 __dtb_xlp_evp_begin[], __dtb_xlp_svp_begin[],
-	__dtb_xlp_fvp_begin[], __dtb_xlp_gvp_begin[], __dtb_start[];
+	__dtb_xlp_fvp_begin[], __dtb_xlp_gvp_begin[];
 static void *xlp_fdt_blob;
 
 void __init *xlp_dt_init(void *fdtp)
diff --git a/arch/mips/ralink/of.c b/arch/mips/ralink/of.c
index 91d7060..2513952 100644
--- a/arch/mips/ralink/of.c
+++ b/arch/mips/ralink/of.c
@@ -28,8 +28,6 @@
 __iomem void *rt_sysc_membase;
 __iomem void *rt_memc_membase;
 
-extern char __dtb_start[];
-
 __iomem void *plat_of_remap_node(const char *node)
 {
 	struct resource res;
diff --git a/arch/openrisc/kernel/vmlinux.h b/arch/openrisc/kernel/vmlinux.h
index 70b9ce4..bbcdf21 100644
--- a/arch/openrisc/kernel/vmlinux.h
+++ b/arch/openrisc/kernel/vmlinux.h
@@ -5,6 +5,4 @@
 extern char __initrd_start, __initrd_end;
 #endif
 
-extern u32 __dtb_start[];
-
 #endif
diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 84fe931..89986e5 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -73,7 +73,6 @@ extern int initrd_below_start_ok;
 #endif
 
 #ifdef CONFIG_OF
-extern u32 __dtb_start[];
 void *dtb_start = __dtb_start;
 #endif
 
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index ddd7219..d4d0efe 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -80,6 +80,9 @@ extern int __initdata dt_root_addr_cells;
 extern int __initdata dt_root_size_cells;
 extern struct boot_param_header *initial_boot_params;
 
+extern char __dtb_start[];
+extern char __dtb_end[];
+
 /* For scanning the flat device-tree at boot time */
 extern char *find_flat_dt_string(u32 offset);
 extern int of_scan_flat_dt(int (*it)(unsigned long node, const char *uname,
-- 
1.8.3.2

