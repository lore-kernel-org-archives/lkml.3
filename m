Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbaDRVi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:38:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbaDRViV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:38:21 -0400
Date: Fri, 18 Apr 2014 14:38:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] Driver core / sysfs fixes for 3.15-rc2
Message-ID: <20140418213830.GA3780@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.15-rc2

for you to fetch changes up to 94f8cc0eea03648e5cc5de1a4e7dc464de92cc74:

  drivers/base/dd.c incorrect pr_debug() parameters (2014-04-16 19:34:46 -0700)

----------------------------------------------------------------
driver core fixes for 3.15-rc2

Here are some driver core fixes for 3.15-rc2.  Also in here are some
documentation updates, as well as an API removal that had to wait for
after -rc1 due to the cleanups coming into you from multiple developer
trees (this one and the PPC tree.)

All have been in linux next successfully.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Brian Norris (1):
      stable_kernel_rules: spelling/word usage

Frank Rowand (1):
      drivers/base/dd.c incorrect pr_debug() parameters

Geert Uytterhoeven (1):
      Documentation: Update stable address in Chinese and Japanese translations

Lin Yongting (1):
      Chinese: add translation of io_ordering.txt

Tejun Heo (2):
      kernfs: protect lazy kernfs_iattrs allocation with mutex
      sysfs, driver-core: remove unused {sysfs|device}_schedule_callback_owner()

Thomas Bächler (1):
      fs: Don't return 0 from get_anon_bdev

Vincent Stehlé (1):
      topology: Fix compilation warning when not in SMP

 Documentation/ja_JP/HOWTO                   |  2 +-
 Documentation/ja_JP/stable_kernel_rules.txt |  6 +-
 Documentation/stable_kernel_rules.txt       |  2 +-
 Documentation/zh_CN/HOWTO                   |  2 +-
 Documentation/zh_CN/io_ordering.txt         | 67 +++++++++++++++++++++
 Documentation/zh_CN/stable_kernel_rules.txt |  2 +-
 drivers/base/core.c                         | 33 -----------
 drivers/base/dd.c                           |  4 +-
 drivers/base/topology.c                     |  3 +-
 fs/kernfs/inode.c                           | 14 +++--
 fs/super.c                                  |  5 +-
 fs/sysfs/file.c                             | 92 -----------------------------
 include/linux/device.h                      | 11 +---
 include/linux/sysfs.h                       |  9 ---
 14 files changed, 92 insertions(+), 160 deletions(-)
 create mode 100644 Documentation/zh_CN/io_ordering.txt
