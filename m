Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab3CEW3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:29:50 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:42257 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab3CEW3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:29:49 -0500
Message-ID: <513671CF.5050705@gmail.com>
Date: Wed, 06 Mar 2013 09:29:35 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, axboe@kernel.dk,
        jmoyer@redhat.com, zab@redhat.com,
        kbuild test robot <fengguang.wu@intel.com>
Subject: Re: [PATCH v2 16/31] workqueue: introduce workqueue_attrs
References: <1362194662-2344-1-git-send-email-tj@kernel.org> <1362194662-2344-17-git-send-email-tj@kernel.org> <20130304183742.GI30413@htj.dyndns.org>
In-Reply-To: <20130304183742.GI30413@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/13 05:37, Tejun Heo wrote:
> Introduce struct workqueue_attrs which carries worker attributes -
> currently the nice level and allowed cpumask along with helper
> routines alloc_workqueue_attrs() and free_workqueue_attrs().
> 
> Each worker_pool now carries ->attrs describing the attributes of its
> workers.  All functions dealing with cpumask and nice level of workers
> are updated to follow worker_pool->attrs instead of determining them
> from other characteristics of the worker_pool, and init_workqueues()
> is updated to set worker_pool->attrs appropriately for all standard
> pools.
> 
> Note that create_worker() is updated to always perform set_user_nice()
> and use set_cpus_allowed_ptr() combined with manual assertion of
> PF_THREAD_BOUND instead of kthread_bind().  This simplifies handling
> random attributes without affecting the outcome.
> 
> This patch doesn't introduce any behavior changes.
> 
> v2: Missing cpumask_var_t definition caused build failure on some
>     archs.  linux/cpumask.h included.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>

> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -148,6 +148,8 @@ struct worker_pool {
>  	struct mutex		assoc_mutex;	/* protect POOL_DISASSOCIATED */
>  	struct ida		worker_ida;	/* L: for worker IDs */
>  
> +	struct workqueue_attrs	*attrs;		/* I: worker attributes */

If attrs always exists, why not just embed the struct and avoid the
need to alloc/free it?

~Ryan

