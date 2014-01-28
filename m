Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbaA1X7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:59:55 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:33589 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbaA1X7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:59:52 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHSET cgroup/for-3.15] cgroup: cleanups after kernfs conversion
Date: Tue, 28 Jan 2014 18:59:37 -0500
Message-Id: <1390953585-16554-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset does a number of cleanups which are possible now that
cgroup is converted to kernfs.  This patchset contains the following
eight patches.

 0001-cgroup-warn-if-xattr-is-specified-with-sane_behavior.patch
 0002-cgroup-relocate-cgroup_rm_cftypes.patch
 0003-cgroup-remove-cftype_set.patch
 0004-cgroup-simplify-dynamic-cftype-addition-and-removal.patch
 0005-cgroup-make-cgroup-hold-onto-its-kernfs_node.patch
 0006-cgroup-remove-cgroup-name.patch
 0007-cgroup-rename-cgroupfs_root-number_of_cgroups-to-nr_.patch
 0008-cgroup-remove-cgroupfs_root-refcnt.patch

This patchset is on top of

  linus#master 54c0a4b46150 ("Merge branch 'akpm' (incoming from Andrew)")
+ [1] [PATCHSET cgroup/for-3.14-fixes] cgroup: four misc fixes
+ [2] [PATCH] arm, pm, vmpressure: add missing slab.h includes
+ [3] [PATCHSET v2 cgroup/for-3.15] cgroup: drop module support and cgroup_root_mutex
+ git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-kernfs-cgroup-prep
+ [4] [PATCHSET cgroup/for-3.15] cgroup: convert to kernfs

and also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-post-kernfs-conversion

 block/blk-cgroup.h     |   12 -
 fs/kernfs/dir.c        |    1
 include/linux/cgroup.h |   91 ++++------
 kernel/cgroup.c        |  417 +++++++++++++++++--------------------------------
 kernel/cpuset.c        |   27 +--
 kernel/sched/debug.c   |    3
 mm/memcontrol.c        |   63 +------
 7 files changed, 228 insertions(+), 386 deletions(-)

Thanks.

--
tejun

[L] http://lkml.kernel.org/g/<1389982317-22225-1-git-send-email-tj@kernel.org>
[1] http://lkml.kernel.org/g/<1390923125-4369-1-git-send-email-tj@kernel.org>
[2] http://lkml.kernel.org/g/<20140128221922.GC16060@mtj.dyndns.org>
[3] http://lkml.kernel.org/g/<1390952641-15950-1-git-send-email-tj@kernel.org>
[4] http://lkml.kernel.org/g/<1390953285-16360-1-git-send-email-tj@kernel.org>
