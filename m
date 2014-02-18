Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbaBRQZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:25:32 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42524 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651AbaBRQZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:25:28 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lan Tianyu <tianyu.lan@intel.com>, Joe Perches <joe@perches.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v5 4/5] ACPI: Move BAD_MADT_ENTRY() to linux/acpi.h
Date: Wed, 19 Feb 2014 00:23:57 +0800
Message-Id: <1392740638-2479-5-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392740638-2479-1-git-send-email-hanjun.guo@linaro.org>
References: <1392740638-2479-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BAD_MADT_ENTRY() is arch independent and will be used for all
archs which parsing MADT table, so move it to linux/acpi.h to
simply the code.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/ia64/kernel/acpi.c     |    4 ----
 arch/x86/kernel/acpi/boot.c |    4 ----
 include/linux/acpi.h        |    4 ++++
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index af9d9e4..f7bd074 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -54,10 +54,6 @@
 #include <asm/sal.h>
 #include <asm/cyclone.h>
 
-#define BAD_MADT_ENTRY(entry, end) (                                        \
-		(!entry) || (unsigned long)entry + sizeof(*entry) > end ||  \
-		((struct acpi_subtable_header *)entry)->length < sizeof(*entry))
-
 #define PREFIX			"ACPI: "
 
 unsigned int acpi_cpei_override;
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 1dac942..123f9e3 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -53,10 +53,6 @@ EXPORT_SYMBOL(acpi_disabled);
 # include <asm/proto.h>
 #endif				/* X86 */
 
-#define BAD_MADT_ENTRY(entry, end) (					    \
-		(!entry) || (unsigned long)entry + sizeof(*entry) > end ||  \
-		((struct acpi_subtable_header *)entry)->length < sizeof(*entry))
-
 #define PREFIX			"ACPI: "
 
 int acpi_noirq;				/* skip ACPI IRQ initialization */
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 1151a1d..6a15ddd 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -108,6 +108,10 @@ static inline void acpi_initrd_override(void *data, size_t size)
 }
 #endif
 
+#define BAD_MADT_ENTRY(entry, end) (					    \
+		(!entry) || (unsigned long)entry + sizeof(*entry) > end ||  \
+		((struct acpi_subtable_header *)entry)->length < sizeof(*entry))
+
 char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
 void __acpi_unmap_table(char *map, unsigned long size);
 int early_acpi_boot_init(void);
-- 
1.7.9.5

