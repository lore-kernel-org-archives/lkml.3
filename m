Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbaDDD46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:56:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:29006 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbaDDD4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:56:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,792,1389772800"; 
   d="scan'208";a="514581730"
From: Liu ShuoX <shuox.liu@intel.com>
To: linux-kernel@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com, keescook@chromium.org, tony.luck@intel.com,
        fengguang.wu@intel.com, Liu ShuoX <shuox.liu@intel.com>
Subject: [PATCH v3 0/3] Add a method to expand tracers for pstore easily
Date: Fri,  4 Apr 2014 11:55:56 +0800
Message-Id: <1396583760-4772-1-git-send-email-shuox.liu@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Here are the v3 of this series.
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

 Documentation/ramoops.txt                 |  70 +++++++++++++++-
 arch/x86/kernel/vmlinux.lds.S             |   9 ++
 drivers/platform/chrome/chromeos_pstore.c |   2 +-
 fs/pstore/inode.c                         | 126 ++++++++++++++++++++++++++--
 fs/pstore/internal.h                      |   4 +-
 fs/pstore/platform.c                      |  77 +++++++++++++++--
 fs/pstore/ram.c                           | 132 +++++++++++++++++++++++-------
 fs/pstore/ram_core.c                      |  30 +++++++
 include/linux/pstore.h                    |   4 +
 include/linux/pstore_ram.h                |  23 ++----
 include/linux/pstore_ramoops.h            |  78 ++++++++++++++++++
 11 files changed, 490 insertions(+), 65 deletions(-)
 create mode 100644 include/linux/pstore_ramoops.h

-- 
1.8.3.2

