Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaBYPGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 10:06:42 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:56924 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaBYPGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 10:06:40 -0500
Date: Tue, 25 Feb 2014 10:06:36 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [cgroup/task_lock] INFO: suspicious RCU usage.
Message-ID: <20140225150636.GF26788@htj.dyndns.org>
References: <20140221021622.GB13515@localhost>
 <20140221154025.GB460@htj.dyndns.org>
 <530C5977.4090402@huawei.com>
 <530C8615.4020004@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530C8615.4020004@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Tue, Feb 25, 2014 at 08:01:25PM +0800, Li Zefan wrote:
...
> >> So, this is from removing task_lock from task_css_set_check() and
> >> adding rcu_read_lock() in cpuset_cpus_allowed() should fix it.
> > 
> > Yeah, rcu_read_lock() should be sufficient.
> > 
> >> I'm
> >> not sure how much of task_lock() locking we currently have in cpuset
> >> is actually necessary tho.  Shouldn't we be able to do most with just
> >> callback_mutex, if not cpuset_mutex?  Li, any ideas?
> >>
> > 
> > task_lock() is also used to protect task->mems_allowed. I'll see if we
> > can get rid of most (if not all) task_lock() lockings in cpuset.
> > 
> 
> After a quick lock, I think except the one in cpuset_change_task_nodemask(), all
> other task_lock() lockings can be replace by rcu_readlock().

I committed the original series as-is.  Can you please post follow-up
patches to update cpuset locking?

Thanks.

-- 
tejun
