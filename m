Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761505Ab3EAP1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:27:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158Ab3EAP05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:26:57 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCHv3 0/4] perf, signal x86: Fix breakpoint events overflow handling
Date: Wed,  1 May 2013 17:25:40 +0200
Message-Id: <1367421944-19082-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending v3 for initial patchset:
https://lkml.org/lkml/2013/3/1/324

basically just sending remaining (not pulled) patches,
with '*-by: *' tags updated.

v3 changes:
  - perf test patches already pulled in
  - added Oleg's Tested-by for signal related patches
  - added Frederic's Reviewed-by for signal related patches
  - added Peter's Reviewed-by for perf patch.

v2 changes:
  - added patch to merge EFLAGS bit clearing into single statement

Also available at:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
tip/perf/RF

thanks,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
Jiri Olsa (4):
      signal x86: Propage RF EFLAGS bit throught the signal restore call
      signal x86: Clear RF EFLAGS bit for signal handler
      signal x86: Merge EFLAGS bit clearing into single statement
      perf: Fix hw breakpoints overflow period sampling

 arch/x86/ia32/ia32_signal.c        |  2 --
 arch/x86/include/asm/sighandling.h |  4 ++--
 arch/x86/kernel/signal.c           | 16 ++++++----------
 include/linux/perf_event.h         |  2 ++
 kernel/events/core.c               |  2 +-
 kernel/events/hw_breakpoint.c      |  5 +++++
 6 files changed, 16 insertions(+), 15 deletions(-)
