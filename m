Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab3CJSlr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 14:41:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab3CJSlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 14:41:45 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCHv2 0/6] perf, signal x86: Fix breakpoint events overflow handling
Date: Sun, 10 Mar 2013 19:41:05 +0100
Message-Id: <1362940871-24486-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sendign v2 for initial RFC patchset:
https://lkml.org/lkml/2013/3/1/324

v2 changes:
  - added patch to merge EFLAGS bit clearing into single statement

Also available at:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
perf/RF5

thanks,
jirka

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Stephane Eranian <eranian@google.com>
---
Jiri Olsa (6):
      signal x86: Propage RF EFLAGS bit throught the signal restore call
      signal x86: Clear RF EFLAGS bit for signal handler
      signal x86: Merge EFLAGS bit clearing into single statement
      perf: Fix hw breakpoints overflow period sampling
      perf tests: Test breakpoint overflow signal handler
      perf tests: Test breakpoint overflow signal handler counts

 arch/x86/ia32/ia32_signal.c           |   2 -
 arch/x86/include/asm/sighandling.h    |   4 +-
 arch/x86/kernel/signal.c              |  16 +++-----
 include/linux/perf_event.h            |   2 +
 kernel/events/core.c                  |   2 +-
 kernel/events/hw_breakpoint.c         |   5 +++
 tools/perf/Makefile                   |   2 +
 tools/perf/tests/bp_signal.c          | 187 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/bp_signal_overflow.c | 126 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/builtin-test.c       |   8 ++++
 tools/perf/tests/tests.h              |   2 +
 11 files changed, 341 insertions(+), 15 deletions(-)
 create mode 100644 tools/perf/tests/bp_signal.c
 create mode 100644 tools/perf/tests/bp_signal_overflow.c
