Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3EXLRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:17:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab3EXLRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 07:17:09 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/5] perf tools: Fix attr tests plus other small fixes
Date: Fri, 24 May 2013 13:16:36 +0200
Message-Id: <1369394201-20044-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending fixes for attr tests. It's tested with following
patch reverted:
  87f303a perf record: handle death by SIGTERM

otherwise I get a deadlock.. this issue will be
handled separatelly.

It's reachable at:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
perf/core_misc

thanks,
jirka

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
---
Jiri Olsa (5):
      perf tests: Fix attr test for record -d option
      perf tests: Fix exclude_guest|exclude_host checking for attr tests
      perf tools: Remove frozen from perf_header struct
      perf tools: Remove unused code from record command
      perf tools: Remove cwdlen from struct perf_session

 tools/perf/builtin-report.c            | 23 +++++------------------
 tools/perf/tests/attr/base-record      |  4 ++--
 tools/perf/tests/attr/base-stat        |  4 ++--
 tools/perf/tests/attr/test-record-data |  5 ++++-
 tools/perf/util/header.c               |  2 --
 tools/perf/util/header.h               |  1 -
 tools/perf/util/session.h              |  1 -
 7 files changed, 13 insertions(+), 27 deletions(-)
