Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab3IIONJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:13:09 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:41150 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab3IIONG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:13:06 -0400
Date: Mon, 9 Sep 2013 10:13:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Libin <huawei.libin@huawei.com>
Cc: linux-kernel@vger.kernel.org, wangyijing@huawei.com, guohanjun@huawei.com
Subject: Re: [PATCH] workqueue: remove meaningless BUILD_BUG_ON() in
 init_workqueues()
Message-ID: <20130909141302.GC25434@htj.dyndns.org>
References: <1378703400-4536-1-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378703400-4536-1-git-send-email-huawei.libin@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Libin.

On Mon, Sep 09, 2013 at 01:10:00PM +0800, Libin wrote:
> From: Li Bin <huawei.libin@huawei.com>
> 
> In the current implementation, this BUILD_BUG_ON makes no sense.
> First of all, the number of worker pools needed cannot be determined
> at compile time, because the number of backing pools for UNBOUND
> workqueues is dynamic based on the assigned custom attributes.
> Secondly, it should use WORK_OFFQ_POOL_BITS instead of
> (BITS_PER_LONG - WORK_OFFQ_POOL_SHIFT).
> 
> Signed-off-by: Li Bin <huawei.libin@huawei.com>
> ---
>  kernel/workqueue.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 987293d..41019b1 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -5009,10 +5009,6 @@ static int __init init_workqueues(void)
>  	int std_nice[NR_STD_WORKER_POOLS] = { 0, HIGHPRI_NICE_LEVEL };
>  	int i, cpu;
>  
> -	/* make sure we have enough bits for OFFQ pool ID */
> -	BUILD_BUG_ON((1LU << (BITS_PER_LONG - WORK_OFFQ_POOL_SHIFT)) <
> -		     WORK_CPU_END * NR_STD_WORKER_POOLS);
> -

Indeed, but can you please update worker_pool_assign_id() so that it
doesn't allocate ids >= WORK_OFFQ_POOL_NONE?

Thanks.

-- 
tejun
