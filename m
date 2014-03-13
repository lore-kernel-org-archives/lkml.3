Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbaCMTuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 15:50:19 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:56237 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbaCMTuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 15:50:17 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHSET cgroup/for-3.15] cgroup: prepare for the default unified hierarchy
Date: Thu, 13 Mar 2014 15:50:02 -0400
Message-Id: <1394740213-17626-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The planned unified hierarchy is just around the corner.  We're gonna
repurpose the dummy hierarchy to serve as the default unified
hierarchy.  Controllers which aren't attached to other hierarchies are
already automatically bound to the dummy hierarchy; however, the dummy
hierarchy is minimally initialized during boot and can't currently act
as a full hierarchy.

This patchset gradually turns the dummy hierarchy into fully
functional default one and makes it mountable via selecting
sane_behavior without any subsystems specified.  While this patchset
does make the default hierarchy mountable, the unified hierarchy
functionality isn't implemented yet and cgroup creation in the default
hierarchy is rejected for now.

This lays down all the boilerplate work for the unified hierarchy.
The next patchset will implement the actual unified functionality.

This patchset contains the following eleven patches.

 0001-cgroup-cgroup-subsys-should-be-cleared-after-the-css.patch
 0002-cgroup-relocate-setting-of-CGRP_DEAD.patch
 0003-cgroup-reorganize-cgroup-bootstrapping.patch
 0004-cgroup-use-cgroup_setup_root-to-initialize-cgroup_du.patch
 0005-cgroup-remove-NULL-checks-from-pr_cont_-cgroup_-name.patch
 0006-cgroup-treat-cgroup_dummy_root-as-an-equivalent-hier.patch
 0007-cgroup-move-subsys_mask-from-cgroupfs_root-to-cgroup.patch
 0008-cgroup-rename-cgroup_dummy_root-and-related-names.patch
 0009-cgroup-drop-const-from-buffer-of-cftype-write_string.patch
 0010-cgroup-make-cgrp_dfl_root-mountable.patch
 0011-cgroup-implement-CFTYPE_ONLY_ON_DFL.patch

0001-0002 are misc fix / prep.

0003-0009 (mostly) turn the dummy hierarchy into a full hierarchy
which takes on controllers which aren't attached to other hierarchies.

0010-0011 make the default hierarchy mountable and implement
CFTYPE_ONLY_DFL.

This patchset is on top of cgroup/for-3.15 b8dadcb58d54 ("cpuset: use
rcu_read_lock() to protect task_cs()").  diffstat follows.

 block/blk-throttle.c      |    4
 block/cfq-iosched.c       |    4
 include/linux/cgroup.h    |   57 ++---
 kernel/cgroup.c           |  464 +++++++++++++++++++++++++---------------------
 kernel/cgroup_freezer.c   |    2
 kernel/cpuset.c           |    2
 mm/hugetlb_cgroup.c       |    2
 mm/memcontrol.c           |    4
 net/core/netprio_cgroup.c |    2
 net/ipv4/tcp_memcontrol.c |    2
 security/device_cgroup.c  |    4
 11 files changed, 295 insertions(+), 252 deletions(-)

Thanks.

--
tejun

