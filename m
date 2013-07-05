Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab3GERIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 13:08:39 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:57152 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3GERIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 13:08:38 -0400
Date: Fri, 5 Jul 2013 14:08:30 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V4 15/21] perf tools: fix missing increment in sample
 parsing
Message-ID: <20130705170830.GG2559@ghostprotocols.net>
References: <1372944040-32690-1-git-send-email-adrian.hunter@intel.com>
 <1372944040-32690-16-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372944040-32690-16-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 04, 2013 at 04:20:34PM +0300, Adrian Hunter escreveu:
> The final sample format bit used to be PERF_SAMPLE_STACK_USER
> which neglected to do a final increment of the array pointer.
> The result is that the following parsing might start at the
> wrong place.

One 'perf test' entry that would ask for these features and then check
that the result obtained is what is expected would come in handy here
:-\

- Arnaldo
 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/evsel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 86628fe..10ccf38 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -1284,7 +1284,7 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
>  		} else {
>  			data->user_stack.data = (char *)array;
>  			array += size / sizeof(*array);
> -			data->user_stack.size = *array;
> +			data->user_stack.size = *array++;
>  		}
>  	}
>  
> -- 
> 1.7.11.7
