Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaLaL0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 06:26:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaLaL0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 06:26:22 -0500
Date: Wed, 31 Dec 2014 12:25:50 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 01/37] perf tools: Set attr.task bit for a tracking event
Message-ID: <20141231112550.GA1256@krava.brq.redhat.com>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419405333-27952-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 04:14:57PM +0900, Namhyung Kim wrote:
> The perf_event_attr.task bit is to track task (fork and exit) events
> but it missed to be set by perf_evsel__config().  While it was not a
> problem in practice since setting other bits (comm/mmap) ended up
> being in same result, it'd be good to set it explicitly anyway.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Jiri Olsa <jolsa@kernel.org>

> ---
>  tools/perf/util/evsel.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 1e90c8557ede..e17d2b1624bc 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -709,6 +709,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
>  	if (opts->sample_weight)
>  		perf_evsel__set_sample_bit(evsel, WEIGHT);
>  
> +	attr->task  = track;
>  	attr->mmap  = track;
>  	attr->mmap2 = track && !perf_missing_features.mmap2;
>  	attr->comm  = track;
> -- 
> 2.1.3
> 
