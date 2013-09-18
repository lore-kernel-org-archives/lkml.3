Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab3IRVPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 17:15:45 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:38665 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab3IRVPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 17:15:43 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: [PATCHSET] sysfs: implement sysfs_remove()
Date: Wed, 18 Sep 2013 17:15:34 -0400
Message-Id: <1379538938-5032-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Currently, there are multiple variants of internal sysfs removal
functions and the directory removal behavior is a bit weird in that
while it does remove the files contained immediately in the directory
it wouldn't recurse into its subdirectories, even the group ones which
belong to the same kobject.

This patchset restructures sysfs removal path so that there is single
internal removal function which is fully recursive.  This will be the
only removal interface in the planned new interface based on
sysfs_dirents instead of kobjects.

This patchset contains the following four patches.

 0001-sysfs-remove-sysfs_addrm_cxt-parent_sd.patch
 0002-kobject-grab-an-extra-reference-on-kobject-sd-to-all.patch
 0003-sysfs-make-__sysfs_remove_dir-recursive.patch
 0004-sysfs-introduce-__-sysfs_remove.patch

The patches are on top of

  linus#master c2d95729e3 ("Merge branch 'akpm' (patches from Andrew Morton)")
+ [1] [PATCHSET] sysfs: disentangle kobject namespace handling from sysfs

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-sysfs-recursive-rm

 fs/sysfs/dir.c     |  161 ++++++++++++++++++++++++++++++++++++-----------------
 fs/sysfs/file.c    |    4 -
 fs/sysfs/group.c   |    4 -
 fs/sysfs/inode.c   |    4 -
 fs/sysfs/symlink.c |    6 -
 fs/sysfs/sysfs.h   |   14 ++--
 lib/kobject.c      |   12 +++
 7 files changed, 139 insertions(+), 66 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1560372
