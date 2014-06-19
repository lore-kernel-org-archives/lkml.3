Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381AbaFSQcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:32:19 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46694 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716AbaFSQcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:32:16 -0400
Date: Thu, 19 Jun 2014 12:32:09 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: sanity check pool->cpu in wq_worker_sleeping()
Message-ID: <20140619163209.GN26904@htj.dyndns.org>
References: <1401780788-12297-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401780788-12297-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 03:33:08PM +0800, Lai Jiangshan wrote:
> In theory, pool->cpu is equals to @cpu in wq_worker_sleeping() after
> worker->flags is checked.
> 
> And "pool->cpu != cpu" sanity check will help us if something wrong.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/workqueue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 9f53abd..61381a2 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -843,7 +843,7 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task, int cpu)
>  	pool = worker->pool;
>  
>  	/* this can only happen on the local cpu */
> -	if (WARN_ON_ONCE(cpu != raw_smp_processor_id()))
> +	if (WARN_ON_ONCE(cpu != raw_smp_processor_id() || pool->cpu != cpu))

Hmmm... yeah, this can catch work functions hijacking and binding
per-cpu worker to another cpu.

Applied to wq/for-3.17.

Thanks.

-- 
tejun
