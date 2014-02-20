Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaBTLBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:01:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbaBTLBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:01:44 -0500
Date: Thu, 20 Feb 2014 12:01:12 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 6/8] perf tools: Add hist.percentage config option
Message-ID: <20140220110112.GF11018@krava.brq.redhat.com>
References: <1392000446-14744-1-git-send-email-namhyung@kernel.org>
 <1392000446-14744-7-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392000446-14744-7-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 11:47:23AM +0900, Namhyung Kim wrote:
> Add hist.percentage option for setting default value of the
> symbol_conf.filter_relative.  It affects the output of various perf
> commands (like perf report, top and diff) only if filter(s) applied.
> 
> An user can write .perfconfig file like below to show absolute
> percentage of filtered entries by default:

SNIP

> +++ b/tools/perf/util/hist.c
> @@ -934,3 +934,17 @@ int hists__link(struct hists *leader, struct hists *other)
>  
>  	return 0;
>  }
> +
> +int perf_hist_config(const char *var, const char *value)
> +{
> +	if (!strcmp(var, "hist.percentage")) {
> +		if (!strcmp(value, "relative"))
> +			symbol_conf.filter_relative = true;
> +		else if (!strcmp(value, "absolute"))
> +			symbol_conf.filter_relative = false;
> +		else
> +			return -1;
> +	}
> +
> +	return 0;
> +}

the inner stuff could be done in parse_percentage function
not to duplicate the symbol_conf.filter_relative assignment

jirka
