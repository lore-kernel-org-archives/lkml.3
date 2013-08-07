Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab3HGLc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:32:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:56434 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab3HGLc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:32:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,832,1367996400"; 
   d="scan'208";a="383214405"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V4 00/13] perf tools: add support for reading object code
Date: Wed,  7 Aug 2013 14:38:44 +0300
Message-Id: <1375875537-4509-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are some patches that add support for reading object code from vmlinux,
kernel modules and /proc/kcore.

Changes in V4:
	perf tools: make it possible to read object code from kernel modules
		Fix symbol adjustment for kernel modules
		Remove kallsyms' symbols when using a module's symbols
	perf tools: add kcore to the object code reading test
		Do not use static variables
	perf tools: put dso name in symbol annotation title
		New patch
	perf tools: remove nop at end of annotation
		New patch
	perf tools: add annotation call target name if it is missing
		New Patch


Changes in V3:
	perf tools: adjust the vmlinux symtab matches kallsyms test again
		New patch
	perf tools: add test for reading object code
		Fix error path by removing unnecessary perf_evlist__disable()
		Fix error path by setting evlist to NULL after deletion
		Fix sampling frequency by changing from 40000 to 4000
		Increase the number of operations performed by the "workload"
		to compensate for the lower sampling frequency

Changes in V2:
	Re-based on Arnaldo's tree's perf/core branch

	perf tools: add test for reading object code
		Use strchr in read_objdump_line()
		Remove unused return value of read_objdump_line()
		Fix double space before "cycles:u"
		Add missing perf_evlist__delete(evlist) in do_test_code_reading()
	perf tools: load kernel maps before using
		Correct spelling of "initialization" in commit message
	perf tools: add support for reading from /proc/kcore
		Do not test kallsyms filename for host buildid because
		/proc/kallsyms is always used if the dso buildid matches
		the host
	perf tools: add kcore to the object code reading test
		Remove redundant "else if (!have_kcore && try_kcore)" clause


Adrian Hunter (13):
      perf tools: add test for reading object code
      perf tools: load kernel maps before using
      perf tools: make it possible to read object code from vmlinux
      perf tools: adjust the vmlinux symtab matches kallsyms test
      perf tools: avoid SyS kernel syscall aliases
      perf tools: make it possible to read object code from kernel modules
      perf tools: add support for reading from /proc/kcore
      perf tools: adjust the vmlinux symtab matches kallsyms test again
      perf tools: add kcore to the object code reading test
      perf tools: allow annotation using /proc/kcore
      perf tools: put dso name in symbol annotation title
      perf tools: remove nop at end of annotation
      perf tools: add annotation call target name if it is missing

 tools/perf/Makefile                 |   1 +
 tools/perf/builtin-inject.c         |   2 +-
 tools/perf/builtin-script.c         |   4 +-
 tools/perf/builtin-top.c            |   3 +-
 tools/perf/tests/builtin-test.c     |   4 +
 tools/perf/tests/code-reading.c     | 573 ++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h            |   1 +
 tools/perf/tests/vmlinux-kallsyms.c |  36 ++-
 tools/perf/ui/browsers/annotate.c   |  16 +-
 tools/perf/util/annotate.c          |  60 +++-
 tools/perf/util/build-id.c          |   2 +-
 tools/perf/util/dso.c               |  10 +-
 tools/perf/util/dso.h               |  17 ++
 tools/perf/util/event.c             |  18 +-
 tools/perf/util/machine.c           |  20 +-
 tools/perf/util/map.c               |  67 ++---
 tools/perf/util/map.h               |  13 +
 tools/perf/util/symbol-elf.c        | 174 ++++++++++-
 tools/perf/util/symbol-minimal.c    |   7 +
 tools/perf/util/symbol.c            | 273 +++++++++++++++--
 tools/perf/util/symbol.h            |   5 +
 tools/perf/util/thread.h            |   2 +-
 tools/perf/util/unwind.c            |   4 +-
 23 files changed, 1209 insertions(+), 103 deletions(-)
 create mode 100644 tools/perf/tests/code-reading.c

Regards
Adrian
