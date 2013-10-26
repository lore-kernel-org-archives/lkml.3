Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3JZO0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 10:26:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab3JZO0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 10:26:16 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 0/4] perf tools: Fix -g option handling
Date: Sat, 26 Oct 2013 16:25:32 +0200
Message-Id: <1382797536-32303-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <20131026120336.GA24439@gmail.com>
References: <20131026120336.GA24439@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
changing the '-g/-G' options for record/top commands
to take NO argument and enable unwind method based
on .perfconfig setup (using FP by default).

The current -g option parsing moves into the
'--call-graph' option.

Examples:
  $ cat ~/.perfconfig:
    [top]
          call-graph = fp

    [record]
          call-graph = dwarf,8192

  $ perf record -g ls
  - enables dwarf unwind with user stack size dump 8192 bytes

  $ perf top -G
  - enables frame pointer unwind

  $ perf record --call-graph=fp ls
  - enables frame pointer unwind

  $ perf top --call-graph=dwarf,4096 ls
  - enables dwarf unwind with user stack size dump 4096 bytes

thanks,
jirka

Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
---
Jiri Olsa (4):
      perf tools: Split -g and --call-graph for record command
      perf tools: Split -G and --call-graph for top command
      perf tools: Add call-graph option support into .perfconfig
      perf tools: Add readable output for callchain debug

 tools/perf/Documentation/perf-record.txt |  6 +++++-
 tools/perf/Documentation/perf-top.txt    | 18 +++++-------------
 tools/perf/builtin-record.c              | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------
 tools/perf/builtin-top.c                 | 35 +++++++++++++++++++++++++----------
 tools/perf/perf.h                        |  4 +++-
 tools/perf/util/callchain.h              |  3 +++
 tools/perf/util/evsel.c                  |  2 +-
 7 files changed, 110 insertions(+), 47 deletions(-)
