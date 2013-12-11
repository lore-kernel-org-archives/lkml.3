Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab3LKTMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:12:33 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:41925 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab3LKTMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:12:30 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, linus.walleij@linaro.org,
        ashutosh.dixit@intel.com
Subject: [PATCHSET driver-core-next] kernfs: s/sysfs/kernfs/
Date: Wed, 11 Dec 2013 14:11:52 -0500
Message-Id: <1386789118-24733-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

kernfs just got separated out from sysfs and contains a lot of names
carried over from sysfs which are misnomers.  Thanks to the code
movement and large-scale reorganization, kernfs code is already in
full conflict mode with any patches generated against sysfs prior the
separation and in a lot of cases those conflicts won't be simple "file
moved there" conflicts but deeper ones due to the large scale
refactoring which happened for the separation.

We can't really make the situation much worse.  Let's take the chance
and rename things so that the misnomers in kernfs don't cause
confusions in the future.

This patchset contains the following six rename patches.

 0001-kernfs-s-sysfs_dirent-kernfs_node-and-rename-its-fri.patch
 0002-kernfs-drop-s_-prefix-from-kernfs_node-members.patch
 0003-kernfs-s-sysfs-kernfs-in-various-data-structures.patch
 0004-kernfs-s-sysfs-kernfs-in-constants.patch
 0005-kernfs-s-sysfs-kernfs-in-global-variables.patch
 0006-kernfs-s-sysfs-kernfs-in-internal-functions-and-what.patch

While the patches are fairly large, they are all trivial rename
patches.  Nothing else.  There's no functional change to the code base
before and after.

This patchset is based on the current driver-core-next a8b1c0193602
("Documentation: start documenting driver design patterns") and also
available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-kernfs-rename

diffstat follows.

 drivers/gpio/gpiolib.c             |    4
 drivers/md/bitmap.c                |    2
 drivers/md/bitmap.h                |    2
 drivers/md/md.h                    |   10
 drivers/misc/mic/host/mic_device.h |    2
 fs/kernfs/dir.c                    |  776 ++++++++++++++++++-------------------
 fs/kernfs/file.c                   |  389 +++++++++---------
 fs/kernfs/inode.c                  |  227 +++++-----
 fs/kernfs/kernfs-internal.h        |   96 ++--
 fs/kernfs/mount.c                  |   56 +-
 fs/kernfs/symlink.c                |  110 ++---
 fs/sysfs/dir.c                     |   66 +--
 fs/sysfs/file.c                    |  132 +++---
 fs/sysfs/group.c                   |   96 ++--
 fs/sysfs/mount.c                   |    4
 fs/sysfs/symlink.c                 |   76 +--
 fs/sysfs/sysfs.h                   |   10
 include/linux/kernfs.h             |  226 +++++-----
 include/linux/kobject.h            |    2
 include/linux/sysfs.h              |   20
 lib/kobject.c                      |    2
 21 files changed, 1154 insertions(+), 1154 deletions(-)

Thanks.

--
tejun
