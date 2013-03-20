Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab3CTPEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:04:07 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:38049 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab3CTPEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:04:02 -0400
Date: Wed, 20 Mar 2013 08:03:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, cgroups@vger.kernel.org
Subject: Re: [PATCH cgroup/for-3.10] cgroup: make cgroup_mutex outer to
 threadgroup_lock
Message-ID: <20130320150351.GW3042@htj.dyndns.org>
References: <20130307172545.GA10353@redhat.com>
 <20130307180139.GD29601@htj.dyndns.org>
 <20130307180332.GE29601@htj.dyndns.org>
 <20130307191242.GA18265@redhat.com>
 <20130307193820.GB3209@htj.dyndns.org>
 <513A9A67.60909@huawei.com>
 <20130309032936.GT14556@mtj.dyndns.org>
 <513AE918.7020704@huawei.com>
 <20130319220246.GR3042@htj.dyndns.org>
 <514909A0.4030808@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514909A0.4030808@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 08:58:08AM +0800, Li Zefan wrote:
> On 2013/3/20 6:02, Tejun Heo wrote:
> > It doesn't make sense to nest cgroup_mutex inside threadgroup_lock
> > when it should be outer to most all locks used by all cgroup
> > controllers.  It was nested inside threadgroup_lock only because some
> > controllers were abusing cgroup_mutex inside controllers leading to
> > locking order inversion.
> > 
> > cgroup_mutex is no longer abused by controllers and can be put outer
> > to threadgroup_lock.  Reverse the locking order in
> > attach_task_by_pid().
> > 
> 
> But the code contrast to the changelog. ;)
> 
> cgroup_mutex is currently outside of threadgroup_lock, and you're making
> it nested inside threadgroup_lock in the code.

Heh heh, thanks for spotting my idiocy.  Yeah, the locking order
between the two has been swapped a couple times while writing up the
original threadgroup_lock patch and I misremembered how it was at the
end and got totally confused when writing this patch.  Sorry about
that.  So, let's leave the locking in cgroup alone.  I like
cgroup_mutex to be the outer one.

Thanks.

-- 
tejun
