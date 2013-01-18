Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab3ARTvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:51:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:29427 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330Ab3ARTvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:51:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,494,1355126400"; 
   d="scan'208";a="273913966"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: acme@redhat.com
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 0/4] perf tools: some 'perf script' fixes
Date: Fri, 18 Jan 2013 13:51:24 -0600
Message-Id: <cover.1358527965.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset fixes various problems I hit while doing a run-through
of the existing 'perf script' scripts.

Also, sometimes when running rwtop I get a 'failed to read event
header' error, which this patch fixes:

https://lkml.org/lkml/2012/9/14/401

Not sure if that was meant to get picked up, but it fixed that
particular problem here for me.

Thanks,

Tom

Tom Zanussi (4):
  perf/tools: reinstate 'signed' field flag for tracepoints
  perf script: don't display trace info when invoking scripts
  perf tools: hook up perf_scripting_context->pevent
  perf script: remove workqueue-stats script

 tools/lib/traceevent/event-parse.c                 |   3 +-
 tools/perf/Documentation/perf-script-python.txt    |   2 -
 tools/perf/builtin-script.c                        |   3 +-
 tools/perf/scripts/perl/bin/workqueue-stats-record |   2 -
 tools/perf/scripts/perl/bin/workqueue-stats-report |   3 -
 tools/perf/scripts/perl/workqueue-stats.pl         | 129 ---------------------
 .../perf/util/scripting-engines/trace-event-perl.c |   1 +
 .../util/scripting-engines/trace-event-python.c    |   1 +
 8 files changed, 6 insertions(+), 138 deletions(-)
 delete mode 100644 tools/perf/scripts/perl/bin/workqueue-stats-record
 delete mode 100644 tools/perf/scripts/perl/bin/workqueue-stats-report
 delete mode 100644 tools/perf/scripts/perl/workqueue-stats.pl

-- 
1.7.11.4

