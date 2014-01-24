Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaAXPJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:09:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:64433 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbaAXPI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:08:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,713,1384329600"; 
   d="scan'208";a="471901077"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/8] perf tools: kaslr fixes
Date: Fri, 24 Jan 2014 17:10:10 +0200
Message-Id: <1390576218-1463-1-git-send-email-adrian.hunter@intel.com>
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


It looks like the changes I made to vmlinux and
module mapping to allow object code to be read
broke the symbol annotation for relocated kernels.
The first patch fixes that.

There were some other issues though:
	- ref_reloc_sym was not always set up
	- mustn't use kcore if the kernel has moved
	- kallsyms is not unique for a given
	buildid

These things need more testing but I thought it was
worth getting comments now.


Adrian Hunter (8):
      perf tools: Fix symbol annotation for relocated kernel
      perf tools: Add kallsyms__get_function_start()
      perf tools: Add machine__get_kallsyms_filename()
      perf tools: Set up ref_reloc_sym in machine__create_kernel_maps()
      perf report: Get ref_reloc_sym from kernel map
      perf tools: Prevent the use of kcore if the kernel has moved
      perf tools: test does not need to set up ref_reloc_sym
      perf tools: Adjust kallsyms for relocated kernel

 tools/perf/builtin-record.c         | 10 ++----
 tools/perf/tests/vmlinux-kallsyms.c | 10 ------
 tools/perf/util/event.c             | 36 ++++++++++----------
 tools/perf/util/event.h             |  6 ++--
 tools/perf/util/machine.c           | 40 ++++++++++++++++++-----
 tools/perf/util/map.c               |  5 +--
 tools/perf/util/map.h               |  1 +
 tools/perf/util/symbol-elf.c        |  2 ++
 tools/perf/util/symbol.c            | 65 +++++++++++++++++++++++++++++++++----
 9 files changed, 120 insertions(+), 55 deletions(-)


Regards
Adrian
