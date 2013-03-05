Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab3CESEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:04:55 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:49111 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab3CESEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:04:54 -0500
Date: Tue, 5 Mar 2013 10:04:46 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: fix possible bug which may silence the pool
Message-ID: <20130305180446.GH12795@htj.dyndns.org>
References: <1362239729-6753-1-git-send-email-laijs@cn.fujitsu.com>
 <20130304192028.GM30413@htj.dyndns.org>
 <5135479C.4060209@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5135479C.4060209@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Tue, Mar 05, 2013 at 09:17:16AM +0800, Lai Jiangshan wrote:
> > But can we please just addd wake_up_worker() in the
> > for_each_std_worker_pool() loop?  
> 
> wake_up_worker() needed be put on the same loop which do set %WORKER_UNBOUND.
> 
> mutex_lock(&pool->assoc_mutex);
> do set %WORKER_UNBOUND for normal_pri pool
> mutex_unlock(&pool->assoc_mutex);
> 
> // no wakeup for normal_pri pool
> // but all workers of normal_pri pool goto sleep
> 
> // try to  do set %WORKER_UNBOUND for high_pri pool
> mutex_lock(&pool->assoc_mutex);
> 	waiting forever here due to high_pri pool's manage_workers()
> 	waiting on allocating memory forever(waiting normal_pri pool
> 	free memory, but normal_pri pool is silenced)
> mutex_unlock(&pool->assoc_mutex);

Hmmm.... I see.  Can you please separate it into two patches then?
One to restructure the loop into one and the other to add wake up,
and add comment explaining why the loop has to be per-pool?

Thanks.

-- 
tejun
