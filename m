Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaFMGvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:51:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:50763 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbaFMGvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:51:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,470,1400050800"; 
   d="scan'208";a="556759375"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 0/7] ACPI/EC: Critical bug fixes related to EC and event handling.
Date: Fri, 13 Jun 2014 14:51:06 +0800
Message-Id: <cover.1402641700.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes the following issues:
1. There are 2 race conditions in current EC driver.
2. Cleanup the first command byte write as one of the race condition fix
   requires additional cleanup for first command byte write. And this also
   helps us to do improvements in the BURST mode in the future.
3. ACPICA event not handled in the correct way.

This patchset also improves debugging message, register details can be
enabled by defining DEBUG. And bug fixes and reports are based on this
improvement.

All patches are tested to be valid fixes for the following bug:
https://bugzilla.kernel.org/show_bug.cgi?id=70891

The EC driver version is upgraded to 2.2.

The first 4 patches are useful stable materials. But the culprit of the bug
appears so long time ago that patches cannot be applied cleanly any more.
Thus 2 commit IDs are listed for the stable reviewers, one for the culprit,
the other for the kernel versions that can have these stable materials
cleanly applied.

Lv Zheng (7):
  ACPI/EC: Fix an issue that advance_transaction() processes stale
    hardware status.
  ACPI/EC: Add asynchronous command byte write support.
  ACPI/EC: Remove duplicated ec_wait_ibf0() waiter.
  ACPI/EC: Fix a race condition in ec_transaction_completed().
  ACPI/EC: Update revision due to full asynchrnous command support.
  ACPICA: Events: Fix edge-triggered GPE by disabling before
    acknowledging it.
  ACPI/EC: Add detailed fields debugging support of EC_SC(R).

 drivers/acpi/acpica/evgpe.c |   32 +++++----
 drivers/acpi/ec.c           |  161 ++++++++++++++++++++++---------------------
 2 files changed, 100 insertions(+), 93 deletions(-)

-- 
1.7.10

