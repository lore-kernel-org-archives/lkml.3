Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab3AQCzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:55:01 -0500
Received: from smtp.outflux.net ([198.145.64.163]:46967 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758901Ab3AQCy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:59 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 33/86] arch/powerpc: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:25 -0800
Message-Id: <1358391258-1771-34-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358391258-1771-1-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/powerpc/Kconfig |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 17903f1..e027f04 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -334,7 +334,7 @@ config SWIOTLB
 
 config HOTPLUG_CPU
 	bool "Support for enabling/disabling CPUs"
-	depends on SMP && HOTPLUG && EXPERIMENTAL && (PPC_PSERIES || \
+	depends on SMP && HOTPLUG && (PPC_PSERIES || \
 	PPC_PMAC || PPC_POWERNV || (PPC_85xx && !PPC_E500MC))
 	---help---
 	  Say Y here to be able to disable and re-enable individual
@@ -356,8 +356,8 @@ config ARCH_ENABLE_MEMORY_HOTREMOVE
 	def_bool y
 
 config KEXEC
-	bool "kexec system call (EXPERIMENTAL)"
-	depends on (PPC_BOOK3S || FSL_BOOKE || (44x && !SMP)) && EXPERIMENTAL
+	bool "kexec system call"
+	depends on (PPC_BOOK3S || FSL_BOOKE || (44x && !SMP))
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
@@ -852,8 +852,8 @@ config LOWMEM_CAM_NUM
 	default 3
 
 config DYNAMIC_MEMSTART
-	bool "Enable page aligned dynamic load address for kernel (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && ADVANCED_OPTIONS && FLATMEM && (FSL_BOOKE || 44x)
+	bool "Enable page aligned dynamic load address for kernel"
+	depends on ADVANCED_OPTIONS && FLATMEM && (FSL_BOOKE || 44x)
 	select NONSTATIC_KERNEL
 	help
 	  This option enables the kernel to be loaded at any page aligned
@@ -870,8 +870,8 @@ config DYNAMIC_MEMSTART
 	  This option is overridden by CONFIG_RELOCATABLE
 
 config RELOCATABLE
-	bool "Build a relocatable kernel (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && ADVANCED_OPTIONS && FLATMEM && 44x
+	bool "Build a relocatable kernel"
+	depends on ADVANCED_OPTIONS && FLATMEM && 44x
 	select NONSTATIC_KERNEL
 	help
 	  This builds a kernel image that is capable of running at the
-- 
1.7.9.5

