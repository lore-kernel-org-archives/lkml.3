Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbaC0Tnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 15:43:51 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:54330 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054AbaC0TmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 15:42:13 -0400
From: Rob Herring <robherring2@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Rob Herring <robh@kernel.org>
Subject: [RFC PATCH 3/4] vmlinuz.lds: define OF table sections with macros
Date: Thu, 27 Mar 2014 14:41:56 -0500
Message-Id: <1395949317-8738-4-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395949317-8738-1-git-send-email-robherring2@gmail.com>
References: <1395949317-8738-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

OF table sections all have the same pattern, so create a macro to define
them and insure consistency.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/vmlinux.lds.h | 58 ++++++++++-----------------------------
 1 file changed, 14 insertions(+), 44 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index d09e670..000a0f30 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -139,52 +139,22 @@
 #define TRACE_SYSCALLS()
 #endif
 
-#ifdef CONFIG_CLKSRC_OF
-#define CLKSRC_OF_TABLES() . = ALIGN(8);				\
-			   VMLINUX_SYMBOL(__clksrc_of_table) = .;	\
-			   *(__clksrc_of_table)				\
-			   *(__clksrc_of_table_end)
-#else
-#define CLKSRC_OF_TABLES()
-#endif
 
-#ifdef CONFIG_IRQCHIP
-#define IRQCHIP_OF_MATCH_TABLE()					\
+#define ___OF_TABLE(cfg, name)	_OF_TABLE_##cfg(name)
+#define __OF_TABLE(cfg, name)	___OF_TABLE(cfg, name)
+#define OF_TABLE(cfg, name)	__OF_TABLE(config_enabled(cfg), name)
+#define _OF_TABLE_0(name)
+#define _OF_TABLE_1(name)						\
 	. = ALIGN(8);							\
-	VMLINUX_SYMBOL(__irqchip_of_table) = .;				\
-	*(__irqchip_of_table)		  				\
-	*(__irqchip_of_table_end)
-#else
-#define IRQCHIP_OF_MATCH_TABLE()
-#endif
-
-#ifdef CONFIG_COMMON_CLK
-#define CLK_OF_TABLES() . = ALIGN(8);				\
-			VMLINUX_SYMBOL(__clk_of_table) = .;	\
-			*(__clk_of_table)			\
-			*(__clk_of_table_end)
-#else
-#define CLK_OF_TABLES()
-#endif
-
-#ifdef CONFIG_SMP
-#define CPU_METHOD_OF_TABLES() . = ALIGN(8);				    \
-			   VMLINUX_SYMBOL(__cpu_method_of_table) = .; \
-			   *(__cpu_method_of_table)			    \
-			   *(__cpu_method_of_table_end)
-#else
-#define CPU_METHOD_OF_TABLES()
-#endif
-
-#ifdef CONFIG_OF_RESERVED_MEM
-#define RESERVEDMEM_OF_TABLES()				\
-	. = ALIGN(8);					\
-	VMLINUX_SYMBOL(__reservedmem_of_table) = .;	\
-	*(__reservedmem_of_table)			\
-	*(__reservedmem_of_table_end)
-#else
-#define RESERVEDMEM_OF_TABLES()
-#endif
+	VMLINUX_SYMBOL(__##name##_of_table) = .;			\
+	*(__##name##_of_table)						\
+	*(__##name##_of_table_end)
+
+#define CLKSRC_OF_TABLES()	OF_TABLE(CONFIG_CLKSRC_OF, clksrc)
+#define IRQCHIP_OF_MATCH_TABLE() OF_TABLE(CONFIG_IRQCHIP, irqchip)
+#define CLK_OF_TABLES()		OF_TABLE(CONFIG_COMMON_CLK, clk)
+#define CPU_METHOD_OF_TABLES()	OF_TABLE(CONFIG_SMP, cpu_method)
+#define RESERVEDMEM_OF_TABLES()	OF_TABLE(CONFIG_OF_RESERVED_MEM, reservedmem)
 
 #define KERNEL_DTB()							\
 	STRUCT_ALIGN();							\
-- 
1.8.3.2

