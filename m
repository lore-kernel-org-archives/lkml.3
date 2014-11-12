Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaKLI6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 03:58:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbaKLI6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 03:58:45 -0500
Date: Wed, 12 Nov 2014 09:58:25 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com
Subject: Re: [PATCH 2/2] perf tools: Construct LBR call chain
Message-ID: <20141112085825.GA25338@krava>
References: <1415285886-16949-1-git-send-email-kan.liang@intel.com>
 <1415285886-16949-3-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415285886-16949-3-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 09:58:06AM -0500, kan.liang@intel.com wrote:

SNIP

> +	struct ip_callchain *chain = sample->callchain;
>  	u8 cpumode = PERF_RECORD_MISC_USER;
>  	int chain_nr = min(max_stack, (int)chain->nr);
> -	int i;
> -	int j;
> -	int err;
> +	int i, j, err = 0;
>  	int skip_idx __maybe_unused;
> +	int lbr = 0;
> +	u64 ip;
>  
>  	callchain_cursor_reset(&callchain_cursor);
>  
> @@ -1419,74 +1471,81 @@ static int thread__resolve_callchain_sample(struct thread *thread,
>  		return 0;
>  	}
>  
> -	/*
> -	 * Based on DWARF debug information, some architectures skip
> -	 * a callchain entry saved by the kernel.
> -	 */
> -	skip_idx = arch_skip_callchain_idx(thread, chain);
> +	if (evsel->attr.branch_sample_type & PERF_SAMPLE_BRANCH_CALL_STACK)
> +		lbr = 1;

please put this in a function.. like

bool has_branch_callstack(evsel)

thanks,
jirka
