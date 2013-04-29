Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab3D2QYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:24:50 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:62231 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3D2QXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:23:40 -0400
Date: Mon, 29 Apr 2013 09:21:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core patches for 3.10-rc1
Message-ID: <20130429162157.GA6908@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 41ef2d5678d83af030125550329b6ae8b74618fa:

  Linux 3.9-rc7 (2013-04-14 17:45:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.10-rc1

for you to fetch changes up to 0d1d392f011b284bb4af0411b2d36e5d04e0f058:

  Merge 3.9-rc7 into driver-core-next (2013-04-14 18:37:05 -0700)

----------------------------------------------------------------

Driver core update for 3.10-rc1

Here's the merge request for the driver core tree for 3.10-rc1

It's pretty small, just a number of driver core and sysfs updates and
fixes, all of which have been in linux-next for a while now.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Arnd Bergmann (1):
      sysfs: fix crash_notes_size build warning

Fabio Porcedda (3):
      driver core: warn that platform_driver_probe can not use deferred probing
      driver core: platform.c: fix checkpatch errors and warnings
      driver core: platform_device.h: fix checkpatch errors and warnings

Felipe Balbi (1):
      base: core: WARN() about bogus permissions on device attributes

Greg Kroah-Hartman (6):
      Merge 3.9-rc4 into driver-core-next
      rtmutex-tester: fix mode of sysfs files
      Merge v3.9-rc5 into driver-core-next
      devtmpfs: add base.h include
      driver core: handle user namespaces properly with the uid/gid devtmpfs change
      Merge 3.9-rc7 into driver-core-next

Kay Sievers (1):
      driver core: add uid and gid to devtmpfs

Maarten Lankhorst (1):
      sysfs: use atomic_inc_unless_negative in sysfs_get_active

Michal Hocko (1):
      device: separate all subsys mutexes

Ming Lei (3):
      sysfs: fix use after free in case of concurrent read/write and readdir
      sysfs: check if one entry has been removed before freeing
      driver core: devtmpfs: fix compile failure with CONFIG_UIDGID_STRICT_TYPE_CHECKS

Ulf Hansson (1):
      PM / Runtime: Idle devices asynchronously after probe|release

Zhang Yanfei (2):
      sysfs: Add crash_notes_size to export percpu note size
      Documentation: Add ABI entry for crash_notes and crash_notes_size

 Documentation/ABI/testing/sysfs-devices-system-cpu | 12 +++++++
 block/genhd.c                                      |  3 +-
 drivers/base/bus.c                                 |  8 ++---
 drivers/base/core.c                                | 26 +++++++++++---
 drivers/base/cpu.c                                 | 14 ++++++++
 drivers/base/dd.c                                  |  6 ++--
 drivers/base/devtmpfs.c                            | 28 +++++++++------
 drivers/base/platform.c                            | 24 +++++++------
 drivers/usb/core/usb.c                             |  3 +-
 fs/sysfs/dir.c                                     | 41 +++++++++++-----------
 include/linux/device.h                             | 19 +++++-----
 include/linux/platform_device.h                    | 25 +++++++------
 kernel/rtmutex-tester.c                            |  4 +--
 13 files changed, 135 insertions(+), 78 deletions(-)
