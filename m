Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaEBPM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:12:57 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:37366 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaEBPMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:12:54 -0400
Date: Fri, 2 May 2014 11:12:50 -0400
From: Tejun Heo <tj@kernel.org>
To: Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET cgroup/for-3.15] cgroup: implement unified hierarchy
Message-ID: <20140502151250.GB10204@htj.dyndns.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
 <20140414154556.GA9552@redhat.com>
 <20140414175236.GB15249@htj.dyndns.org>
 <CAC4Lta0qd2vW4ENSOpzK+0i06MorzfmsZZZuW9xUtpZ_gWA9gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC4Lta0qd2vW4ENSOpzK+0i06MorzfmsZZZuW9xUtpZ_gWA9gA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Apr 30, 2014 at 04:27:51PM +0530, Raghavendra KT wrote:
> For some controllers like cpuset, when we have exclusive_cpu is set,
> what about having a knob in the cpuset controller
> to move the task to non-root (when option is set).

I'm doubtful.

> Because all the way along, though we have freedom to make the cpusets
> exclusive and move tasks (say VMs) into them,
> making sure they do not interfere with each other, we can not prevent
> the other tasks spawned in a system eating into cpus of
> exclusive cpuset since they go to root automatically.

I believe the right thing to do would be starting / confining other
tasks in the appropriate non-root cgroups.  cgroup already provides
mechanisms to achieve that.  The rest is upto userland.

> Do you think having a knob, to make sure new tasks spawned go to say a
> default  directory under root makes sense?
> 
>  I understand that we could easily have a userspace script which could
> achieve intended goal, but kernel solution
>  would really make the exclusive cpusets have exclusive access to cpus
> it should have.

This would just be a more reliable implementation of an ad-hoc
mechanism when it can already be properly achieved by managing cgroups
of all processes in the system.

> (I also have a POC implemented for pre-unified hierarchy tree and
> understand some bit of complications involved in that and
> understand that we should not have complex policies in kernel for e.g.
> filtering tasks based on patterns etc..).

As I wrote above, I think this is something to be solved from
userland.  I'm very positively against adding this sort of hacky
ad-hoc policies which serves one or a few use cases well while
introducing possible long-term maintenance issues.

Thanks.

-- 
tejun
