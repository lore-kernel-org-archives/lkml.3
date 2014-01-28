Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbaA1XdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:33:00 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:39520 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbaA1Xc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:32:59 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHSET driver-core-next] kernfs: prepare for cgroup's kernfs conversion
Date: Tue, 28 Jan 2014 18:32:42 -0500
Message-Id: <1390951971-15671-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset makes various updates in preparation of cgroup's kernfs
conversion.  This patchset contains the following 9 patches.

 0001-kernfs-invoke-dir_ops-while-holding-active-ref-of-th.patch
 0002-kernfs-rename-kernfs_dir_ops-to-kernfs_syscall_ops.patch
 0003-kernfs-implement-kernfs_syscall_ops-remount_fs-and-s.patch
 0004-kernfs-add-missing-kernfs_active-checks-in-directory.patch
 0005-kernfs-allow-nodes-to-be-created-in-the-deactivated-.patch
 0006-kernfs-implement-kernfs_ops-atomic_write_len.patch
 0007-kernfs-add-kernfs_open_file-priv.patch
 0008-kernfs-implement-kernfs_node_from_dentry-kernfs_root.patch
 0009-kernfs-implement-kernfs_get_parent-kernfs_name-path-.patch

 0001-0003 update kernfs_dir_ops for active ref protection, add
 additional syscall operations and rename the struct to
 kernfs_syscall_ops.

 0004-0005 implement an option to create new kernfs_nodes in
 deactivated state so that multiple nodes can be made visible
 atomically or removed without ever being visible to userland.

 0006 implements kernfs_ops->atomic_write_len which will be used to
 support cgroup cftype->max_write_len.

 0007 adds kernfs_open_file->priv.

 0008-0009 add various helpers and accessors.

This patchset is on top of

  linus#master 54c0a4b46150 ("Merge branch 'akpm' (incoming from Andrew)")
+ [1] [PATCHSET v4 driver-core-next] kernfs, sysfs, driver-core: implement synchronous

and also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-kernfs-cgroup-prep

diffstat follows.

 fs/kernfs/dir.c        |  325 ++++++++++++++++++++++++++++++++++++++++++++-----
 fs/kernfs/file.c       |   49 ++++---
 fs/kernfs/mount.c      |   37 +++++
 fs/sysfs/dir.c         |   44 +-----
 fs/sysfs/mount.c       |    2 
 include/linux/kernfs.h |   74 +++++++++--
 6 files changed, 436 insertions(+), 95 deletions(-)

Thanks.

--
tejun

[1] http://lkml.kernel.org/g/<1390951311-15325-1-git-send-email-tj@kernel.org>
