Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbaEMGf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 02:35:27 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:17255 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaEMGfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 02:35:24 -0400
Message-ID: <5371BD26.8080607@huawei.com>
Date: Tue, 13 May 2014 14:35:18 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET v2 cgroup/for-3.16] cgroup: post unified hierarchy
 fixes and updates
References: <1399663975-315-1-git-send-email-tj@kernel.org>
In-Reply-To: <1399663975-315-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/10 3:32, Tejun Heo wrote:
> Hello,
> 
> Changes from the last take[L] are,
> 
> * 0002, 0003 and 0007 added.
> 
> * Other patches are refreshed without content change.
> 
> This patchset contains the following seven patches.
> 
>  0001-cgroup-fix-offlining-child-waiting-in-cgroup_subtree.patch
>  0002-cgroup-cgroup_idr_lock-should-be-bh.patch
>  0003-cgroup-css_release-shouldn-t-clear-cgroup-subsys.patch
>  0004-cgroup-update-and-fix-parsing-of-cgroup.subtree_cont.patch
>  0005-cgroup-use-restart_syscall-for-retries-after-offline.patch
>  0006-cgroup-use-release_agent_path_lock-in-cgroup_release.patch
>  0007-cgroup-rename-css_tryget-to-css_tryget_online.patch
> 
> 0001 fixes two bugs in cgroup_subtree_control_write().
> 
> 0004 fixes and makes subtree_control parsing stricter.
> 
> 0005 simplifies cgroup_substree_control_write() retry path by using
> restart_syscall().
> 
> 0006 makes cgroup_release_agent_show() use release_path_lock.  The
> original conversion missed this one.
> 
> 0007 renames css_tryget() to css_tryget_online().  This patch was
> posted separately before - [1] - and acked by Michal and Johannes.
> 
> This patchset is on top of cgroup/for-3.16 6e1a046e9458 ("Merge branch
> 'for-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu
> into for-3.16") and available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-post-unified-updates-v2
> 
> diffstat follows.
> 
>  block/blk-cgroup.c     |    2 -
>  fs/bio.c               |    2 -
>  include/linux/cgroup.h |   14 +++----
>  kernel/cgroup.c        |   88 +++++++++++++++++++++++++------------------------
>  kernel/cpuset.c        |    6 +--
>  kernel/events/core.c   |    3 +
>  mm/hugetlb_cgroup.c    |    2 -
>  mm/memcontrol.c        |   46 +++++++++++++------------
>  8 files changed, 84 insertions(+), 79 deletions(-)
> 

Acked-by: Li Zefan <lizefan@huawei.com>

