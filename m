Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161097AbaGRNPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:15:30 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17817 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161081AbaGRNPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:15:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 168/170] powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64
Date: Fri, 18 Jul 2014 14:12:53 +0200
Message-Id: <971e9bdb534582617b93084edab9b2d39ca4e875.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit fb43e8477ed9006c4f397f904c691a120503038c upstream.

powerpc:allmodconfig has been failing for some time with the following
error.

arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
arch/powerpc/kernel/exceptions-64s.S:1312: Error: attempt to move .org backwards
make[1]: *** [arch/powerpc/kernel/head_64.o] Error 1

A number of attempts to fix the problem by moving around code have been
unsuccessful and resulted in failed builds for some configurations and
the discovery of toolchain bugs.

Fix the problem by disabling RELOCATABLE for COMPILE_TEST builds instead.
While this is less than perfect, it avoids substantial code changes
which would otherwise be necessary just to make COMPILE_TEST builds
happy and might have undesired side effects.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 38f3b7e47ec5..d5d026b6d237 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -395,7 +395,7 @@ config KEXEC
 config CRASH_DUMP
 	bool "Build a kdump crash kernel"
 	depends on PPC64 || 6xx || FSL_BOOKE || (44x && !SMP)
-	select RELOCATABLE if PPC64 || 44x
+	select RELOCATABLE if (PPC64 && !COMPILE_TEST) || 44x
 	select DYNAMIC_MEMSTART if FSL_BOOKE
 	help
 	  Build a kernel suitable for use as a kdump capture kernel.
@@ -985,6 +985,7 @@ endmenu
 if PPC64
 config RELOCATABLE
 	bool "Build a relocatable kernel"
+	depends on !COMPILE_TEST
 	select NONSTATIC_KERNEL
 	help
 	  This builds a kernel image that is capable of running anywhere
-- 
2.0.0

