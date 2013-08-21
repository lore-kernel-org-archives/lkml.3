Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab3HUUxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:53:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38143 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3HUUxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:53:12 -0400
Message-ID: <521528A8.5040307@infradead.org>
Date: Wed, 21 Aug 2013 13:52:56 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Libin <huawei.libin@huawei.com>
CC: tj@kernel.org, linux-kernel@vger.kernel.org, wangyijing@huawei.com,
        guohanjun@huawei.com
Subject: Re: [PATCH v2 2/3] workqueue: Fix manage_workers() RETURNS description
References: <1377046241-18516-1-git-send-email-huawei.libin@huawei.com> <1377046241-18516-3-git-send-email-huawei.libin@huawei.com>
In-Reply-To: <1377046241-18516-3-git-send-email-huawei.libin@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/13 17:50, Libin wrote:
> No functional change. The comment of function manage_workers()
> RETURNS description is obvious wrong, same as the CONTEXT.
> Fix it.
> 
> Signed-off-by: Libin <huawei.libin@huawei.com>
> ---
>  kernel/workqueue.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 26644ce..46a0de0 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2034,8 +2034,11 @@ static bool maybe_destroy_workers(struct worker_pool *pool)
>   * multiple times.  Does GFP_KERNEL allocations.
>   *
>   * RETURNS:
> - * spin_lock_irq(pool->lock) which may be released and regrabbed
> - * multiple times.  Does GFP_KERNEL allocations.
> + * %false if the pool don't need management and the caller can safely

                         doesn't

> + * start processing works, %true indicates that the function released
> + * pool->lock and reacquired it to perform some management function
> + * and that the conditions that the caller verified while holding the
> + * lock before calling the function might no longer be true.
>   */
>  static bool manage_workers(struct worker *worker)
>  {
> 


-- 
~Randy
