Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbaAHPMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 10:12:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbaAHPMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 10:12:42 -0500
Date: Wed, 8 Jan 2014 13:12:33 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dsahern@gmail.com,
        artagnon@gmail.com
Subject: Re: [PATCH 3/8] perf tools: free aliases[j] in pmu.c if name_only is
 true.
Message-ID: <20140108151233.GB2626@infradead.org>
References: <cover.1388416837.git.yangds.fnst@cn.fujitsu.com>
 <f4427175be649aa6cdf477980051688c525b46ab.1388416837.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4427175be649aa6cdf477980051688c525b46ab.1388416837.git.yangds.fnst@cn.fujitsu.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What for? Please be clear in the changelogs, it helps with review.

Now I'll have to follow the logic to figure this out, i.e. _why_ we
should free aliases[j] if name_only is true? Is it safe?

- Arnaldo

Em Mon, Dec 30, 2013 at 10:26:38AM -0500, Dongsheng Yang escreveu:
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>  tools/perf/util/pmu.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> index 331dc2c..169c480 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -752,6 +752,7 @@ unsigned int print_pmu_events(const char *event_glob, bool name_only)
>  	for (j = 0; j < len; j++) {
>  		if (name_only) {
>  			printf("%s ", aliases[j]);
> +			zfree(&aliases[j]);
>  			count++;
>  			continue;
>  		}
> -- 
> 1.8.2.1
