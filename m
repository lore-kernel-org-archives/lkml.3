Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab3JUPEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 11:04:11 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:34694 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab3JUPEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 11:04:09 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v3 0/3] perf: add option to limit callchain stack scan to increase speed
Date: Mon, 21 Oct 2013 11:03:36 -0400
Message-Id: <1382367819-19643-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2->v3:
 - Fix the commit log in the second patch which causes "git am" to fail.
 - Remove the 1st patch in v2 as the problem will be fixed by another
   patch from Arnaldo.

v1->v2:
 - Include a compilation fix patch and a code streamlining patch
   into the patch set.
 - Use the __stringify() macro in stringify.h instead of adding a
   duplicate macro.
 - Add the --max-stack option to perf-top as well.

This perf patch set contains the following changes:

Patch 1 - Streamline the append_chain() function to make it run a bit
          faster.
Patch 2 - Add a --max-stack option to perf-report to speed up its
          processing at the expense of less backtrace information
          available.
Patch 3 - Add a similar --max-stack option to perf-top.

Waiman Long (3):
  perf: streamline append_chain() function
  perf-report: add --max-stack option to limit callchain stack scan
  perf-top: add --max-stack option to limit callchain stack scan

 tools/perf/Documentation/perf-report.txt |    8 ++++++++
 tools/perf/Documentation/perf-top.txt    |    8 ++++++++
 tools/perf/builtin-report.c              |   22 +++++++++++++++++-----
 tools/perf/builtin-top.c                 |    9 +++++++--
 tools/perf/util/callchain.c              |    9 ++++-----
 tools/perf/util/machine.c                |   14 +++++++++-----
 tools/perf/util/machine.h                |    3 ++-
 tools/perf/util/session.c                |    3 ++-
 tools/perf/util/top.h                    |    1 +
 9 files changed, 58 insertions(+), 19 deletions(-)

