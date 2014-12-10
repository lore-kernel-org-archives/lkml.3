Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141AbaLJUYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:24:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374AbaLJUYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:24:34 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Vince Weaver <vince@deater.net>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHSET/RFC 0/2] perf: Fix issues reported by perf fuzzer
Date: Wed, 10 Dec 2014 21:23:49 +0100
Message-Id: <1418243031-20367-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
Vince reported several issues with perf code hit by perf fuzzer,
in here:
  http://marc.info/?l=linux-kernel&m=141806390822670&w=2

I run the fuzzer, but wasn't able to hit issues reported
by Vince. But.. I was lucky enough to hit other 2 issues
described in following patches ;-)

As I dont follow the uncore code much, it is sort of RFC
patchset. However I'm running the fuzzer now for several
hours and can't hit any other issue.

thanks,
jirka


Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Vince Weaver <vince@deater.net>
Cc: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
Jiri Olsa (2):
      perf/x86/intel/uncore: Make sure only uncore events are collected
      perf: Fix events installation during moving group

 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 22 +++++++++++++++++++---
 kernel/events/core.c                          |  4 ++--
 2 files changed, 21 insertions(+), 5 deletions(-)
