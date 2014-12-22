Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbaLVOtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:49:24 -0500
Received: from mail.kernel.org ([198.145.19.201]:52216 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825AbaLVOtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:49:23 -0500
Date: Mon, 22 Dec 2014 11:49:19 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 7/7] perf tools: Set attr.task bit for a tracking event
Message-ID: <20141222144919.GA7644@kernel.org>
References: <1419223455-4362-1-git-send-email-namhyung@kernel.org>
 <1419223455-4362-8-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419223455-4362-8-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 22, 2014 at 01:44:15PM +0900, Namhyung Kim escreveu:
> The perf_event_attr.task bit is to track task (fork and exit) events
> but it missed to be set by perf_evsel__config().  While it was not a
> problem in practice since setting other bits (comm/mmap) ended up
> being in same result, it'd be good to set it explicitly anyway.

I didn't understand, so this isn't strictly needed? I.e. what is the
point of the attr->task bit then?

/me goes to check...

- Arnaldo
 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
