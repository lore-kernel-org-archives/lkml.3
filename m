Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab3AaNNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 08:13:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547Ab3AaNM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 08:12:58 -0500
Date: Thu, 31 Jan 2013 14:12:43 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, mingo@elte.hu,
        peterz@infradead.org, namhyung.kim@lge.com
Subject: Re: [PATCH] perf tools: fix set event list leader
Message-ID: <20130131131243.GB1091@krava.brq.redhat.com>
References: <20130131125437.GA3656@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131125437.GA3656@quad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 01:54:37PM +0100, Stephane Eranian wrote:
> 
> The __perf_evlist__set_leader() was setting the leader for all events
> in the list except the first. Which means it assumed the first event
> already had event->leader = event. Seems like this should be the role
> of the function to also do this. This is a requirement for an upcoming
> patch set.

agreed, 

Acked/Tested-by Jiri Olsa <jolsa@redhat.com>


> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
> 
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index dc8aee9..050d5bc 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -119,8 +119,7 @@ void __perf_evlist__set_leader(struct list_head *list)
>  	leader = list_entry(list->next, struct perf_evsel, node);
>  
>  	list_for_each_entry(evsel, list, node) {
> -		if (evsel != leader)
> -			evsel->leader = leader;
> +		evsel->leader = leader;
>  	}

that's leftover from the times when leader has 'leader' set to NULL

we made the change here:

perf evsel: Set leader evsel's ->leader to itself
commit 2cfda562da7b0b1e0575507ef3efe782d4e218e4
Author: Namhyung Kim <namhyung.kim@lge.com>
Date:   Thu Nov 29 15:38:29 2012 +0900

the leader is set properly in perf_evsel__init and when
reading perf.data, so there was no harm in current code

thanks,
jirka
