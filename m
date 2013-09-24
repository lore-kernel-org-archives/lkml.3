Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab3IXMJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:09:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:37644 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab3IXMJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:09:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,970,1371106800"; 
   d="scan'208";a="364821417"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V3 00/10] perf tools: kcore improvements
Date: Tue, 24 Sep 2013 15:15:42 +0300
Message-Id: <1380024952-29387-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are some improvements for using kcore (version 3).  There are 3
improvements:

	- validate that kcore matches the perf.data modules
	- workaround objdump difficulties with kcore
	- add kcore to the build-id cache

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


Adrian Hunter (10):
      perf tools: fix path unpopulated in machine__create_modules()
      perf tools: make a separate function to parse /proc/modules
      perf tools: validate kcore module addresses
      perf tools: workaround objdump difficulties with kcore
      perf tools: add map__find_other_map_symbol()
      perf tools: fix annotate_browser__callq()
      perf tools: find kcore symbols on other maps
      perf tools: add copyfile_mode()
      perf buildid-cache: add ability to add kcore to the cache
      perf tools: add ability to find kcore in build-id cache

 tools/perf/Documentation/perf-buildid-cache.txt |  12 +
 tools/perf/builtin-buildid-cache.c              | 146 +++++-
 tools/perf/ui/browsers/annotate.c               |  10 +-
 tools/perf/util/annotate.c                      |  36 +-
 tools/perf/util/machine.c                       |  75 +--
 tools/perf/util/map.c                           |  27 ++
 tools/perf/util/map.h                           |   2 +
 tools/perf/util/symbol-elf.c                    | 579 ++++++++++++++++++++++++
 tools/perf/util/symbol-minimal.c                |  15 +
 tools/perf/util/symbol.c                        | 431 +++++++++++++++---
 tools/perf/util/symbol.h                        |  20 +
 tools/perf/util/util.c                          |  18 +-
 tools/perf/util/util.h                          |   1 +
 13 files changed, 1234 insertions(+), 138 deletions(-)


Regards
Adrian

