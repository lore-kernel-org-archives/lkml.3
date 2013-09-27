Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab3I0Qty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:49:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:62593 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab3I0Qtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:49:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,994,1371106800"; 
   d="scan'208";a="300199924"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next 0/5] misc: mic: driver cleanups and a build fix.
Date: Fri, 27 Sep 2013 09:49:20 -0700
Message-Id: <cover.1380289102.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches address code review feedback received on the
patch series @ https://lkml.org/lkml/2013/9/5/561 ,from:
a) Greg Kroah-Hartman on sysfs and header file cleanups.
b) Joe Perches on issues found by "--strict" checkpatch.

It should also fix the build failures on certain non X86
architectures, reported in linux-next and 0-DAY builds.

Ashutosh Dixit (1):
  misc: mic: cleanups for "--strict" checkpatch.

Sudeep Dutt (4):
  misc: mic: host driver sysfs cleanups.
  misc: mic: header file cleanups.
  misc: mic: fix a warning in the IOCTL header file.
  misc: mic: depend on X86 for both host and card drivers.

 Documentation/mic/mpssd/mpssd.c                    | 65 +++++++--------
 Documentation/mic/mpssd/sysfs.c                    |  4 +-
 drivers/misc/mic/Kconfig                           |  4 +-
 drivers/misc/mic/card/mic_debugfs.c                |  2 +-
 drivers/misc/mic/card/mic_device.c                 |  3 +-
 drivers/misc/mic/card/mic_virtio.c                 | 19 +++--
 drivers/misc/mic/card/mic_x100.c                   |  6 +-
 .../misc/mic/common/{mic_device.h => mic_dev.h}    |  4 +-
 drivers/misc/mic/host/mic_boot.c                   |  2 +-
 drivers/misc/mic/host/mic_debugfs.c                | 92 ++++++++++-----------
 drivers/misc/mic/host/mic_fops.c                   |  8 +-
 drivers/misc/mic/host/mic_intr.c                   | 36 +++++----
 drivers/misc/mic/host/mic_main.c                   |  2 +-
 drivers/misc/mic/host/mic_smpt.c                   | 16 ++--
 drivers/misc/mic/host/mic_sysfs.c                  | 94 +++++++++-------------
 drivers/misc/mic/host/mic_virtio.c                 | 39 +++++----
 drivers/misc/mic/host/mic_x100.c                   | 35 ++++----
 include/uapi/linux/mic_ioctl.h                     |  2 +
 18 files changed, 206 insertions(+), 227 deletions(-)
 rename drivers/misc/mic/common/{mic_device.h => mic_dev.h} (95%)

-- 
1.8.2.1

