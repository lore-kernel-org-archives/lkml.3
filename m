Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbaEFLuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:50:50 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:57685 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaEFLur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:50:47 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHSET cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates
Date: Tue,  6 May 2014 07:50:40 -0400
Message-Id: <1399377044-29873-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset contains the following four patches.

 0001-cgroup-fix-offlining-child-waiting-in-cgroup_subtree.patch
 0002-cgroup-only-allow-space-as-the-separator-for-cgroup..patch
 0003-cgroup-use-restart_syscall-for-retries-after-offline.patch
 0004-cgroup-use-release_agent_path_lock-in-cgroup_release.patch

0001 fixes two bugs in cgroup_subtree_control_write().

0002 makes subtree_control parsing stricter.

0003 simplifies cgroup_substree_control_write() retry path by using
restart_syscall().

0004 makes cgroup_release_agent_show() use release_path_lock.  The
original conversion missed this one.

This patchset is on top of cgroup/for-3.16 12d3089c192c
("kernel/cpuset.c: convert printk to pr_foo()") and available on the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-post-unified-updates

diffstat follows.

 kernel/cgroup.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

Thanks.

--
tejun
