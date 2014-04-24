Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbaDXOsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:48:39 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:43658 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419AbaDXOsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:48:36 -0400
Date: Thu, 24 Apr 2014 10:48:32 -0400
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 2/4] workqueue: Split apply attrs code from its locking
Message-ID: <20140424144832.GD14460@htj.dyndns.org>
References: <1398350256-7834-1-git-send-email-fweisbec@gmail.com>
 <1398350256-7834-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398350256-7834-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 04:37:34PM +0200, Frederic Weisbecker wrote:
> +static int apply_workqueue_attrs_locked(struct workqueue_struct *wq,
> +					const struct workqueue_attrs *attrs)
>  {
>  	struct workqueue_attrs *new_attrs, *tmp_attrs;
>  	struct pool_workqueue **pwq_tbl, *dfl_pwq;
> @@ -3976,15 +3960,6 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
>  	copy_workqueue_attrs(tmp_attrs, new_attrs);
>  
>  	/*
> -	 * CPUs should stay stable across pwq creations and installations.
> -	 * Pin CPUs, determine the target cpumask for each node and create
> -	 * pwqs accordingly.
> -	 */
> -	get_online_cpus();
> -
> -	mutex_lock(&wq_pool_mutex);

lockdep_assert_held()

Thanks.

-- 
tejun
