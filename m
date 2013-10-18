Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3JROjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:39:33 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:16898 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3JROjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:39:32 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v2 0/4] perf: add option to limit callchain stack scan to increase speed
Date: Fri, 18 Oct 2013 10:38:45 -0400
Message-Id: <1382107129-2010-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1->v2:
 - Include a compilation fix patch and a code streamlining patch 
   into the patch set.
 - Use the __stringify() macro in stringify.h instead of adding a
   duplicate macro.
 - Add the --max-stack option to perf-top as well.
 
This perf patch set contains the following changes:

Patch 1 - Fix a perf tool compilation error that happens on SLES 11
          sp3 system.
Patch 2 - Streamline the append_chain() function to make it run a bit
          faster.
Patch 3 - Add a --max-stack option to perf-report to speed up its
          processing at the expense of less backtrace information
          available.
Patch 4 - Add a similar --max-stack option to perf-top.

Waiman Long (4):
  perf: Fix potential compilation error with some compilers
  perf: streamline append_chain() function
  perf-report: add --max-stack option to limit callchain stack scan
  perf-top: add --max-stack option to limit callchain stack scan

 tools/perf/Documentation/perf-report.txt           |    8 +++++++
 tools/perf/Documentation/perf-top.txt              |    8 +++++++
 tools/perf/builtin-report.c                        |   22 +++++++++++++++----
 tools/perf/builtin-top.c                           |    9 ++++++-
 tools/perf/util/callchain.c                        |    9 +++----
 tools/perf/util/machine.c                          |   14 ++++++++----
 tools/perf/util/machine.h                          |    3 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    6 ++++-
 tools/perf/util/session.c                          |    3 +-
 tools/perf/util/top.h                              |    1 +
 10 files changed, 63 insertions(+), 20 deletions(-)

