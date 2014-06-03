Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbaFCFpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 01:45:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbaFCFpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 01:45:15 -0400
Date: Mon, 2 Jun 2014 22:45:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] Driver core / sysfs patches for 3.16-rc1
Message-ID: <20140603054512.GA11565@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4b660a7f5c8099d88d1a43d8ae138965112592c7:

  Linux 3.15-rc6 (2014-05-22 06:42:02 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.16-rc1

for you to fetch changes up to cda43576afa641d83ae268cb9795ae2a549d53d9:

  crypto/nx/nx-842: dev_set_drvdata can no longer fail (2014-05-28 13:39:51 -0700)

----------------------------------------------------------------
Driver core / kernfs pull request for 3.16-rc1

Here is the "big" pull request for 3.16-rc1.
Not a lot of changes here, some kernfs work, a revert of a very old
driver core change that ended up cauing some memory leaks on driver
probe error paths, and other minor things.

As was pointed out earlier today, one commit here,
26fc9cd200ec839e0b3095e05ae018f27314e7aa (kernfs: move the last
knowledge of sysfs out from kernfs) is also needed in your 3.15-final
branch as well.  If you could cherry-pick it there, it would be most
appreciated by Andy Lutomirski to prevent a regression there.

All of these have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Fabian Frederick (2):
      lib/devres.c: use dev in devm_request_and_ioremap
      lib/devres.c: fix checkpatch warnings

Greg Kroah-Hartman (2):
      Merge 3.15-rc3 into staging-next
      Merge 3.15-rc6 into driver-core-next

Jean Delvare (6):
      driver core: Move driver_data back to struct device
      driver core: dev_set_drvdata can no longer fail
      driver core: dev_set_drvdata returns void
      driver core: dev_get_drvdata: Don't check for NULL dev
      driver core: Inline dev_set/get_drvdata
      crypto/nx/nx-842: dev_set_drvdata can no longer fail

Jianyu Zhan (1):
      kernfs: move the last knowledge of sysfs out from kernfs

Michael Marineau (1):
      kobject: Make support for uevent_helper optional.

Robert ABEL (1):
      sysfs: fix attribute_group bin file path on removal

Simon Wunderlich (1):
      sysfs.h: don't return a void-valued expression in sysfs_remove_file

Tejun Heo (2):
      kernfs: implement kernfs_root->supers list
      kernfs: make kernfs_notify() trigger inotify events too

Tony Lindgren (1):
      init.h: Update initcall_sync variants to fix build errors

 drivers/base/Kconfig         | 17 +++++++++++------
 drivers/base/base.h          |  3 ---
 drivers/base/dd.c            | 26 --------------------------
 drivers/crypto/nx/nx-842.c   |  7 +------
 drivers/iommu/exynos-iommu.c |  7 +------
 drivers/vfio/vfio.c          |  8 +-------
 fs/kernfs/dir.c              |  1 +
 fs/kernfs/file.c             | 41 +++++++++++++++++++++++++++++++++++------
 fs/kernfs/kernfs-internal.h  |  5 +++++
 fs/kernfs/mount.c            | 22 +++++++++++++++++-----
 fs/sysfs/group.c             | 10 +++++-----
 fs/sysfs/mount.c             |  4 +++-
 include/linux/device.h       | 15 +++++++++++++--
 include/linux/init.h         | 14 +++++++++++++-
 include/linux/kernfs.h       | 17 ++++++++++++-----
 include/linux/kobject.h      |  2 ++
 include/linux/sysfs.h        |  2 +-
 kernel/cgroup.c              |  4 +++-
 kernel/ksysfs.c              |  5 ++++-
 kernel/sysctl.c              |  4 ++--
 lib/devres.c                 | 10 +++++-----
 lib/kobject_uevent.c         |  6 ++++++
 22 files changed, 141 insertions(+), 89 deletions(-)
