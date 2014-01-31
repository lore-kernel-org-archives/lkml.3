Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116AbaAaU2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:28:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55429 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072AbaAaU17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:27:59 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avi Kivity <avi@cloudius-systems.com>, David Ahern <dsahern@gmail.com>,
        Francesco Fusco <ffusco@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Will Deacon <will.deacon@arm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/12] perf/urgent fixes
Date: Fri, 31 Jan 2014 17:27:23 -0300
Message-Id: <1391200055-18250-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 0d4dd797564cddc1f71ab0b239e9ea50ddd40b2a:

  perf/doc: Remove mention of non-existent set_perf_event_pending() from design.txt (2014-01-26 09:37:48 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to d3b70220292c40d3b499797fd2f33f608fc35edb:

  perf buildid-cache: Check relocation when checking for existing kcore (2014-01-31 17:21:54 -0300)

----------------------------------------------------------------
perf/urgent fixes:

. Fix annotation for relocated kernel (Adrian Hunter)

. Fix demangling of symbols in kernel and kernel modules (Avi Kivity)

. Fix include for non x86 architectures (Francesco Fusco)

. Fix ARM64 memory barriers (Peter Zijlstra)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Adrian Hunter (9):
      perf symbols: Fix symbol annotation for relocated kernel
      perf tools: Add kallsyms__get_function_start()
      perf machine: Add machine__get_kallsyms_filename()
      perf machine: Set up ref_reloc_sym in machine__create_kernel_maps()
      perf record: Get ref_reloc_sym from kernel map
      perf symbols: Prevent the use of kcore if the kernel has moved
      perf tests: No need to set up ref_reloc_sym
      perf tools: Adjust kallsyms for relocated kernel
      perf buildid-cache: Check relocation when checking for existing kcore

Avi Kivity (1):
      perf tools: Demangle kernel and kernel module symbols too

Francesco Fusco (1):
      perf tools: Fix include for non x86 architectures

Peter Zijlstra (1):
      perf tools: Fix AAAAARGH64 memory barriers

 tools/perf/builtin-buildid-cache.c  | 33 ++++++++++++++++---
 tools/perf/builtin-record.c         | 10 ++----
 tools/perf/perf.h                   |  4 +--
 tools/perf/tests/vmlinux-kallsyms.c | 10 ------
 tools/perf/util/event.c             | 36 ++++++++++----------
 tools/perf/util/event.h             |  6 ++--
 tools/perf/util/include/asm/hash.h  |  6 ++++
 tools/perf/util/machine.c           | 42 +++++++++++++++++++-----
 tools/perf/util/machine.h           |  2 ++
 tools/perf/util/map.c               |  5 +--
 tools/perf/util/map.h               |  1 +
 tools/perf/util/symbol-elf.c        |  4 ++-
 tools/perf/util/symbol.c            | 65 +++++++++++++++++++++++++++++++++----
 13 files changed, 162 insertions(+), 62 deletions(-)
 create mode 100644 tools/perf/util/include/asm/hash.h
