Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3CRItW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:49:22 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:35153 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab3CRItT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:49:19 -0400
Date: Mon, 18 Mar 2013 09:49:13 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/3 v2] [GIT PULL][3.9] tracing: Fixes with flags and
 latency tracers
Message-ID: <20130318084913.GD17959@gmail.com>
References: <20130315050616.512983245@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130315050616.512983245@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Here's take two of the last patch series I sent. The only difference
> with this series is that I encapsulate the max_tr reference with
> the #ifdef CONFIG_TRACER_MAX_TRACE. Other than that, it's the same.
> 
> Here's the recap:
> 
> The first patch fixes a long standing bug where the changing of
> the trace options has absolutely no protection against multiple
> changers. Luckily, this is something that requires human (root)
> action, and is usually performed by a single individual. But as
> scripts are starting to become more active, this bug is bound to
> be triggered.
> 
> The second patch is a bug where the setting of the overwrite flag
> can cause the max and normal buffers to get out of sync. This
> is more predomitinant with the 3.9 snapshot feature, but still
> has an affect on the latency tracers. Which bring us to the third
> patch.
> 
> The third patch I found out that disabling overwrite to the buffers
> screws with the latency tracers. If the buffer is in produce consumer
> mode, the irqsoff tracer and friends wont show any output at all.
> This was a bit frustrating to figure out.
> 
> Hopefully this time it's good.
> 
> Thanks,
> 
> -- Steve
> 
> Please pull the latest tip/perf/urgent-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/urgent-2
> 
> Head SHA1: 613f04a0f51e6e68ac6fe571ab79da3c0a5eb4da
> 
> 
> Steven Rostedt (Red Hat) (3):
>       tracing: Protect tracer flags with trace_types_lock
>       tracing: Keep overwrite in sync between regular and snapshot buffers
>       tracing: Prevent buffer overwrite disabled for latency tracers
> 
> ----
>  kernel/trace/trace.c              |   56 +++++++++++++++++++++++++++++--------
>  kernel/trace/trace.h              |    6 ++++
>  kernel/trace/trace_irqsoff.c      |   19 +++++++++----
>  kernel/trace/trace_sched_wakeup.c |   18 ++++++++----
>  4 files changed, 78 insertions(+), 21 deletions(-)

Pulled, thanks Steve!

	Ingo
