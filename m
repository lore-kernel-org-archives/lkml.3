Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbaA0SRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:17:12 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:47312 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbaA0SRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:17:10 -0500
MIME-Version: 1.0
Date: Mon, 27 Jan 2014 13:17:09 -0500
X-Google-Sender-Auth: jU6rnlHLNl22_SfS39kPJdrmp5o
Message-ID: <CA+5PVA7ceNpHdh6zO2p1Xg+wSyoA8RTzspOOTrT0yRBW7LdE0g@mail.gmail.com>
Subject: perf build failure on ARM with v3.13-8330-g4ba9920
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Francesco Fusco <ffusco@redhat.com>,
        Daniel Borkmann <dborkman@redhat.com>, Thomas Graf <tgraf@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

When building perf on ARM, we get a build failure because it can't
find #include <asm/hash.h> from the linux/hash.h file:

gcc -o builtin-kvm.o -c  -Wbad-function-cast
-Wdeclaration-after-statement -Wformat-security -Wformat-y2k
-Winit-self -Wmissing-declarations -Wmissing-prototypes
-Wnested-externs -Wno-system-headers -Wold-style-definition -Wpacked
-Wredundant-decls -Wshadow -Wstrict-aliasing=3 -Wstrict-prototypes
-Wswitch-default -Wswitch-enum -Wundef -Wwrite-strings -Wformat
-DHAVE_PERF_REGS_SUPPORT -O6 -fno-omit-frame-pointer -ggdb3
-funwind-tables -Wall -Wextra -std=gnu99 -fstack-protector-all
-D_FORTIFY_SOURCE=2
-I/builddir/build/BUILD/kernel-3.13.fc21/linux-3.14.0-0.rc0.git10.1.fc21.armv7hl/tools/perf/util/include
-I/builddir/build/BUILD/kernel-3.13.fc21/linux-3.14.0-0.rc0.git10.1.fc21.armv7hl/tools/perf/arch/arm/include
-I/builddir/build/BUILD/kernel-3.13.fc21/linux-3.14.0-0.rc0.git10.1.fc21.armv7hl/tools/include/
-I/builddir/build/BUILD/kernel-3.13.fc21/linux-3.14.0-0.rc0.git10.1.fc21.armv7hl/arch/arm/include/uapi
-I/builddir/build/BUILD/kernel-3.13.fc21/linux-3.14.0-0.rc0.git10.1.fc21.armv7hl/arch/arm/include
-I/builddir/build/BUILD/kernel-3.13.fc21/linux-3.14.0-0.rc0.git10.1.fc21.armv7hl/include/uapi
-I/builddir/build/BUILD/kernel-3.13.fc21/linux-3.14.0-0.rc0.git10.1.fc21.armv7hl/include
-I/builddir/build/BUILD/kernel-3.13.fc21/linux-3.14.0-0.rc0.git10.1.fc21.armv7hl/tools/perf/util
-I/builddir/build/BUILD/kernel-3.13.fc21/linux-3.14.0-0.rc0.git10.1.fc21.armv7hl/tools/perf
-I/builddir/build/BUILD/kernel-3.13.fc21/linux-3.14.0-0.rc0.git10.1.fc21.armv7hl/tools/lib/
-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
-DHAVE_LIBELF_SUPPORT -DHAVE_LIBELF_MMAP_SUPPORT
-DHAVE_ELF_GETPHDRNUM_SUPPORT -DHAVE_DWARF_SUPPORT
-DHAVE_LIBAUDIT_SUPPORT -I/usr/include/slang -DHAVE_SLANG_SUPPORT
-DHAVE_TIMERFD_SUPPORT -DHAVE_LIBBFD_SUPPORT -DHAVE_ON_EXIT_SUPPORT
-DHAVE_BACKTRACE_SUPPORT builtin-kvm.c
In file included from
/builddir/build/BUILD/kernel-3.13.fc21/linux-3.14.0-0.rc0.git10.1.fc21.armv7hl/tools/perf/util/include/linux/hash.h:1:0,
                 from builtin-lock.c:28:
/builddir/build/BUILD/kernel-3.13.fc21/linux-3.14.0-0.rc0.git10.1.fc21.armv7hl/tools/perf/util/include/../../../../include/linux/hash.h:18:22:
fatal error: asm/hash.h: No such file or directory
 #include <asm/hash.h>
                      ^
compilation terminated.

It looks like commit 71ae8aac3e19 ("lib: introduce arch optimized hash
library") added the asm/hash.h include, and then commit e3fec2f74f7f
("lib: Add missing arch generic-y entries for asm-generic/hash.h")
added the asm-generic plumbing for arches that don't have that file in
asm/.  However, perf doesn't seem to be picking this up for some
reason.

Does anyone have any ideas as to what could be going wrong here?

josh
