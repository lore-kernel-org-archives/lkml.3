Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658AbaGOK1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:27:33 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:41461 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038AbaGOK1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:27:30 -0400
Message-ID: <53C5020B.60303@huawei.com>
Date: Tue, 15 Jul 2014 18:27:23 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET v2 cgroup/for-3.17] cgroup: distinguish the default
 and legacy hierarchies when handling cftypes
References: <1405352648-4279-1-git-send-email-tj@kernel.org>
In-Reply-To: <1405352648-4279-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ÓÚ 2014/7/14 23:44, Tejun Heo Ð´µÀ:
> Hello,
> 
> This is v2 of dfl_files patchset.  Changes from the last version [1]
> are
> 
> * Rebased on top of cgroup/for-3.17.
> 
> * 0004 updated so that CFTYPE_ONLY_ON_DFL and CFTYPE_INSANE are
>   cleared when cfts are removed as suggested by Li.
> 
> Until now, cftype arrays carried files for both the default and legacy
> hierarchies and the files which needed to be used on only one of them
> were flagged with either CFTYPE_ONLY_ON_DFL or CFTYPE_INSANE.  This
> gets confusing very quickly and we may end up exposing interface files
> to the default hierarchy without thinking it through.
> 
> This patchset makes cgroup core provide separate sets of interfaces
> for cftype handling so that the cftypes for the default and legacy
> hierarchies are clearly distinguished.  This makes all the existing
> subsystem interface files legacy-only by default and all subsystems
> will have no interface file created when enabled on the default
> hierarchy.  Each subsystem should explicitly review and compose the
> interface for the default hierarchy.
> 
> This patchset contains the following six patches.
> 
>  0001-cgroup-split-cgroup_base_files-into-cgroup_-dfl-lega.patch
>  0002-cgroup-rename-cgroup_subsys-base_cftypes-to-legacy_c.patch
>  0003-cgroup-replace-cgroup_add_cftypes-with-cgroup_add_le.patch
>  0004-cgroup-distinguish-the-default-and-legacy-hierarchie.patch
>  0005-cgroup-make-CFTYPE_ONLY_ON_DFL-and-CFTYPE_NO_-intern.patch
>  0006-cgroup-initialize-cgrp_dfl_root_inhibit_ss_mask-from.patch
> 
> This patchset is on top of afd1a8b3e0bc ("cpuset: export effective
> masks to userspace")
> 
> and available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-dfl_files-v2
> 
> diffstat follows.  Thanks.
> 
>  Documentation/cgroups/unified-hierarchy.txt |   18 ++-
>  block/blk-cgroup.c                          |    5
>  include/linux/cgroup.h                      |   17 ++
>  kernel/cgroup.c                             |  160 +++++++++++++++++++++-------
>  kernel/cgroup_freezer.c                     |    2
>  kernel/cpuset.c                             |    2
>  kernel/sched/core.c                         |    2
>  kernel/sched/cpuacct.c                      |    2
>  mm/hugetlb_cgroup.c                         |    5
>  mm/memcontrol.c                             |    6 -
>  net/core/netclassid_cgroup.c                |    2
>  net/core/netprio_cgroup.c                   |    2
>  net/ipv4/tcp_memcontrol.c                   |    2
>  security/device_cgroup.c                    |    2
>  14 files changed, 160 insertions(+), 67 deletions(-)
> 

Acked-by: Li Zefan <lizefan@huawei.com>

