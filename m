Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaA2ONC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:13:02 -0500
Received: from mga14.intel.com ([143.182.124.37]:53968 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaA2OM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:12:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,742,1384329600"; 
   d="scan'208";a="466608253"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 0/9] perf tools: kaslr fixes
Date: Wed, 29 Jan 2014 16:14:35 +0200
Message-Id: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are some patches that improve perf tools
handling of relocation.

This has become an issue as mentioned in this
thread:

	http://marc.info/?l=linux-kernel&m=139030004314756

Changes in V2:
	Fix some typos in commit messages
	perf tools: Set up ref_reloc_sym in machine__create_kernel_maps()
		Fix "/proc/kallsyms" -> filename
		Use an array of symbol names
	perf buildid-cache: Check relocation when checking for existing kcore
		New patch


Adrian Hunter (9):
      perf tools: Fix symbol annotation for relocated kernel
      perf tools: Add kallsyms__get_function_start()
      perf tools: Add machine__get_kallsyms_filename()
      perf tools: Set up ref_reloc_sym in machine__create_kernel_maps()
      perf record: Get ref_reloc_sym from kernel map
      perf tools: Prevent the use of kcore if the kernel has moved
      perf tools: Test does not need to set up ref_reloc_sym
      perf tools: Adjust kallsyms for relocated kernel
      perf buildid-cache: Check relocation when checking for existing kcore

 tools/perf/builtin-buildid-cache.c  | 33 ++++++++++++++++---
 tools/perf/builtin-record.c         | 10 ++----
 tools/perf/tests/vmlinux-kallsyms.c | 10 ------
 tools/perf/util/event.c             | 36 ++++++++++----------
 tools/perf/util/event.h             |  6 ++--
 tools/perf/util/machine.c           | 42 +++++++++++++++++++-----
 tools/perf/util/machine.h           |  2 ++
 tools/perf/util/map.c               |  5 +--
 tools/perf/util/map.h               |  1 +
 tools/perf/util/symbol-elf.c        |  2 ++
 tools/perf/util/symbol.c            | 65 +++++++++++++++++++++++++++++++++----
 11 files changed, 153 insertions(+), 59 deletions(-)


Regards
Adrian
