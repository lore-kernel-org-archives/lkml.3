Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbaEEO7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:59:16 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:51134 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011AbaEEO7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:59:15 -0400
Date: Mon, 5 May 2014 10:59:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/10] workqueue: convert worker_idr to worker_ida
Message-ID: <20140505145912.GG11231@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
 <1398571754-12443-7-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398571754-12443-7-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 12:09:01PM +0800, Lai Jiangshan wrote:
> @@ -2224,6 +2220,9 @@ woke_up:
>  		spin_unlock_irq(&pool->lock);
>  		WARN_ON_ONCE(!list_empty(&worker->entry));
>  		worker->task->flags &= ~PF_WQ_WORKER;
> +
> +		set_task_comm(worker->task, "kworker_die");
> +		ida_simple_remove(&pool->worker_ida, worker->id);
>  		worker_unbind_pool(worker);
>  		kfree(worker);
>  		return 0;

Does this chunk belong to this patch?  Why no description about this
change?

Thanks.

-- 
tejun
