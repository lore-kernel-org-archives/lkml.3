Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaBINw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:52:57 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:37807 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbaBINwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:52:55 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHSET cgroup/for-3.15] cgroup: more cleanups
Date: Sun,  9 Feb 2014 08:52:28 -0500
Message-Id: <1391953964-22088-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series contains assorted cleanups which also prepare for the
planned migration taskset handling update.

This patchset contains the following sixteen patches.

 0001-cgroup-disallow-xattr-release_agent-and-name-if-sane.patch
 0002-cgroup-drop-CGRP_ROOT_SUBSYS_BOUND.patch
 0003-cgroup-enable-task_cg_lists-on-the-first-cgroup-moun.patch
 0004-cgroup-relocate-cgroup_enable_task_cg_lists.patch
 0005-cgroup-implement-cgroup_has_tasks-and-unexport-cgrou.patch
 0006-cgroup-reimplement-cgroup_transfer_tasks-without-usi.patch
 0007-cgroup-make-css_set_lock-a-rwsem-and-rename-it-to-cs.patch
 0008-cpuset-use-css_task_iter_start-next-end-instead-of-c.patch
 0009-cgroup-remove-css_scan_tasks.patch
 0010-cgroup-separate-out-put_css_set_locked-and-remove-pu.patch
 0011-cgroup-move-css_set_rwsem-locking-outside-of-cgroup_.patch
 0012-cgroup-drop-skip_css-from-cgroup_taskset_for_each.patch
 0013-cpuset-don-t-use-cgroup_taskset_cur_css.patch
 0014-cgroup-remove-cgroup_taskset_cur_css-and-cgroup_task.patch
 0015-cgroup-cosmetic-updates-to-cgroup_attach_task.patch
 0016-cgroup-unexport-functions.patch

The notables ones are

 0003-0004 move task_cg_list enabling to the first mount instead of
 the first css task iteration.

 0005-0009 make css_set_lock a rwsem so that css_task_iter allows
 blocking during iteration and removes css_scan_tasks().

 0010-0015 clean up migration path to prepare for the planned
 migration taskset handling update.

This patchset is on top of

  cgroup/for-3.15 f7cef064aa01 ("Merge branch 'driver-core-next' into cgroup/for-3.15")
+ [1] [PATCHSET v2 cgroup/for-3.15] cgroup: convert to kernfs
+ [2] [PATCHSET v2 cgroup/for-3.15] cgroup: cleanups after kernfs conversion

and also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-moar-cleanups

diffstat follows.

 block/blk-cgroup.c           |    2 
 include/linux/cgroup.h       |   33 --
 kernel/cgroup.c              |  579 ++++++++++++++-----------------------------
 kernel/cgroup_freezer.c      |    2 
 kernel/cpuset.c              |  201 ++++----------
 kernel/events/core.c         |    2 
 kernel/sched/core.c          |    4 
 mm/memcontrol.c              |    4 
 net/core/netclassid_cgroup.c |    2 
 net/core/netprio_cgroup.c    |    2 
 10 files changed, 278 insertions(+), 553 deletions(-)

Thanks.

--
tejun

[1] http://lkml.kernel.org/g/1391876127-7134-1-git-send-email-tj@kernel.org
[2] http://lkml.kernel.org/g/1391877509-10855-1-git-send-email-tj@kernel.org
