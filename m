Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095Ab3HOCDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 22:03:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30182 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758580Ab3HOCDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 22:03:36 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=-VQ6tN8hvrcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=NdVuo6LqBv0A:10 a=VwQbUJbxAAAA:8 a=IwkaB-Xmd6Gt_COJ9tgA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130815020104.813498803@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 14 Aug 2013 22:01:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH tip/perf/core 0/3] [GIT PULL][3.12] tracing/perf: Optimization for perf tracing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

These three patches from Oleg are more perf related, but they
are based on some of the updates that Oleg did that are in 3.11-rc5.

I based this work off of v3.11-rc5 as it seems that tip/perf/core is
still based on 3.11-rc1. You may want to merge Linus's 3.11-rc5 before
pulling this.

All the patches have been acked by Peter Zijlstra.

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: d027e6a9c83440bf1ca9e5503539d58d8e0914f1


Oleg Nesterov (3):
      tracing/perf: Expand TRACE_EVENT(sched_stat_runtime)
      tracing/perf: Reimplement TP_perf_assign() logic
      tracing/perf: Avoid perf_trace_buf_*() in perf_trace_##call() when possible

----
 include/trace/events/sched.h |   22 ++++++++--------------
 include/trace/ftrace.h       |   33 ++++++++++++++++++++-------------
 2 files changed, 28 insertions(+), 27 deletions(-)
