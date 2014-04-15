Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaDOWIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:08:15 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:47971 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaDOWIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:08:13 -0400
Date: Tue, 15 Apr 2014 18:08:09 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement unified hierarchy,
 v2
Message-ID: <20140415220809.GD13099@mtj.dyndns.org>
References: <1397511430-2673-1-git-send-email-tj@kernel.org>
 <534C983B.7080701@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534C983B.7080701@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 10:23:55AM +0800, Li Zefan wrote:
> Right after bootup:
> 
> # mount -t cgroup -o __DEVEL__sane_behavior xxx /mnt
> # ls /mnt
> cgroup.controllers  cgroup.procs  cgroup.sane_behavior  cgroup.subtree_control
> # cat /mnt/cgroup.controllers
> cpuset cpu cpuacct memory devices freezer net_cls blkio perf_event hugetlb
> 
> I don't see any controller knobs...

This was because cgroup_apply_cftypes() was skipping the default
hierarchy while rebinding correctly populated it.  I was alwasy
testing by unmounting other hierarchies so never noticed it.  The 0.5
patch that I just posted should fix the issue.  git branches have been
updated accordingly.

Thanks

-- 
tejun
