Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab3JNKr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:47:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:5082 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756102Ab3JNKol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:44:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,491,1378882800"; 
   d="scan'208";a="374383619"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V7 0/7] perf tools: kcore improvements
Date: Mon, 14 Oct 2013 13:43:37 +0300
Message-Id: <1381747424-3557-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are some improvements for using kcore (version 7).  There are 3
improvements:

	- validate that kcore matches the perf.data modules
	- workaround objdump difficulties with kcore
	- add kcore to the build-id cache

Changes in V7:
	perf tools: validate kcore module addresses
		Dropped because it has been applied
	perf tools: workaround objdump difficulties with kcore
		Dropped because it has been applied
	perf tools: Add map_groups__find_ams()
		New patch
	perf tools: fix annotate_browser__callq()
		Changed to use map_groups__find_ams()
	perf tools: find kcore symbols on other maps
		Changed to use map_groups__find_ams()
	perf tools: another fix for annotate_browser__callq()
		New patch

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


Adrian Hunter (6):
      perf tools: fix annotate_browser__callq()
      perf tools: find kcore symbols on other maps
      perf tools: add copyfile_mode()
      perf buildid-cache: add ability to add kcore to the cache
      perf tools: add ability to find kcore in build-id cache
      perf tools: another fix for annotate_browser__callq()

Arnaldo Carvalho de Melo (1):
      perf tools: Add map_groups__find_ams()

 tools/perf/Documentation/perf-buildid-cache.txt |  13 +
 tools/perf/builtin-buildid-cache.c              | 148 +++++++++-
 tools/perf/ui/browsers/annotate.c               |  24 +-
 tools/perf/util/annotate.c                      |  22 +-
 tools/perf/util/map.c                           |  48 +++-
 tools/perf/util/map.h                           |   7 +
 tools/perf/util/symbol-elf.c                    | 358 ++++++++++++++++++++++++
 tools/perf/util/symbol-minimal.c                |   6 +
 tools/perf/util/symbol.c                        | 188 ++++++++++---
 tools/perf/util/symbol.h                        |   3 +
 tools/perf/util/util.c                          |  18 +-
 tools/perf/util/util.h                          |   1 +
 12 files changed, 761 insertions(+), 75 deletions(-)


Regards
Adrian

