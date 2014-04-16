Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaDPRil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:38:41 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:33888 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaDPRik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:38:40 -0400
Date: Wed, 16 Apr 2014 13:38:37 -0400
From: Tejun Heo <tj@kernel.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] workqueue: jumps to use_dfl_pwq if the target
 cpumask is equal wq's
Message-ID: <20140416173837.GO1257@htj.dyndns.org>
References: <4114063.RkqNFBsH49@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4114063.RkqNFBsH49@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Apr 16, 2014 at 02:33:27PM +0900, Daeseok Youn wrote:
> 
> Replace blocks of code which checks whether pwq is defalut with
> jump to use_dfl_pwq. It is same as before.

A better wording would be sth like

 wq_update_unbound_numa(), when it's decided that the newly updated
 cpumask equals the default, looks at whether the current pwq is
 already the default one and skips setting pwq to the default one.
 This extra step is unnecessary and we can always jump to use_dfl_pwq
 instead.  Simplify the code by removing the conditional.  This
 doesn't make any functional difference.

> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  kernel/workqueue.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 3150b21..0679854 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -4087,10 +4087,7 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
>  		if (cpumask_equal(cpumask, pwq->pool->attrs->cpumask))
>  			goto out_unlock;
>  	} else {
> -		if (pwq == wq->dfl_pwq)
> -			goto out_unlock;
> -		else
> -			goto use_dfl_pwq;
> +		goto use_dfl_pwq;

As I said before, please update the comment above to match the new
code.

Thanks.

-- 
tejun
