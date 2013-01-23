Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab3AWQfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:35:46 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:54705 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3AWQfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:35:44 -0500
Date: Wed, 23 Jan 2013 08:35:36 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/6] cgroup: initialize cgrp->dentry before css_alloc()
Message-ID: <20130123163536.GA2373@mtj.dyndns.org>
References: <50F7B040.2020906@huawei.com>
 <20130123002754.GB5359@htj.dyndns.org>
 <50FF4C4D.4020405@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FF4C4D.4020405@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Wed, Jan 23, 2013 at 10:34:53AM +0800, Li Zefan wrote:
> Scheduler changes made in patch #2 are preparation for #3 and #4.
> 
> - for #3:
> 
> After ss->css_alloc(), there's a small window that tg->css.cgroup is NULL.
> With the change, tg won't be seen before ss->css_online(), so the scheduler
> won't see NULL tg->css.cgroup.
> 
> - for #4:
> 
> If tg is unregistered and removed from global list in css_free(), and if
> we kfree cgroup right after ss->css_free(), the scheduler can access
> invalid tg->css.cgroup, because tg is also protected by RCU.

Can you please incorporate the above into the patch descriptions?

Thanks!

-- 
tejun
