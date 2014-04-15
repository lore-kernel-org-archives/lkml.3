Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaDOCYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 22:24:16 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:15039 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaDOCYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 22:24:13 -0400
Message-ID: <534C983B.7080701@huawei.com>
Date: Tue, 15 Apr 2014 10:23:55 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement unified hierarchy,
 v2
References: <1397511430-2673-1-git-send-email-tj@kernel.org>
In-Reply-To: <1397511430-2673-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patchset finally implements the default unified hierarchy.  The
> goal is providing enough flexibility while enforcing stricter common
> structure where appropriate to address the above listed issues.
> 
> Controllers which aren't bound to other hierarchies are
> automatically attached to the unified hierarchy, which is different in
> that controllers are enabled explicitly for each subtree.
> "cgroup.subtree_control" controls which controllers are enabled on the
> child cgroups.  Let's assume a hierarchy like the following.
> 
>   root - A - B - C
>                \ D
> 
> root's "cgroup.subtree_control" determines which controllers are
> enabled on A.  A's on B.  B's on C and D.  This coincides with the
> fact that controllers on the immediate sub-level are used to
> distribute the resources of the parent.  In fact, it's natural to
> assume that resource control knobs of a child belong to its parent.
> Enabling a controller in "cgroup.subtree_control" declares that
> distribution of the respective resources of the cgroup will be
> controlled.  Note that this means that controller enable states are
> shared among siblings.
> 
> The default hierarchy has an extra restriction - only cgroups which
> don't contain any task may have controllers enabled in
> "cgroup.subtree_control".  Combined with the other properties of the
> default hierarchy, this guarantees that, from the view point of
> controllers, tasks are only on the leaf cgroups.  In other words, only
> leaf csses may contain tasks.  This rules out situations where child
> cgroups compete against internal tasks of the parent.
> 

Right after bootup:

# mount -t cgroup -o __DEVEL__sane_behavior xxx /mnt
# ls /mnt
cgroup.controllers  cgroup.procs  cgroup.sane_behavior  cgroup.subtree_control
# cat /mnt/cgroup.controllers
cpuset cpu cpuacct memory devices freezer net_cls blkio perf_event hugetlb

I don't see any controller knobs...

