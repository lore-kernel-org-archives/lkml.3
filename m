Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaKLHuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:50:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbaKLHuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:50:50 -0500
Date: Wed, 12 Nov 2014 08:50:26 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com
Subject: Re: [PATCH 1/2] perf tools: enable LBR call stack support
Message-ID: <20141112075026.GA22994@krava>
References: <1415285886-16949-1-git-send-email-kan.liang@intel.com>
 <1415285886-16949-2-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415285886-16949-2-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 09:58:05AM -0500, kan.liang@intel.com wrote:

SNIP

>  		    (sample_type & PERF_SAMPLE_STACK_USER))
>  			callchain_param.record_mode = CALLCHAIN_DWARF;
> +		else if (sample_type & PERF_SAMPLE_BRANCH_STACK)
> +			callchain_param.record_mode = CALLCHAIN_LBR;
>  		else
>  			callchain_param.record_mode = CALLCHAIN_FP;
>  	}
> diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
> index 0022980..72ed39b 100644
> --- a/tools/perf/util/callchain.c
> +++ b/tools/perf/util/callchain.c
> @@ -97,6 +97,14 @@ int parse_callchain_record_opt(const char *arg)
>  				callchain_param.dump_size = size;
>  			}
>  #endif /* HAVE_DWARF_UNWIND_SUPPORT */
> +		} else if (!strncmp(name, "lbr", sizeof("lbr"))) {
> +			if (!strtok_r(NULL, ",", &saveptr)) {
> +				callchain_param.record_mode = CALLCHAIN_LBR;
> +				ret = 0;
> +			} else
> +				pr_err("callchain: No more arguments "
> +					"needed for -g lbr\n");

should it be 'needed for --call-graph' option?   ^^^^^^^^^^^

jirka
