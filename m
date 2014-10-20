Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaJTHzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 03:55:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbaJTHzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 03:55:08 -0400
Date: Mon, 20 Oct 2014 09:54:45 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] perf, tools: Support handling complete branch stacks
 as histograms
Message-ID: <20141020075445.GA10629@krava.redhat.com>
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
 <1411774636-6870-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411774636-6870-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 04:37:09PM -0700, Andi Kleen wrote:

SNIP

>  	OPT_BOOLEAN('x', "exclude-other", &symbol_conf.exclude_other,
>  		    "Only display entries with parent-match"),
> -	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order",
> -		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address). "
> +	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order[,branch]",
> +		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address), add branches. "
>  		     "Default: fractal,0.5,callee,function", &report_parse_callchain_opt, callchain_default_opt),
>  	OPT_BOOLEAN(0, "children", &symbol_conf.cumulate_callchain,
>  		    "Accumulate callchains of children and show total overhead as well"),
> diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
> index 08f0fbf..265457c 100644
> --- a/tools/perf/util/callchain.c
> +++ b/tools/perf/util/callchain.c
> @@ -61,6 +61,8 @@ parse_callchain_report_opt(const char *arg)
>  			callchain_param.key = CCKEY_FUNCTION;
>  		else if (!strncmp(tok, "address", strlen(tok)))
>  			callchain_param.key = CCKEY_ADDRESS;
> +		else if (!strncmp(tok, "branch", strlen(tok)))
> +			callchain_param.branch_callstack = 1;

this needs to be rebased to latest Namhyung's changes
which got in..

could you please rebase on Arnaldo's perf/core?

jirka
