Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbaDNVoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:44:14 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:57893 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbaDNVoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:44:11 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, john@johnmccutchan.com, rlove@rlove.org,
        eparis@parisplace.org, gregkh@linuxfoundation.org,
        serge.hallyn@ubuntu.com, lennart@poettering.net, kay@vrfy.org
Subject: [PATCHSET cgroup/for-3.16] cgroup: implement cgroup.populated, v2
Date: Mon, 14 Apr 2014 17:44:03 -0400
Message-Id: <1397511846-2904-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is v2 of cgroup.populated patchset changes from v1[L] are,

* Rebased on top of v3.15-rc1

* Patch description updated for the third patch as per Serge.

(inotify folks, can you please review the second patch which hooks up
 kernfs_notify() with fsnotify?  It works but directly invoking
 fsnotify_parent() and fsnotify() feels a bit dirty.  Maybe something
 like fsnotify_notify_modify_by_dentry() would make more sense?)

cgroup users often need a way to determine when a cgroup's
subhierarchy becomes empty so that it can be cleaned up.  cgroup
currently provides release_agent for it; unfortunately, this mechanism
is riddled with issues.  This patchset implements a replacement
mechanism "cgroup.subtree_populated" which can be used to monitor
whether the cgroup's subhierarchy has tasks in it or not and triggers
poll and [di]notify events when its content changes.

This patchset contains the following three patches.

 0001-kernfs-implement-kernfs_root-supers-list.patch
 0002-kernfs-make-kernfs_notify-trigger-inotify-events-too.patch
 0003-cgroup-implement-cgroup.subtree_populated-for-the-de.patch

0001-0002 add [di]notify notification to kernfs_notify().

0003 implements cgroup.subtree_populated.

This patchset is on top of "cgroup: implement unified hierarchy, v2"
patchset[1] and availalbe in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-populated

diffstat follows.

 fs/kernfs/dir.c             |    1 
 fs/kernfs/file.c            |   41 +++++++++++++++++++++++----
 fs/kernfs/kernfs-internal.h |    5 +++
 fs/kernfs/mount.c           |   11 +++++++
 include/linux/cgroup.h      |   15 ++++++++++
 include/linux/kernfs.h      |    4 ++
 kernel/cgroup.c             |   65 +++++++++++++++++++++++++++++++++++++++++---
 7 files changed, 132 insertions(+), 10 deletions(-)

Thanks.

--
tejun

[L] http://lkml.kernel.org/g/1397056052-2829-1-git-send-email-tj@kernel.org
[1] http://lkml.kernel.org/g/1397511430-2673-1-git-send-email-tj@kernel.org
