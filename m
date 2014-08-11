Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbaHKVSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 17:18:51 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60149 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbaHKVSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 17:18:49 -0400
Message-ID: <53E93334.5000205@gmail.com>
Date: Tue, 12 Aug 2014 05:18:44 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Jean Delvare <jdelvare@suse.de>,
        linux@arm.linux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com,
        tony.luck@intel.com, fenghua.yu@intel.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: Kconfig: Let all little endian architectures define
 CPU_LITTLE_ENDIAN explicitly
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86, ia64, and arm(64) are little endian, and also another architectures
may be little endian (mips, sh, powerpc, and m32r) which already marked
CPU_LITTLE_ENDIAN explicitly.

Some drivers (e.g. some of "drivers/isdn/hisax") may only support little
endian (CPU_LITTLE_ENDIAN), and some drivers may only support big endian
(!CPU_LITTLE_ENDIAN).

So export all little endian architectures within kernel wide, so can let
Kconfig easier for the modules which only support little endian or only
big endian.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/arm/Kconfig   | 3 +++
 arch/arm64/Kconfig | 3 +++
 arch/ia64/Kconfig  | 3 +++
 arch/x86/Kconfig   | 3 +++
 4 files changed, 12 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c49a775..bfc2c65 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -199,6 +199,9 @@ config NEED_DMA_MAP_STATE
 config ARCH_SUPPORTS_UPROBES
 	def_bool y
 
+config CPU_LITTLE_ENDIAN
+	def_bool y
+
 config ARCH_HAS_DMA_SET_COHERENT_MASK
 	bool
 
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 62b4ae1..69b893e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -129,6 +129,9 @@ config KERNEL_MODE_NEON
 config FIX_EARLYCON_MEM
 	def_bool y
 
+config CPU_LITTLE_ENDIAN
+	def_bool y
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 64aefb7..fa12d34 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -133,6 +133,9 @@ config AUDIT_ARCH
 	bool
 	default y
 
+config CPU_LITTLE_ENDIAN
+	def_bool y
+
 menuconfig PARAVIRT_GUEST
 	bool "Paravirtualized guest support"
 	depends on BROKEN
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 541e7cc..a1b3568 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -270,6 +270,9 @@ config ARCH_SUPPORTS_UPROBES
 config FIX_EARLYCON_MEM
 	def_bool y
 
+config CPU_LITTLE_ENDIAN
+	def_bool y
+
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
-- 
1.7.11.7
