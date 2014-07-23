Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448AbaGWTzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 15:55:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932693AbaGWTyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 15:54:15 -0400
Date: Wed, 23 Jul 2014 21:34:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ftrace: kill the dead code in trace_sched_switch.c
Message-ID: <20140723193444.GA30194@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23, Oleg Nesterov wrote:
>
> This motivated me to try to find something else unused. And it seems that
> almost all code in kernel/trace/trace_sched_switch.c is dead? Hmm, and
> probably even event_context_switch... I'll recheck and send the patch.

No, event_context_switch can't simply go away. But afaics the only user
is tracing_sched_switch_trace(), and the only caller of this function is
probe_wakeup_sched_switch(). Looks a bit strange.

After this patch we should probably move tracing_sched_switch_trace() and
tracing_sched_wakeup_trace() from trace_sched_switch.c to trace_sched_wakeup.c
and make them static. And perhaps we can also move the rest of this
code somewhere else and rm this file...

Oleg.

 kernel/trace/trace.h              |    3 -
 kernel/trace/trace_sched_switch.c |   88 -------------------------------------
 2 files changed, 0 insertions(+), 91 deletions(-)

