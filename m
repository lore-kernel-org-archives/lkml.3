Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141Ab3HNQkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:40:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760098Ab3HNQkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:40:15 -0400
Date: Wed, 14 Aug 2013 18:39:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V11 13/15] perf tools: expand
 perf_event__synthesize_sample()
Message-ID: <20130814163906.GB1017@krava.brq.redhat.com>
References: <1376484517-5339-1-git-send-email-adrian.hunter@intel.com>
 <1376484517-5339-14-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376484517-5339-14-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 03:48:35PM +0300, Adrian Hunter wrote:

SNIP

> index 81c170f..4c97f36 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -1389,7 +1389,6 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
>  	}
>  
>  	if (type & PERF_SAMPLE_REGS_USER) {
> -		/* First u64 tells us if we have any regs in sample. */

;-)

>  		OVERFLOW_CHECK_u64(array);
>  		data->user_regs.abi = *array;

SNIP

> +
> +	if (type & PERF_SAMPLE_REGS_USER) {
> +		if (sample->user_regs.abi) {
> +			*array++ = sample->user_regs.abi;
> +			sz = hweight_long(sample_regs_user) * sizeof(u64);
> +			memcpy(array, sample->user_regs.regs, sz);
> +			array = (void *)array + sz;
> +		} else {
> +			*array++ = 0;
> +		}
> +	}

Acked-by: Jiri Olsa <jolsa@redhat.com>
