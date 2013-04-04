Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765470Ab3DDXgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:36:53 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:56643 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765340Ab3DDXgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:36:51 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHSET] cgroup: unexport locking interface
Date: Thu,  4 Apr 2013 16:36:24 -0700
Message-Id: <1365118589-10619-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Most cgroup_mutex abuses outside cgroup core proper have been
eradicated but there's still one use remaining and locking interface
is still exported.  This patchset updates the last user and unexports
the locking interface and is composed of the following five patches.

 0001-cgroup-cpuset-replace-move_member_tasks_to_cpuset-wi.patch
 0002-cgroup-relocate-cgroup_lock_live_group-and-cgroup_at.patch
 0003-cgroup-unexport-locking-interface-and-cgroup_attach_.patch
 0004-cgroup-kill-cgroup_-un-lock.patch
 0005-cgroup-remove-cgroup_lock_is_held.patch

It's on top of cgroup/for-3.10 a423ecb8a ("memcg: fix
memcg_cache_name() to use cgroup_name()") and available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-unexport-locking

diffstat follows.  Thanks.

 include/linux/cgroup.h |   19 +++--
 kernel/cgroup.c        |  162 ++++++++++++++++++++++++-------------------------
 kernel/cpuset.c        |   51 +--------------
 3 files changed, 96 insertions(+), 136 deletions(-)

--
tejun
