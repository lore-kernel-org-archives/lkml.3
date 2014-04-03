Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaDCPyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:54:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:36133 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbaDCPyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:54:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,787,1389772800"; 
   d="scan'208";a="506254868"
Message-ID: <1396540149.6955.12.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBIFS changes for 3.15-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 03 Apr 2014 18:49:09 +0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 5547fec74a566e1f5e00a937b9a367f7c6a94a8b:

  UBI: fix some use after free bugs (2014-02-04 09:44:30 +0200)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.15-rc1

for you to fetch changes up to d56030ac25d383218045c5d87e98e0494d6af3ad:

  UBI: block: Remove __initdata from ubiblock_param_ops (2014-03-21 19:37:03 +0200)

----------------------------------------------------------------
This pull request includes the 'ubiblock' driver which provides R/O block
access to UBI volumes. It is useful for those who want to use squashfs on top
of raw flash devices. UBI will provide bit-flip handling and wear-levelling in
this case (e.g., if there are other UBI volumes with R/W UBIFS too).

The driver is actually pretty small and it is part of the UBI kernel subsystem.
Delivered by Ezequiel Garcia, along with a piece of documentation on the MTD
web site and the user-space tool for creating and removing block devices.

----------------------------------------------------------------
Artem Bityutskiy (2):
      UBI: block: do not use term "attach"
      UBI: rename block device ioctls

Ezequiel Garcia (6):
      UBI: R/O block driver on top of UBI volumes
      UBI: block: Mark init-only symbol as __initdata
      UBI: block: Use 'u64' for the 64-bit dividend
      UBI: block: Add CONFIG_BLOCK dependency
      UBI: block: Use ENOSYS as return value when CONFIG_UBIBLOCK=n
      UBI: make UBI_IOCVOLCRBLK take a parameter for future usage

Richard Weinberger (1):
      UBI: block: Remove __initdata from ubiblock_param_ops

 drivers/mtd/ubi/Kconfig     |  16 +++++
 drivers/mtd/ubi/Makefile    |   1 +
 drivers/mtd/ubi/block.c     | 647 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/ubi/build.c     |  11 ++++
 drivers/mtd/ubi/cdev.c      |  20 ++++++
 drivers/mtd/ubi/ubi.h       |  20 ++++++
 include/uapi/mtd/ubi-user.h |  22 +++++++
 7 files changed, 737 insertions(+)
 create mode 100644 drivers/mtd/ubi/block.c


P.S. The pull request was generated with this command:
$ git request-pull "$(git merge-base linus/master origin/linux-next)"  git://git.infradead.org/linux-ubifs.git upstream-3.15-rc1

Thanks!

-- 
Best Regards,
Artem Bityutskiy

