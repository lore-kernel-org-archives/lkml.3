Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab3DNShJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 14:37:09 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:57464 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab3DNShH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 14:37:07 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, kay@vrfy.org, greg@kroah.com,
        lennart@poettering.net, daniel@zonque.org
Subject: [PATCHSET] cgroup: implement task_cgroup_path_from_hierarchy()
Date: Sun, 14 Apr 2013 11:36:55 -0700
Message-Id: <1365964619-14762-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kdbus folks want a sane way to determine the cgroup path that a given
task belongs to on a given hierarchy, which is a reasonble thing to
expect from cgroup core.

This patchset make hierarchy_id allocation use idr instead of ida and
implement task_cgroup_path_from_hierarchy().  In the process, the
yucky ida cyclic allocation is replaced with idr_alloc_cyclic().

 0001-cgroup-refactor-hierarchy_id-handling.patch
 0002-cgroup-drop-hierarchy_id_lock.patch
 0003-cgroup-make-hierarchy_id-use-cyclic-idr.patch
 0004-cgroup-implement-task_cgroup_path_from_hierarchy.patch

0001-0002 prepare for conversion to idr, which 0003 does.

0004 implements the new function.

This patchset is on top of next-20130412 as idr_alloc_cyclic() patch
is currently in -mm.  Given that this isn't an urgent thing and the
merge window is just around the corner, it'd be probably best to route
these through cgroup/for-3.11 once v3.10-rc1 drops.

These patches are also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-task_cgroup_path_from_hierarchy

And it actually reduces LOC.  Woot Woot.

 include/linux/cgroup.h |    2
 kernel/cgroup.c        |  128 +++++++++++++++++++++++++++++++++----------------
 2 files changed, 89 insertions(+), 41 deletions(-)

--
tejun
