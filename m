Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaETOYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:24:52 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:40640 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaETOYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:24:50 -0400
Date: Tue, 20 May 2014 10:24:47 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 03/10] workqueue: async worker destruction
Message-ID: <20140520142447.GC2804@htj.dyndns.org>
References: <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
 <1400579204-3647-1-git-send-email-laijs@cn.fujitsu.com>
 <1400579204-3647-4-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400579204-3647-4-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 05:46:29PM +0800, Lai Jiangshan wrote:
>  static void idle_worker_timeout(unsigned long __pool)
> @@ -2289,6 +2298,10 @@ woke_up:
>  		spin_unlock_irq(&pool->lock);
>  		WARN_ON_ONCE(!list_empty(&worker->entry));
>  		worker->task->flags &= ~PF_WQ_WORKER;
> +
> +		set_task_comm(worker->task, "kworker/dying");

Also, didn't I ask you to add comment for the above before?

> +		worker_detach_from_pool(worker, pool);
> +		kfree(worker);

Thanks.

-- 
tejun
