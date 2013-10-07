Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab3JGGnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:43:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:51044 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab3JGGnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:43:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1048,1371106800"; 
   d="scan'208";a="388845973"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V4 0/9] perf tools: kcore improvements
Date: Mon,  7 Oct 2013 09:50:09 +0300
Message-Id: <1381128618-22721-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are some improvements for using kcore (version 4).  There are 3
improvements:

	- validate that kcore matches the perf.data modules
	- workaround objdump difficulties with kcore
	- add kcore to the build-id cache

Changes in V4:
	perf tools: fix path unpopulated in machine__create_modules()
		Dropped because it has been applied
	perf buildid-cache: add ability to add kcore to the cache
		Tweaked Documentation/perf-buildid-cache.txt
	perf tools: add ability to find kcore in build-id cache
		Changed to check read access to /proc/kcore before
		skipping the buildid cache

Changes in V3:
	perf tools: workaround objdump difficulties with kcore
		change strncpy to strlcpy
	perf buildid-cache: add ability to add kcore to the cache
		change strncpy to strlcpy
	perf tools: add ability to find kcore in build-id cache
		change strncpy to strlcpy
Changes in V2:
	perf tools: fix buildid cache handling of kallsyms with kcore
		Dropped because it has been applied
	perf tools: fix path unpopulated in machine__create_modules()
		Use 'modules' pointer


Adrian Hunter (9):
      perf tools: make a separate function to parse /proc/modules
      perf tools: validate kcore module addresses
      perf tools: workaround objdump difficulties with kcore
      perf tools: add map__find_other_map_symbol()
      perf tools: fix annotate_browser__callq()
      perf tools: find kcore symbols on other maps
      perf tools: add copyfile_mode()
      perf buildid-cache: add ability to add kcore to the cache
      perf tools: add ability to find kcore in build-id cache

 tools/perf/Documentation/perf-buildid-cache.txt |  13 +
 tools/perf/builtin-buildid-cache.c              | 146 +++++-
 tools/perf/ui/browsers/annotate.c               |  10 +-
 tools/perf/util/annotate.c                      |  36 +-
 tools/perf/util/machine.c                       |  67 +--
 tools/perf/util/map.c                           |  27 ++
 tools/perf/util/map.h                           |   2 +
 tools/perf/util/symbol-elf.c                    | 579 ++++++++++++++++++++++++
 tools/perf/util/symbol-minimal.c                |  15 +
 tools/perf/util/symbol.c                        | 440 +++++++++++++++---
 tools/perf/util/symbol.h                        |  20 +
 tools/perf/util/util.c                          |  18 +-
 tools/perf/util/util.h                          |   1 +
 13 files changed, 1240 insertions(+), 134 deletions(-)


Regards
Adrian

