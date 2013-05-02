Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795Ab3EBNlC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 09:41:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49256 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759710Ab3EBNlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 09:41:00 -0400
Date: Thu, 2 May 2013 15:39:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 03/11] perf: Do not get values from disabled counters
 in group format read
Message-ID: <20130502133929.GJ13837@dyad.programming.kicks-ass.net>
References: <1359981185-16819-1-git-send-email-jolsa@redhat.com>
 <1359981185-16819-4-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359981185-16819-4-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 01:32:57PM +0100, Jiri Olsa wrote:
> From: "jolsa@redhat.com" <jolsa@redhat.com>
> 
> It's possible some of the counters in the group could be
> disabled when sampling member of the event group is reading
> the rest via PERF_SAMPLE_READ sample type processing. Disabled
> counters could then produce wrong numbers.
> 
> Fixing that by reading only enabled counters for PERF_SAMPLE_READ
> sample type processing.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

I had to like re-read our previous thread on this; which I think says that the
Changelog isn't perfect. However:

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/events/core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 4081261..e2ea1b9 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -4018,7 +4018,8 @@ static void perf_output_read_group(struct perf_output_handle *handle,
>  	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
>  		n = 0;
>  
> -		if (sub != event)
> +		if ((sub != event) &&
> +		    (sub->state == PERF_EVENT_STATE_ACTIVE))
>  			sub->pmu->read(sub);
>  
>  		values[n++] = perf_event_count(sub);
> -- 
> 1.7.11.7
> 
