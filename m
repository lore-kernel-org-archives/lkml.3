Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaLCCev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:34:51 -0500
Received: from mga14.intel.com ([192.55.52.115]:45705 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaLCCet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:34:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="424347794"
Message-ID: <547E76C7.8000907@intel.com>
Date: Wed, 03 Dec 2014 10:34:47 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jens Axboe <axboe@kernel.dk>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] block / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
References: <1836422.FyhARLgxbM@vostro.rjw.lan>
In-Reply-To: <1836422.FyhARLgxbM@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 09:34 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.

Nice change!

> 
> Replace CONFIG_PM_RUNTIME with CONFIG_PM in the block device core.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Aaron Lu <aaron.lu@intel.com>

Thanks,
Aaron

> ---
> 
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.
> 
> ---
>  block/blk-core.c       |    6 +++---
>  block/elevator.c       |    2 +-
>  include/linux/blkdev.h |    4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> Index: linux-pm/include/linux/blkdev.h
> ===================================================================
> --- linux-pm.orig/include/linux/blkdev.h
> +++ linux-pm/include/linux/blkdev.h
> @@ -398,7 +398,7 @@ struct request_queue {
>  	 */
>  	struct kobject mq_kobj;
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  	struct device		*dev;
>  	int			rpm_status;
>  	unsigned int		nr_pending;
> @@ -1057,7 +1057,7 @@ extern void blk_put_queue(struct request
>  /*
>   * block layer runtime pm functions
>   */
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  extern void blk_pm_runtime_init(struct request_queue *q, struct device *dev);
>  extern int blk_pre_runtime_suspend(struct request_queue *q);
>  extern void blk_post_runtime_suspend(struct request_queue *q, int err);
> Index: linux-pm/block/blk-core.c
> ===================================================================
> --- linux-pm.orig/block/blk-core.c
> +++ linux-pm/block/blk-core.c
> @@ -1325,7 +1325,7 @@ void part_round_stats(int cpu, struct hd
>  }
>  EXPORT_SYMBOL_GPL(part_round_stats);
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static void blk_pm_put_request(struct request *rq)
>  {
>  	if (rq->q->dev && !(rq->cmd_flags & REQ_PM) && !--rq->q->nr_pending)
> @@ -2134,7 +2134,7 @@ void blk_account_io_done(struct request
>  	}
>  }
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  /*
>   * Don't process normal requests when queue is suspended
>   * or in the process of suspending/resuming
> @@ -3159,7 +3159,7 @@ void blk_finish_plug(struct blk_plug *pl
>  }
>  EXPORT_SYMBOL(blk_finish_plug);
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  /**
>   * blk_pm_runtime_init - Block layer runtime PM initialization routine
>   * @q: the queue of the device
> Index: linux-pm/block/elevator.c
> ===================================================================
> --- linux-pm.orig/block/elevator.c
> +++ linux-pm/block/elevator.c
> @@ -539,7 +539,7 @@ void elv_bio_merged(struct request_queue
>  		e->type->ops.elevator_bio_merged_fn(q, rq, bio);
>  }
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static void blk_pm_requeue_request(struct request *rq)
>  {
>  	if (rq->q->dev && !(rq->cmd_flags & REQ_PM))
> 

