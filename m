Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbaDQRjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:39:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbaDQRjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:39:35 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 0/3] perf tools: Speedup DWARF unwind
Date: Thu, 17 Apr 2014 19:39:09 +0200
Message-Id: <1397756352-26694-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
trying to speedup DWARF unwind report code by factoring
related code:
  - caching sample's registers access
  - keep dso data file descriptor open for the
    life of the dso object
  - replace dso cache code by mapping dso data file
    directly for the life of the dso object

The speedup is mainly for libunwind unwind. The libdw will benefit
mainly from cached registers access, because it handles dso data
accesses by itself.. and anyway it's still faster ;-).

Also reachable in here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/core_unwind_speedup

thanks,
jirka

Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jean Pihet <jean.pihet@linaro.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
Jiri Olsa (3):
      perf tools: Cache register accesses for unwind processing
      perf tools: Cache dso data file descriptor
      perf tools: Replace dso data cache with mapped data

 tools/perf/tests/dso-data.c        |   7 ++++
 tools/perf/util/dso.c              | 200 +++++++++++++++++++++++++++---------------------------------------------------------------------
 tools/perf/util/dso.h              |  14 ++-----
 tools/perf/util/event.h            |   5 +++
 tools/perf/util/perf_regs.c        |  10 ++++-
 tools/perf/util/perf_regs.h        |   4 +-
 tools/perf/util/unwind-libunwind.c |   2 -
 7 files changed, 83 insertions(+), 159 deletions(-)
