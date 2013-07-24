Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab3GXNCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 09:02:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab3GXNCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 09:02:21 -0400
Date: Wed, 24 Jul 2013 15:01:40 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V8 14/15] perf tools: add a function to calculate sample
 event size
Message-ID: <20130724130140.GB4203@krava.brq.redhat.com>
References: <1374144177-24762-1-git-send-email-adrian.hunter@intel.com>
 <1374144177-24762-15-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374144177-24762-15-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 01:42:56PM +0300, Adrian Hunter wrote:

SNIP

> @@ -227,6 +227,8 @@ int perf_event__preprocess_sample(const union perf_event *self,
>  
>  const char *perf_event__name(unsigned int id);
>  
> +size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
> +				     u64 sample_regs_user);
>  int perf_event__synthesize_sample(union perf_event *event, u64 type,
>  				  u64 sample_regs_user,
>  				  const struct perf_sample *sample,
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 047ab02..7a5ff06 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -1348,6 +1348,87 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
>  	return 0;
>  }
>  
> +size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
> +				     u64 sample_regs_user)
> +{
> +	size_t sz, result = sizeof(struct sample_event);
> +
> +	if (type & PERF_SAMPLE_IDENTIFIER)
> +		result += sizeof(u64);
> +
> +	if (type & PERF_SAMPLE_IP)
> +		result += sizeof(u64);
> +
> +	if (type & PERF_SAMPLE_TID)
> +		result += sizeof(u64);
> +
> +	if (type & PERF_SAMPLE_TIME)
> +		result += sizeof(u64);
> +
> +	if (type & PERF_SAMPLE_ADDR)
> +		result += sizeof(u64);
> +
> +	if (type & PERF_SAMPLE_ID)
> +		result += sizeof(u64);
> +
> +	if (type & PERF_SAMPLE_STREAM_ID)
> +		result += sizeof(u64);
> +
> +	if (type & PERF_SAMPLE_CPU)
> +		result += sizeof(u64);
> +
> +	if (type & PERF_SAMPLE_PERIOD)
> +		result += sizeof(u64);
> +
> +	if (type & PERF_SAMPLE_READ) {
> +		fprintf(stderr, "PERF_SAMPLE_READ is unsupported for now\n");
> +		result += 8192; /* To be on the safe side */
> +	}

There' a patchset pending to be merged that implements
PERF_SAMPLE_READ. I wonder which one makes it in first..
looser will have to update this code ;-)

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
