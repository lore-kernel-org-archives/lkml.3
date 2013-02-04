Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab3BDTzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:55:05 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:58915 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab3BDTzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:55:03 -0500
Date: Mon, 4 Feb 2013 11:54:58 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/13] workqueue: fix work_busy()
Message-ID: <20130204195458.GA27963@mtj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359657696-2767-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Fri, Feb 01, 2013 at 02:41:25AM +0800, Lai Jiangshan wrote:
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 973b290..d474a6c 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -3443,8 +3443,6 @@ EXPORT_SYMBOL_GPL(workqueue_congested);
>   * Test whether @work is currently pending or running.  There is no
>   * synchronization around this function and the test result is
>   * unreliable and only useful as advisory hints or for debugging.
> - * Especially for reentrant wqs, the pending state might hide the
> - * running state.

Yeap, this is no longer true.

>   *
>   * RETURNS:
>   * OR'd bitmask of WORK_BUSY_* bits.
> @@ -3453,15 +3451,13 @@ unsigned int work_busy(struct work_struct *work)
>  {
>  	struct worker_pool *pool = get_work_pool(work);
>  	unsigned long flags;
> -	unsigned int ret = 0;
> +	unsigned int ret = work_pending(work) ? WORK_BUSY_PENDING : 0;

I'd prefer this as a if() statement.

>  	if (!pool)
> -		return 0;
> +		return ret;

I'm a bit confused.  When can we be pending w/o pool?

Thanks.

-- 
tejun
