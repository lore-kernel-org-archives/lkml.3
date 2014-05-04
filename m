Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaEDOkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 10:40:13 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64831 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaEDOkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 10:40:11 -0400
Message-ID: <53665143.8000000@gmail.com>
Date: Sun, 04 May 2014 16:40:03 +0200
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>
Subject: perf not compiling on 64bit kernel 32bit userspace
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

compiling perf on 32 bit userspace and 64 bit kernel fails on x86 because
x86-64 assembly is compiled in:

  CC       bench/mem-memcpy-x86-64-asm.o
  CC       bench/mem-memset-x86-64-asm.o
bench/../../../arch/x86/lib/memcpy_64.S: Assembler messages:
bench/../../../arch/x86/lib/memcpy_64.S:29: Error: bad register name `%rdi'

Switching the check from RAW_ARCH to ARCH does the trick here on 3.14.2.
If someone could please take care of fixing Linus' master and add this to
the stable queue it would be much appreciated.

Thanks!

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 7257e7e..00f632f 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -414,7 +414,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
 # Benchmark modules
 BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
 BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
-ifeq ($(RAW_ARCH),x86_64)
+ifeq ($(ARCH),x86_64)
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
 endif

-- 
Riccardo Magliocchetti
