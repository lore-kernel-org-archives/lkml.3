Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab3EIUUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:20:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:13440 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab3EIUUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:20:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,642,1363158000"; 
   d="scan'208";a="334480019"
Date: Thu, 9 May 2013 16:20:15 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] NVMe driver updates
Message-ID: <20130509202015.GJ6057@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Lots of exciting new features in the NVM Express driver this time,
including support for emulating SCSI commands, discard support and the
ability to submit per-sector metadata with I/Os.  It's still mostly
bugfixes though!

The following changes since commit a12183c62717ac4579319189a00f5883a18dff08:

  Merge branch 'timers-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2013-03-25 18:03:34 -0700)

are available in the git repository at:


  git://git.infradead.org/users/willy/linux-nvme.git master

for you to fetch changes up to 94f370cab6e5ac514b658c6b2b3aa308cefc5c7a:

  NVMe: Use user defined admin ioctl timeout (2013-05-09 16:03:50 -0400)

----------------------------------------------------------------
Arjan van de Ven (2):
      NVMe: Use round_jiffies_relative() for the periodic, once-per-second timer
      NVMe: Set TASK_INTERRUPTIBLE before processing queues

Keith Busch (13):
      NVMe: Add discard support for capable devices
      NVMe: Add a character device for each nvme device
      NVMe: queue usage fixes in nvme-scsi
      NVMe: Add scsi unmap to SG_IO
      NVMe: Free admin queue on request_irq error
      NVMe: Fix error clean-up on nvme_alloc_queue
      NVMe: Check for NULL memory in nvme_dev_add
      NVMe: Remove dead code in nvme_dev_add
      NVMe: Split non-mergeable bio requests
      NVMe: Device specific stripe size handling
      NVMe: Meta-data support in NVME_IOCTL_SUBMIT_IO
      NVMe: Schedule timeout for sync commands
      NVMe: Use user defined admin ioctl timeout

Matthew Wilcox (7):
      NVMe: Abstract out sector to block number conversion
      NVMe: Don't fail initialisation unnecessarily
      NVMe: Fix I/O cancellation status on big-endian machines
      NVMe: Fix endian-related problems in user I/O submission path
      NVMe: Wait for device to acknowledge shutdown
      NVMe: Only clear the enable bit when disabling controller
      NVMe: Simplify Firmware Activate code slightly

Vishal Verma (5):
      NVMe: Rename nvme.c to nvme-core.c
      NVMe: Move structures & definitions to header file
      NVMe: Add definitions for format command
      NVMe: Add nvme-scsi.c
      NVMe: Fix sparse warnings in scsi emulation

 drivers/block/Makefile                |    1 +
 drivers/block/{nvme.c => nvme-core.c} |  594 +++++--
 drivers/block/nvme-scsi.c             | 3053 +++++++++++++++++++++++++++++++++
 include/linux/nvme.h                  |  158 +-
 4 files changed, 3640 insertions(+), 166 deletions(-)
 rename drivers/block/{nvme.c => nvme-core.c} (79%)
 create mode 100644 drivers/block/nvme-scsi.c


