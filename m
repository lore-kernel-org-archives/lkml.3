Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaCKJ3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:29:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46289 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbaCKJ3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:29:08 -0400
Date: Tue, 11 Mar 2014 10:28:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, joe@perches.com, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 07/16] ioprio: Add a macro named NICE_TO_IOPRIO.
Message-ID: <20140311092856.GU9987@twins.programming.kicks-ass.net>
References: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
 <008cf8bba167646424d0fca68d96463feace2aee.1394529373.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008cf8bba167646424d0fca68d96463feace2aee.1394529373.git.yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 05:20:28PM +0800, Dongsheng Yang wrote:
> As the task nice value is in [-20, 19] and the io priority is in [0, 7],
> and the convert method from niceval to ioprio is implemented with an
> opened code in task_nice_ioprio().
> 
> This patch move the implementation to a macro NICE_TO_IOPRIO, making
> it more readable and modular.
> 
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>  include/linux/ioprio.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
> index beb9ce1..c0faa0b 100644
> --- a/include/linux/ioprio.h
> +++ b/include/linux/ioprio.h
> @@ -18,6 +18,11 @@
>  #define ioprio_valid(mask)	(IOPRIO_PRIO_CLASS((mask)) != IOPRIO_CLASS_NONE)
>  
>  /*
> + * Convert the nice value [19,-20] to io priority value [0,7].
> + */
> +#define NICE_TO_IOPRIO(nice)	(nice_to_rlimit(nice) / 5)
> +
> +/*
>   * These are the io priority groups as implemented by CFQ. RT is the realtime
>   * class, it always gets premium service. BE is the best-effort scheduling
>   * class, the default for any process. IDLE is the idle scheduling class, it
> @@ -52,7 +57,7 @@ enum {
>   */
>  static inline int task_nice_ioprio(struct task_struct *task)
>  {
> -	return (task_nice(task) + 20) / 5;
> +	return NICE_TO_IOPRIO(task_nice(task));
>  }

How exactly is adding a macro and code complexity making this code
better?
