Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab3J0PaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 11:30:16 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:40378 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab3J0PaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 11:30:14 -0400
Message-ID: <526D317E.80408@gmail.com>
Date: Sun, 27 Oct 2013 09:30:06 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
CC: Corey Ashford <cjashfor@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 1/4] perf tools: Split -g and --call-graph for record
 command
References: <20131026120336.GA24439@gmail.com> <1382797536-32303-1-git-send-email-jolsa@redhat.com> <1382797536-32303-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1382797536-32303-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/13 8:25 AM, Jiri Olsa wrote:
> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
> index f10ab63..7be62770 100644
> --- a/tools/perf/Documentation/perf-record.txt
> +++ b/tools/perf/Documentation/perf-record.txt
> @@ -92,8 +92,12 @@ OPTIONS
>   	size is rounded up to have nearest pages power of two value.
>
>   -g::
> +	Enables call-graph (stack chain/backtrace) recording.
> +
>   --call-graph::
> -	Do call-graph (stack chain/backtrace) recording.
> +	Setup and enable call-graph (stack chain/backtrace) recording,
> +	implies -g.
> +

This needs some more words as to why it is used over -g. It is also 
missing the options that can be given (fp or dwarf).

---8<---

> @@ -825,9 +851,12 @@ const struct option record_options[] = {
>   		     perf_evlist__parse_mmap_pages),
>   	OPT_BOOLEAN(0, "group", &record.opts.group,
>   		    "put the counters into a counter group"),
> -	OPT_CALLBACK_DEFAULT('g', "call-graph", &record.opts,
> -			     "mode[,dump_size]", record_callchain_help,
> -			     &record_parse_callchain_opt, "fp"),
> +	OPT_CALLBACK(0, "call-graph", &record.opts,
> +		     "mode[,dump_size]", record_callchain_help,
> +		     &record_parse_callchain_opt),
> +	OPT_CALLBACK_NOOPT('g', NULL, &record.opts,
> +			   NULL, "enables call-graph recording" ,
> +			   &record_callchain_opt),

 From a user/readability perspective I would prefer the order to be -g 
then --call-graph especially since --call-graph is like an advanced -g 
where you get more control over the method used.

Other than that:

Tested-Reviewed-by: David Ahern <dsahern@gmail.com>

David

