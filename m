Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab3DOCuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:50:22 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:25914 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab3DOCuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:50:16 -0400
Message-ID: <516B6AD8.4000807@huawei.com>
Date: Mon, 15 Apr 2013 10:50:00 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <mhocko@suse.cz>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <glommer@parallels.com>,
        <vgoyal@redhat.com>
Subject: Re: [PATCHSET] cgroup, memcg: introduce sane_behavior mount option
References: <1365808259-31073-1-git-send-email-tj@kernel.org>
In-Reply-To: <1365808259-31073-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/13 7:10, Tejun Heo wrote:
> It's a sad fact that at this point various cgroup controllers are
> carrying so many idiosyncrasies and pure insanities that it simply
> isn't possible to reach any sort of sane consistent behavior while
> staying compatible with what already has been exposed to userland.
> 
> To make progress, those behaviors need to go but we can't simply drop
> or change the crazies as those are directly visible to userland.  This
> patchset implements a mount option - sane_behavior - which turns on
> new saner behaviors, so that we can keep providing the old behaviors
> while and after transitioning to saner ones.
> 
> As the behaviors which should be changed are still being determined
> and then implemented, __DEVEL__ prefix is added to the mount option
> and it triggers a warning message when used.
> 
> The mount option changes the following behaviors after this patchset.
> 
> * Mount options "noprefix" and "clone_children" are disallowed.  Also,
>   cgroupfs file cgroup.clone_children is not created.
> 
> * When mounting an existing superblock, mount options should match.
>   This is currently pretty crazy.  If one mounts a cgroup, creates a
>   subdirectory, unmounts it and then mount it again with different
>   option, it looks like the new options are applied but they aren't.
> 
> * Remount is disallowed.
> 
> * memcg: .use_hierarchy is forced on and the cgroupfs file is not
>   created.
> 
> and there are a lot more to come.  Basically, when turned on, all
> controllers should be ready to be mounted in the same hierarchy and
> not get in the way unless specifically configured - making blk-throtl
> hierarchical would need this to flip the meaning of limits, cpuset to
> allow tasks to run by default in new cgroups and handle empty cpusets
> in a way friendly to being co-mounted, and so on.
> 
> This patchset contains the following four patches.
> 
>  0001-cgroup-convert-cgroupfs_root-flag-bits-to-masks-and-.patch
>  0002-move-cgroupfs_root-to-include-linux-cgroup.h.patch
>  0003-cgroup-introduce-sane_behavior-mount-option.patch
>  0004-memcg-force-use_hierarchy-if-sane_behavior.patch
> 
> 0001-0002 are prep patches.  It exposes cgroupfs_root in cgroup.h so
> that flags can be tested with inline helpers.
> 
> 0003 introduces sane_behavior mount option and implements behavior
> changes in cgroup core proper.
> 
> 0004 makes memcg .use_hierarchy changes.
> 

Looks good to me!

Acked-by: Li Zefan <lizefan@huawei.com>

