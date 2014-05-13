Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaEMGfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 02:35:13 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:52012 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaEMGfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 02:35:11 -0400
Message-ID: <5371BD0D.9080801@huawei.com>
Date: Tue, 13 May 2014 14:34:53 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <vgoyal@redhat.com>, <axboe@kernel.dk>, <hannes@cmpxchg.org>,
        <mhocko@suse.cz>, <arozansk@redhat.com>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement cftype->write()
References: <1399380266-3324-1-git-send-email-tj@kernel.org>
In-Reply-To: <1399380266-3324-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/6 20:44, Tejun Heo wrote:
> Hello,
> 
> This patchset implements a new cftype operation ->write() and replace
> ->write_string() and ->trigger() with it.  ->write() is similar to
> ->write_string() but maps directly to the kernfs write operation and
> has access to all available context information including the
> associated kernfs_open_file, which will make things like implementing
> kernfs active protection manipulation easier.
> 
> ->write_string() becomes redundant and ->trigger() has always been
> spurious.  This patch replaces all users of the two methods to
> ->write() and remove them.
> 
> This patchset contains the following five patches.
> 
>  0001-cgroup-implement-cftype-write.patch
>  0002-cgroup-replace-cftype-write_string-with-cftype-write.patch
>  0003-cgroup-replace-cftype-trigger-with-cftype-write.patch
>  0004-cgroup-convert-tasks-and-cgroup.procs-handle-to-use-.patch
>  0005-cgroup-remove-cgroup-control_kn.patch
> 
> 0001 implements cftype->write().
> 
> 0002-0003 replace cftype->write_string() and ->trigger() with it.
> 
> 0004 convert "tasks" and "cgroup.procs" handler too.
> 
> 0005 removes cgroup->control_kn as the kernfs_node is now directly
> accessible from kernfs_open_file.
> 
> This patchset is on top of
> 
>   cgroup/for-3.16 12d3089c192c ("kernel/cpuset.c: convert printk to pr_foo()")
> + [1] [PATCHSET cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates
> 
> and available on the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-post-unified-updates
> 
> diffstat follows.
> 
>  block/blk-throttle.c      |   32 ++++++++---------
>  block/cfq-iosched.c       |   28 +++++++--------
>  include/linux/cgroup.h    |   40 +++++++++++----------
>  kernel/cgroup.c           |   85 +++++++++++++++++++++++-----------------------
>  kernel/cgroup_freezer.c   |   20 ++++------
>  kernel/cpuset.c           |   16 ++++----
>  mm/hugetlb_cgroup.c       |   33 +++++++++--------
>  mm/memcontrol.c           |   80 +++++++++++++++++++++++--------------------
>  net/ipv4/tcp_memcontrol.c |   31 +++++++++-------
>  security/device_cgroup.c  |   14 +++----
>  10 files changed, 197 insertions(+), 182 deletions(-)
> 

Acked-by: Li Zefan <lizefan@huawei.com>

