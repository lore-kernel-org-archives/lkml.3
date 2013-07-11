Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3GKP30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 11:29:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273Ab3GKP3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 11:29:21 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Renninger <trenn@suse.de>
Subject: [PATCHv2 0/5] perf tools: Remove event types data
Date: Thu, 11 Jul 2013 17:28:28 +0200
Message-Id: <1373556513-3000-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
following up on the 'perf timechart' FIXME note and changing
its tracepoint match not to use event types data.

Original RFC sent here:
http://marc.info/?l=linux-kernel&m=137344263513417&w=2

v2 changes:
  - using tracepoints haler callbacks to get power data
    in timechart command (patch 2)
  - separating enum removal of 'enum trace_flag_type'
    (patch 1)

Again, timechart (and perf.data)  tests look ok, but would
appreciate another tester ;-).

It's reachable here:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
perf/et2

thanks,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Thomas Renninger <trenn@suse.de>
---
 tools/perf/builtin-inject.c    |   7 ----
 tools/perf/builtin-record.c    |  13 --------
 tools/perf/builtin-report.c    |   1 -
 tools/perf/builtin-script.c    |   1 -
 tools/perf/builtin-timechart.c | 176 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------
 tools/perf/util/event.h        |   2 +-
 tools/perf/util/header.c       | 118 +------------------------------------------------------------------
 tools/perf/util/header.h       |  16 +---------
 tools/perf/util/session.c      |  11 -------
 tools/perf/util/tool.h         |   3 --
 10 files changed, 102 insertions(+), 246 deletions(-)
