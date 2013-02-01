Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab3BABuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 20:50:50 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50569 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab3BABur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 20:50:47 -0500
X-AuditID: 9c930179-b7c24ae00000119c-3a-510b1f74fae1
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, mingo@elte.hu,
        peterz@infradead.org, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH] perf tools: fix set event list leader
References: <20130131125437.GA3656@quad>
Date: Fri, 01 Feb 2013 10:50:44 +0900
In-Reply-To: <20130131125437.GA3656@quad> (Stephane Eranian's message of "Thu,
	31 Jan 2013 13:54:37 +0100")
Message-ID: <87lib8u7ij.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On Thu, 31 Jan 2013 13:54:37 +0100, Stephane Eranian wrote:
> The __perf_evlist__set_leader() was setting the leader for all events
> in the list except the first. Which means it assumed the first event
> already had event->leader = event. Seems like this should be the role
> of the function to also do this. This is a requirement for an upcoming
> patch set.
>
> Signed-off-by: Stephane Eranian <eranian@google.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


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
>  }
>  
