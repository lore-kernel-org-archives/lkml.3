Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030352Ab3E3Jxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:53:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030270Ab3E3Jxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:53:39 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/2] perf: Fix wakeup_events logic
Date: Thu, 30 May 2013 11:53:05 +0200
Message-Id: <1369907587-8963-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this patchset enables the wakeup_events check for all type
of events stored under ring buffer plus test.

Changes could be reached in here:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
perf/aux_poll1

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
Cc: Stephane Eranian <eranian@google.com>
---
Jiri Olsa (2):
      perf: Enable wakeup_events logic for all events
      perf tests: Add auxiliary events poll automated test

 kernel/events/core.c            |  14 --------
 kernel/events/ring_buffer.c     |  20 ++++++++++++
 tools/perf/Makefile             |   1 +
 tools/perf/tests/aux_poll.c     | 176 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/builtin-test.c |   4 +++
 tools/perf/tests/tests.h        |   1 +
 6 files changed, 202 insertions(+), 14 deletions(-)
 create mode 100644 tools/perf/tests/aux_poll.c
