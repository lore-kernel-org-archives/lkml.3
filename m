Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbbAWIo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:44:59 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:33934 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbbAWIo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 03:44:57 -0500
Date: Fri, 23 Jan 2015 09:44:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Shaohua Li <shli@fb.com>
Cc: linux-kernel@vger.kernel.org, Kernel-team@fb.com,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC 2/2] perf: update userspace page info for software event
Message-ID: <20150123084451.GE2896@worktop.programming.kicks-ass.net>
References: <119aa7d433860f568136ab623fb4a510c28e9e6f.1421906750.git.shli@fb.com>
 <e0f8f6f0a114c464e8e38cd73be31564bd5ea7da.1421906750.git.shli@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0f8f6f0a114c464e8e38cd73be31564bd5ea7da.1421906750.git.shli@fb.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 01:09:02PM -0800, Shaohua Li wrote:
> ---
>  kernel/events/core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 4edde3e..4221240 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5950,6 +5950,7 @@ static int perf_swevent_add(struct perf_event *event, int flags)
>  	}
>  
>  	hlist_add_head_rcu(&event->hlist_entry, head);
> +	perf_event_update_userpage(event);
>  
>  	return 0;
>  }
> @@ -6419,6 +6420,7 @@ static int cpu_clock_event_add(struct perf_event *event, int flags)
>  {
>  	if (flags & PERF_EF_START)
>  		cpu_clock_event_start(event, flags);
> +	perf_event_update_userpage(event);
>  
>  	return 0;
>  }
> @@ -6493,6 +6495,7 @@ static int task_clock_event_add(struct perf_event *event, int flags)
>  {
>  	if (flags & PERF_EF_START)
>  		task_clock_event_start(event, flags);
> +	perf_event_update_userpage(event);
>  
>  	return 0;
>  }

How about the one I sent; which adds it to {start,stop} instead of add?
{start,stop} is the right place to add them, although this add might be
sufficient for your use case.
