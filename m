Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab3HMQkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:40:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab3HMQkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:40:21 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Subject: [RFC 0/2] perf: Fixing throttling related WARN
Date: Tue, 13 Aug 2013 18:39:10 +0200
Message-Id: <1376411952-16718-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
we managed to trigger perf WARN (described in patch 2),
but only on AMD system with 48 CPUs.

I believe the reason is a race in throttling code and
I tried to fix it. So far my testing looks ok, but I
suspect I broke something else.. ;-)

thanks for comments,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |  4 +++-
 include/linux/perf_event.h             |  2 +-
 kernel/events/core.c                   | 67 +++++++++++++++++++++++++++++++++++++++----------------------------
 3 files changed, 43 insertions(+), 30 deletions(-)

