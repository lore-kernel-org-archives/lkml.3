Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbaELQXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:23:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:60212 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbaELQXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:23:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1036,1389772800"; 
   d="scan'208";a="510368122"
Message-ID: <5370F583.1090207@intel.com>
Date: Tue, 13 May 2014 00:23:31 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: mingo@kernel.org, fengguang.wu@intel.com, linux-ia64@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [sched] BUG: unable to handle kernel paging request at 093cd001
References: <5370DC83.3030406@intel.com> <1399905820-16943-1-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1399905820-16943-1-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 10:43 PM, Vincent Guittot wrote:
> Hi,
> 
> Sorry the previous patch, that i sent, becomes wrong after optimizing it
> Could you please try this one ?

Hi Vincent, this patch works. Thanks.

Tested-by: Jet Chen <jet.chen@intel.com>

> 
> Regards,
> Vincent
> ---
>  kernel/sched/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 4ea7b3f..205fa17 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6234,7 +6234,7 @@ static void sched_init_numa(void)
>  	/* Compute default topology size */
>  	for (i = 0; sched_domain_topology[i].mask; i++);
>  
> -	tl = kzalloc((i + level) *
> +	tl = kzalloc((i + level + 1) *
>  			sizeof(struct sched_domain_topology_level), GFP_KERNEL);
>  	if (!tl)
>  		return;
> 
