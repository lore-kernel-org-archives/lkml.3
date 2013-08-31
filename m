Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab3HaSo3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 14:44:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:30755 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390Ab3HaSo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 14:44:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,998,1367996400"; 
   d="scan'208";a="289335843"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 0/3] perf: add a dummy software event to keep tracking
Date: Sat, 31 Aug 2013 21:50:50 +0300
Message-Id: <1377975053-3811-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This is (version 2 of) an alternative to the 'keep tracking' flag patch
which is here:

	http://marc.info/?l=linux-kernel&m=137242545521246&w=2

perf tools is updated and a test added to demonstrate the
new event.

Changes in V2:

	perf: add a dummy software event to keep tracking
		Add Peter's Ack
	perf tools: add support for PERF_COUNT_SW_DUMMY
		Fix missing "dummy" in perf_evsel__sw_names
	perf tools: add 'keep tracking' test
		Let the test pass and print "not supported" if
		there is no "dummy" event

Adrian Hunter (3):
      perf: add a dummy software event to keep tracking
      perf tools: add support for PERF_COUNT_SW_DUMMY
      perf tools: add 'keep tracking' test

 include/uapi/linux/perf_event.h  |   1 +
 tools/perf/Makefile              |   1 +
 tools/perf/tests/builtin-test.c  |   4 ++
 tools/perf/tests/keep-tracking.c | 150 +++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h         |   1 +
 tools/perf/util/evlist.c         |  42 ++++++++++-
 tools/perf/util/evlist.h         |   5 ++
 tools/perf/util/parse-events.c   |   4 ++
 tools/perf/util/parse-events.l   |   1 +
 tools/perf/util/python.c         |   1 +
 10 files changed, 208 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/tests/keep-tracking.c

Regards
Adrian

