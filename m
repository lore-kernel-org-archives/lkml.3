Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab3LWOGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 09:06:45 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:44220 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361Ab3LWOGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 09:06:43 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux@arm.linux.org.uk, catalin.marinas@arm.com, viro@zeniv.linux.org.uk,
        nico@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 1/5] ARM: add support for AT_HWCAP2 ELF auxv entry
Date: Mon, 23 Dec 2013 15:06:28 +0100
Message-Id: <1387807592-26375-2-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387807592-26375-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1387807592-26375-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables AT_HWCAP2 for ARM. The generic support for this
new ELF auxv entry was added in commit 2171364d1a9 (powerpc:
Add HWCAP2 aux entry)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/include/asm/hwcap.h      |  3 ++-
 arch/arm/include/uapi/asm/hwcap.h |  4 ++++
 arch/arm/kernel/setup.c           | 11 +++++++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/hwcap.h b/arch/arm/include/asm/hwcap.h
index 6ff56ec..6e183fd 100644
--- a/arch/arm/include/asm/hwcap.h
+++ b/arch/arm/include/asm/hwcap.h
@@ -9,6 +9,7 @@
  * instruction set this cpu supports.
  */
 #define ELF_HWCAP	(elf_hwcap)
-extern unsigned int elf_hwcap;
+#define ELF_HWCAP2	(elf_hwcap2)
+extern unsigned int elf_hwcap, elf_hwcap2;
 #endif
 #endif
diff --git a/arch/arm/include/uapi/asm/hwcap.h b/arch/arm/include/uapi/asm/hwcap.h
index 7dcc10d..87768b5 100644
--- a/arch/arm/include/uapi/asm/hwcap.h
+++ b/arch/arm/include/uapi/asm/hwcap.h
@@ -28,4 +28,8 @@
 #define HWCAP_LPAE	(1 << 20)
 #define HWCAP_EVTSTRM	(1 << 21)
 
+/*
+ * HWCAP2 flags - for elf_hwcap2 (in kernel) and AT_HWCAP2
+ */
+
 #endif /* _UAPI__ASMARM_HWCAP_H */
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 987a7f5..ce3049c 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -100,6 +100,9 @@ EXPORT_SYMBOL(system_serial_high);
 unsigned int elf_hwcap __read_mostly;
 EXPORT_SYMBOL(elf_hwcap);
 
+unsigned int elf_hwcap2 __read_mostly;
+EXPORT_SYMBOL(elf_hwcap2);
+
 
 #ifdef MULTI_CPU
 struct processor processor __read_mostly;
@@ -992,6 +995,10 @@ static const char *hwcap_str[] = {
 	NULL
 };
 
+static const char *hwcap2_str[] = {
+	NULL
+};
+
 static int c_show(struct seq_file *m, void *v)
 {
 	int i, j;
@@ -1015,6 +1022,10 @@ static int c_show(struct seq_file *m, void *v)
 			if (elf_hwcap & (1 << j))
 				seq_printf(m, "%s ", hwcap_str[j]);
 
+		for (j = 0; hwcap2_str[j]; j++)
+			if (elf_hwcap2 & (1 << j))
+				seq_printf(m, "%s ", hwcap2_str[j]);
+
 		seq_printf(m, "\nCPU implementer\t: 0x%02x\n", cpuid >> 24);
 		seq_printf(m, "CPU architecture: %s\n",
 			   proc_arch[cpu_architecture()]);
-- 
1.8.3.2

