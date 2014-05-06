Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbaEFFFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 01:05:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:28579 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbaEFFFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 01:05:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,994,1389772800"; 
   d="scan'208";a="428051585"
From: Liu ShuoX <shuox.liu@intel.com>
To: linux-kernel@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com, Liu ShuoX <shuox.liu@intel.com>
Subject: [PATCH v5 0/3] Add a method to expand tracers for pstore easily
Date: Tue,  6 May 2014 13:03:43 +0800
Message-Id: <1399352628-13308-1-git-send-email-shuox.liu@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Here are the v5 of this series. The intention is to add a framework to ramoops
and make expanding tracers for pstore easily. Comments are welcome.

Changelog v5:
  1) Document fix

Changelog v4:
  1) Fix record zone traversing lost when get old buffer.
  2) Add dump records to printk log buf function at runtime by code.
  3) Fix some minor issues.

Changelog v3: 
  1) Fix compiling errors when CONFIG_PSTORE_RAM=m.

Changelog v2: 
  1) Fix compiling errors when CONFIG_PSTORE_RAM is disabled.
  2) Add some protection in the code in case we disable CONFIG_PSTORE_RAM.

---
Liu ShuoX (2):
  pstore: add seq_ops for norm zone
  pstore: support current records dump in ramoops

Zhang Yanmin (1):
  pstore: restructure ramoops to support more trace

 Documentation/ramoops.txt                 |  71 +++++++++++-
 arch/x86/kernel/vmlinux.lds.S             |   9 ++
 drivers/platform/chrome/chromeos_pstore.c |   2 +-
 fs/pstore/inode.c                         | 126 +++++++++++++++++++--
 fs/pstore/internal.h                      |   4 +-
 fs/pstore/platform.c                      |  77 +++++++++++--
 fs/pstore/ram.c                           | 177 +++++++++++++++++++++++++-----
 fs/pstore/ram_core.c                      |  30 +++++
 include/linux/pstore.h                    |   4 +
 include/linux/pstore_ram.h                |  23 ++--
 include/linux/pstore_ramoops.h            |  85 ++++++++++++++
 11 files changed, 543 insertions(+), 65 deletions(-)
 create mode 100644 include/linux/pstore_ramoops.h

-- 
1.8.3.2

