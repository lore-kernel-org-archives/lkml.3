Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab3HWPde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:33:34 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:65335 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab3HWPdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:33:32 -0400
Date: Fri, 23 Aug 2013 11:33:28 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 08/11] cpuset: separate configured masks and efffective
 masks
Message-ID: <20130823153328.GD3277@htj.dyndns.org>
References: <52148F52.0@huawei.com>
 <52148FCA.8010704@huawei.com>
 <20130821140846.GH19286@mtj.dyndns.org>
 <52171367.90005@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52171367.90005@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Fri, Aug 23, 2013 at 03:46:47PM +0800, Li Zefan wrote:
> On 2013/8/21 22:08, Tejun Heo wrote:
> > On Wed, Aug 21, 2013 at 06:00:42PM +0800, Li Zefan wrote:
> >> @@ -2261,7 +2271,8 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
> >>  	/* synchronize mems_allowed to N_MEMORY */
> >>  	if (mems_updated) {
> >>  		mutex_lock(&callback_mutex);
> >> -		top_cpuset.mems_allowed = new_mems;
> >> +		if (!sane)
> >> +			top_cpuset.mems_allowed = new_mems;
> > 
> > Can you please further explain how the top cgroup behaves?
> > 
> 
> top_cpuset.cpus_allowed will always be cpu_active_mask if sane_behavior
> is not set, otherwise it will always be cpu_possible_mask. While
> top_cpuset.effective_cpus will always be cpu_active_mask in either
> case.

Just in case it wasn't clear, it'd be great if you can also explain
what's going on w.r.t. sane_behavior in the comments and patch
description.  Having dual modes of operation can always be quite
confusing so I think some documentation could be very beneficial.

Thanks!

-- 
tejun
