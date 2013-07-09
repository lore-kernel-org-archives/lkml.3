Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab3GIQun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:50:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542Ab3GIQuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:50:23 -0400
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
Subject: [RFC 0/4] perf tools: Remove event types data
Date: Tue,  9 Jul 2013 18:48:55 +0200
Message-Id: <1373388539-9347-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
following up on the 'perf timechart' FIXME note and changing
its tracepoint match not to use event types data.

In my tests the old and new timechart outputs look the same,
so.. any other tester would be appreciated ;-)

Also as this was the only user of the event types data
the rest of the patchset is removing it out of the perf.

The event types data are referenced from the perf data
file header. The reference (offset & size) stays in the
header with 0s.

Also the event types data is already duplicated via the
event_desc FEATURE, so there's no information loss.

thanks for comments,
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
 tools/perf/builtin-inject.c    |   7 ------
 tools/perf/builtin-record.c    |  13 -----------
 tools/perf/builtin-report.c    |   1 -
 tools/perf/builtin-script.c    |   1 -
 tools/perf/builtin-timechart.c |  94 ++++++++++++++++++++++++++++++++++++++++++-------------------------------------
 tools/perf/util/event.h        |   2 +-
 tools/perf/util/header.c       | 118 +---------------------------------------------------------------------------------------------------
 tools/perf/util/header.h       |  16 +-------------
 tools/perf/util/session.c      |  11 ----------
 tools/perf/util/tool.h         |   3 ---
 10 files changed, 54 insertions(+), 212 deletions(-)
