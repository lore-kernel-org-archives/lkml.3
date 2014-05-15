Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaEOMHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:07:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbaEOMH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:07:29 -0400
Date: Thu, 15 May 2014 14:07:04 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 06/20] perf tools: Consolidate output field handling to
 hpp format routines
Message-ID: <20140515120703.GA25858@krava.brq.redhat.com>
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
 <1399876133-17963-7-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399876133-17963-7-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 03:28:39PM +0900, Namhyung Kim wrote:

SNIP

> -		}
> -
>  		if (symbol_conf.use_callchain && sort__has_sym) {
>  			if (callchain_param.mode == CHAIN_GRAPH_REL)
>  				total = h->stat.period;
> diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
> index c65a7fd744c6..32d2dfd794d9 100644
> --- a/tools/perf/ui/hist.c
> +++ b/tools/perf/ui/hist.c
> @@ -352,8 +352,18 @@ LIST_HEAD(perf_hpp__sort_list);
>  #undef __HPP_ENTRY_RAW_FN
>  
>  
> +void perf_hpp__setup_output_field(void);

should go to util/hist.h

jirka

>  {
> diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
> index 9eccf7f4f367..e6920d124c60 100644
> --- a/tools/perf/ui/stdio/hist.c
> +++ b/tools/perf/ui/stdio/hist.c
> @@ -353,8 +353,7 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
>  	if (size == 0 || size > bfsz)
>  		size = hpp.size = bfsz;
>  
> -	ret = hist_entry__period_snprintf(&hpp, he);
> -	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
> +	hist_entry__period_snprintf(&hpp, he);

so it's no longer just period.. should we rename it? like
  hist_entry__hpp_snprintf
  hist_entry__snprintf

jirka
