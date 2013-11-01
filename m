Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab3KAPXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 11:23:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab3KAPXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 11:23:43 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCHv2 0/3] perf tools: Fix -g option handling
Date: Fri,  1 Nov 2013 16:23:11 +0100
Message-Id: <1383319394-19046-1-git-send-email-jolsa@redhat.com>
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

v2 changes:
   - added -L as short option for call-graph for record/top commands
   - updated documentation
   - based on latest acme's perf/urgent

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
Jiri Olsa (3):
      perf tools: Add call-graph option support into .perfconfig
      perf tools: Add readable output for callchain debug
      perf tools: Add -L as short option for call-graph for record/top commands

 tools/perf/Documentation/perf-record.txt |  6 ++++++
 tools/perf/Documentation/perf-top.txt    |  9 +++++++++
 tools/perf/builtin-record.c              | 22 ++++++++++++++++++++--
 tools/perf/builtin-top.c                 | 14 +++++++++++++-
 tools/perf/perf.h                        |  4 +++-
 tools/perf/util/evsel.c                  |  2 +-
 6 files changed, 52 insertions(+), 5 deletions(-)
