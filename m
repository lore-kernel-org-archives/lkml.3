Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132AbaEEO50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:57:26 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:58185 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932887AbaEEO5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:57:24 -0400
Date: Mon, 5 May 2014 10:57:01 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 05/10] workqueue: separate iteration role from worker_idr
Message-ID: <20140505145701.GF11231@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
 <1398571754-12443-6-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398571754-12443-6-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 12:09:00PM +0800, Lai Jiangshan wrote:
> diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
> index 7e2204d..7bff111 100644
> --- a/kernel/workqueue_internal.h
> +++ b/kernel/workqueue_internal.h
> @@ -37,6 +37,7 @@ struct worker {
>  	struct task_struct	*task;		/* I: worker task */
>  	struct worker_pool	*pool;		/* I: the associated pool */
>  						/* L: for rescuers */
> +	struct list_head	bind_entry;	/* M: bound with the pool */

This is just a wrong name.  Let's just call it "workers_node" and the
head "workers".

Thanks.

-- 
tejun
