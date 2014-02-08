Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaBHQie (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 11:38:34 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:60200 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaBHQid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 11:38:33 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHSET v2 cgroup/for-3.15] cgroup: cleanups after kernfs conversion
Date: Sat,  8 Feb 2014 11:38:21 -0500
Message-Id: <1391877509-10855-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is v2 of cleanups-after-kernfs-conversion patchset.  Nothing
really changed since the last take[L]. It just got rebased on top of
the updated patches.

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

  cgroup/for-3.15 f7cef064aa01 ("Merge branch 'driver-core-next' into cgroup/for-3.15")
+ [1] [PATCHSET v2 cgroup/for-3.15] cgroup: convert to kernfs

and also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-post-kernfs-conversion

 fs/kernfs/dir.c        |    1
 include/linux/cgroup.h |   91 ++++------
 kernel/cgroup.c        |  417 +++++++++++++++++--------------------------------
 kernel/cpuset.c        |   27 +--
 kernel/sched/debug.c   |    3
 mm/memcontrol.c        |   68 ++-----
 7 files changed, 229 insertions(+), 390 deletions(-)

Thanks.

--
tejun

[L] http://lkml.kernel.org/g/1390953585-16554-1-git-send-email-tj@kernel.org
[1] http://lkml.kernel.org/g/1391876127-7134-1-git-send-email-tj@kernel.org
