Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab3KGRSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 12:18:08 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:65286 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3KGRRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 12:17:50 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, catalin.marinas@arm.com, will.deacon@arm.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 4/4] arm64: advertise CPU features using module aliases
Date: Thu,  7 Nov 2013 18:17:37 +0100
Message-Id: <1383844657-17487-5-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1383844657-17487-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1383844657-17487-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables the generic implementation in drivers/base/cpu.c
that allows modules to be loaded automatically based on the
optional features supported (and advertised) by the CPU.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig        | 3 +++
 arch/arm64/kernel/setup.c | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c044548..50cd97f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -202,6 +202,9 @@ config ARCH_WANT_HUGE_PMD_SHARE
 config HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	def_bool y
 
+config ARCH_HAS_CPU_AUTOPROBE
+	def_bool y
+
 source "mm/Kconfig"
 
 config XEN_DOM0
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 780a7aa..90d5277 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -403,3 +403,5 @@ const struct seq_operations cpuinfo_op = {
 	.stop	= c_stop,
 	.show	= c_show
 };
+
+extern u32 cpu_features __attribute__((alias("elf_hwcap")));
-- 
1.8.3.2

