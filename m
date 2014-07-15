Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbaGOXvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:51:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933610AbaGOXNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:13:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.14 58/66] powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64
Date: Tue, 15 Jul 2014 16:17:52 -0700
Message-Id: <20140715231704.615538555@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231702.156040999@linuxfoundation.org>
References: <20140715231702.156040999@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -410,7 +410,7 @@ config KEXEC
 config CRASH_DUMP
 	bool "Build a kdump crash kernel"
 	depends on PPC64 || 6xx || FSL_BOOKE || (44x && !SMP)
-	select RELOCATABLE if PPC64 || 44x || FSL_BOOKE
+	select RELOCATABLE if (PPC64 && !COMPILE_TEST) || 44x || FSL_BOOKE
 	help
 	  Build a kernel suitable for use as a kdump capture kernel.
 	  The same kernel binary can be used as production kernel and dump
@@ -1000,6 +1000,7 @@ endmenu
 if PPC64
 config RELOCATABLE
 	bool "Build a relocatable kernel"
+	depends on !COMPILE_TEST
 	select NONSTATIC_KERNEL
 	help
 	  This builds a kernel image that is capable of running anywhere


