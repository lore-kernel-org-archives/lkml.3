Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaJBDI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 23:08:58 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:35220 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaJBDI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 23:08:57 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCHSET 0/5] perf tools: Speed up dwarf callchain post-unwinding for libunwind (v3)
Date: Thu,  2 Oct 2014 12:08:50 +0900
Message-Id: <1412219335-17417-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is v3 for libunwind callchain post processing speed up.  It was
able to reduce 50% of processing time by using global cache provided
in libunwind.  In this version, I decided to use the existing
callchain_param.record_mode instead of adding a new field in the
symbol_conf.

The patch 4 and 5 are just cleanups so that we can easily find out
that which part of code uses the thread->priv.

You can also get it from 'perf/callchain-unwind-v3' branch on my tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Thanks,
Namhyung


Namhyung Kim (5):
  perf report: Set callchain_param.record_mode for future use
  perf callchain: Create an address space per thread
  perf callchain: Use global caching provided by libunwind
  perf kvm: Use thread_{,_set}_priv helpers
  perf trace: Use thread_{,_set}_priv helpers

 tools/perf/builtin-kvm.c           |  6 ++---
 tools/perf/builtin-report.c        |  6 +++++
 tools/perf/builtin-trace.c         | 16 ++++++-------
 tools/perf/tests/dwarf-unwind.c    |  3 +++
 tools/perf/util/callchain.h        |  2 ++
 tools/perf/util/hist.h             |  2 --
 tools/perf/util/thread.c           |  9 +++++++
 tools/perf/util/unwind-libunwind.c | 48 ++++++++++++++++++++++++++++++++++----
 tools/perf/util/unwind.h           | 20 ++++++++++++++++
 9 files changed, 94 insertions(+), 18 deletions(-)

-- 
2.1.0

