Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaAQJXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:23:37 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:42367 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbaAQJXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:23:21 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux@arm.linux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com,
        viro@zeniv.linux.org.uk, dave.martin@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: peter.maydell@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 resend 3/5] arm64: add AT_HWCAP2 support for 32-bit compat
Date: Fri, 17 Jan 2014 10:23:09 +0100
Message-Id: <1389950591-4212-4-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389950591-4212-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1389950591-4212-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the ELF auxv entry AT_HWCAP2 when running 32-bit
ELF binaries in compat mode.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/hwcap.h | 3 ++-
 arch/arm64/kernel/setup.c      | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index 6cddbb0c9f54..9a4cbd60c88e 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -41,7 +41,8 @@
 
 #ifdef CONFIG_COMPAT
 #define COMPAT_ELF_HWCAP	(compat_elf_hwcap)
-extern unsigned int compat_elf_hwcap;
+#define COMPAT_ELF_HWCAP2	(compat_elf_hwcap2)
+extern unsigned int compat_elf_hwcap, compat_elf_hwcap2;
 #endif
 
 extern unsigned long elf_hwcap;
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index bb33fff09ba2..15f3bd207981 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -69,6 +69,7 @@ EXPORT_SYMBOL_GPL(elf_hwcap);
 				 COMPAT_HWCAP_VFPv3|COMPAT_HWCAP_VFPv4|\
 				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV)
 unsigned int compat_elf_hwcap __read_mostly = COMPAT_ELF_HWCAP_DEFAULT;
+unsigned int compat_elf_hwcap2 __read_mostly;
 #endif
 
 static const char *cpu_name;
-- 
1.8.3.2

