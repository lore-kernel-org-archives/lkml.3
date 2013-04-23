Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab3DWK5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:57:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49249 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab3DWK5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:57:05 -0400
Date: Tue, 23 Apr 2013 11:56:59 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3.8-stable] perf: Fix error return code
Message-ID: <20130423105659.GE3471@hercules>
References: <007001ce3fce$58768be0$0963a3a0$%choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007001ce3fce$58768be0$0963a3a0$%choi@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 11:57:51AM +0900, Jonghwan Choi wrote:
> 3.8-stable review patch.  If anyone has any objections, please let me know.

Thanks, I believe this is also applicable to 3.2.y, 3.4.y and 3.5.y.

Cheers,
--
Luis

> 
> ------------------
> 
> From: "Wei Yongjun <yongjun_wei@trendmicro.com.cn>"
> 
> commit c481420248c6730246d2a1b1773d5d7007ae0835 upstream.
> 
> Fix to return -ENOMEM in the allocation error case instead of 0
> (if pmu_bus_running == 1), as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> Cc: a.p.zijlstra@chello.nl
> Cc: paulus@samba.org
> Cc: acme@ghostprotocols.net
> Link:
> http://lkml.kernel.org/r/CAPgLHd8j_fWcgqe%3DKLWjpBj%2B%3Do0Pw6Z-SEq%3DNTPU08
> c2w1tngQ@mail.gmail.com
> [ Tweaked the error code setting placement and the changelog. ]
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  kernel/events/core.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 7b6646a..f6eba58 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5988,6 +5988,7 @@ skip_type:
>  	if (pmu->pmu_cpu_context)
>  		goto got_cpu_context;
>  
> +	ret = -ENOMEM;
>  	pmu->pmu_cpu_context = alloc_percpu(struct perf_cpu_context);
>  	if (!pmu->pmu_cpu_context)
>  		goto free_dev;
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
