Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab3JIMC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:02:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:35240 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab3JIMC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:02:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1063,1371106800"; 
   d="scan'208";a="414259908"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V6 0/8] perf tools: kcore improvements
Date: Wed,  9 Oct 2013 15:01:10 +0300
Message-Id: <1381320078-16497-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are some improvements for using kcore (version 6).  There are 3
improvements:

	- validate that kcore matches the perf.data modules
	- workaround objdump difficulties with kcore
	- add kcore to the build-id cache

Changes in V6:
	perf tools: make a separate function to parse /proc/modules
		Dropped because it has been applied
	perf tools: workaround objdump difficulties with kcore
		Renamed some functions and reordered parameters
	perf buildid-cache: add ability to add kcore to the cache
		Renamed some functions and reordered parameters

Changes in V5:
	perf tools: make a separate function to parse /proc/modules
		Use scnprintf not snprintf
	perf tools: validate kcore module addresses
		Fix check for mi->name not allocated
	perf buildid-cache: add ability to add kcore to the cache
		Use scnprintf not snprintf
	perf tools: add ability to find kcore in build-id cache
		Use scnprintf not snprintf

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


Adrian Hunter (8):
      perf tools: validate kcore module addresses
      perf tools: workaround objdump difficulties with kcore
      perf tools: add map__find_other_map_symbol()
      perf tools: fix annotate_browser__callq()
      perf tools: find kcore symbols on other maps
      perf tools: add copyfile_mode()
      perf buildid-cache: add ability to add kcore to the cache
      perf tools: add ability to find kcore in build-id cache

 tools/perf/Documentation/perf-buildid-cache.txt |  13 +
 tools/perf/builtin-buildid-cache.c              | 148 +++++-
 tools/perf/ui/browsers/annotate.c               |  10 +-
 tools/perf/util/annotate.c                      |  36 +-
 tools/perf/util/map.c                           |  27 ++
 tools/perf/util/map.h                           |   2 +
 tools/perf/util/symbol-elf.c                    | 579 ++++++++++++++++++++++++
 tools/perf/util/symbol-minimal.c                |  15 +
 tools/perf/util/symbol.c                        | 384 +++++++++++++---
 tools/perf/util/symbol.h                        |  17 +
 tools/perf/util/util.c                          |  18 +-
 tools/perf/util/util.h                          |   1 +
 12 files changed, 1165 insertions(+), 85 deletions(-)


Regards
Adrian

