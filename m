Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbaIKLSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:18:06 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43393 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbaIKLRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:17:51 -0400
Date: Thu, 11 Sep 2014 13:17:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com
Subject: Re: [PATCH v5 09/12] sched: add usage_load_avg
Message-ID: <20140911111736.GV3190@worktop.ger.corp.intel.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-10-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409051215-16788-10-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 01:06:52PM +0200, Vincent Guittot wrote:
> index 5c2c885..7dfd584 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1073,10 +1073,10 @@ struct sched_avg {
>  	 * above by 1024/(1-y).  Thus we only need a u32 to store them for all
>  	 * choices of y < 1-2^(-32)*1024.
>  	 */
> -	u32 runnable_avg_sum, runnable_avg_period;
> +	u32 runnable_avg_sum, runnable_avg_period, running_avg_sum;

Seeing how we use runnable_avg_period for both runnable and running,
does it make sense to remove the runnable part of it from the name?

Also, 4 byte hole here, not sure we've got anything useful to stuff in
it though.

>  	u64 last_runnable_update;
>  	s64 decay_count;
> -	unsigned long load_avg_contrib;
> +	unsigned long load_avg_contrib, usage_avg_contrib;
>  };
>  

Man, I should go look at Yuyang's rewrite of this all again. I just
tried to figure out the decay stuff and my head hurts ;-)
