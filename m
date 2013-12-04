Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab3LDAom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 19:44:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:31153 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548Ab3LDAok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 19:44:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,821,1378882800"; 
   d="scan'208";a="418915860"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [UPDTE PATCH 0/3] ACPI: Cleanup direct ACPICA inclusions.
Date: Wed,  4 Dec 2013 08:41:52 +0800
Message-Id: <cover.1386116927.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1385094640.git.lv.zheng@intel.com>
References: <cover.1385094640.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Updated due to commit details attached.)

The patch in the linux-pm/linux-next queue is used as an experiment to
catch wrong ACPICA dependencies and inclusions:

 Commit: 4e8fb7987f7d0390a2e74622c7c1cbb6760c6516
 From: Lv Zheng <lv.zheng@intel.com>
 Date: Tue, 3 Dec 2013 08:49:16 +0800
 Subject: [PATCH] ACPI: Clean up inclusions of ACPI header files
 Replace direct inclusions of <acpi/acpi.h>, <acpi/acpi_bus.h> and
 <acpi/acpi_drivers.h>, which are incorrect, with <linux/acpi.h>
 inclusions and remove some inclusions of those files that aren't
 necessary.

Now we got build errors triggered for them. Such errors include:
1. "ACPI IGD OpRegion" support in i915 DRM driver.  It can be modified to
   be CONFIG_ACPI dependent.
2. "_CRS based MCFG checker" support, original configurability of this
   piece of code relies on link stage optimization.  This patchset
   corrects it by making the configurability to be dependent on compile
   stage references.
3. "iSCSI IBFT finder" support.  IBFT can only appear on ACPI platforms
   while IBFT locating mechanism doesn't rely on ACPI table constructions.
   It is currently not dependent on CONFIG_ACPI.  IMO, this behavior is
   This patchset corrects it by making it dependent on CONFIG_ACPI.  This
   patch need to be discussed, thus marked as RFC.
4. "SFI/ACPI wrapper" support.  This error is not fixed in this patchset.
   Its solution is still under discussion.  It need to be synchronized
   with SFI users.

Lv Zheng (3):
  ACPI/i915: Fix wrong <acpi/acpi.h> inclusion in i915 opregion module.
  ACPI/SFI: Fix wrong <acpi/acpi.h> inclusion in SFI/ACPI wrapper -
    acpi_disabled linkage.
  ACPI/IBFT: Fix wrong <acpi/acpi.h> inclusion in iSCSI boot firmware
    module.

 arch/x86/pci/mmconfig-shared.c    |    7 +++++++
 drivers/acpi/apei/apei-base.c     |    1 -
 drivers/acpi/apei/apei-internal.h |    1 -
 drivers/acpi/apei/ghes.c          |    1 -
 drivers/acpi/nvs.c                |    1 -
 drivers/acpi/osl.c                |    1 -
 drivers/firmware/Kconfig          |    2 +-
 drivers/gpu/drm/gma500/opregion.c |    1 -
 drivers/gpu/drm/i915/Makefile     |    3 +--
 drivers/gpu/drm/i915/i915_drv.h   |    3 ++-
 include/acpi/acpi_io.h            |   17 +++++++++++++++++
 include/linux/acpi.h              |    1 +
 include/linux/acpi_io.h           |   18 ------------------
 include/linux/iscsi_ibft.h        |    2 +-
 14 files changed, 30 insertions(+), 29 deletions(-)
 create mode 100644 include/acpi/acpi_io.h
 delete mode 100644 include/linux/acpi_io.h

-- 
1.7.10

