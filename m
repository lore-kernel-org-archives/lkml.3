Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761164AbaGPI6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:58:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:27324 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759732AbaGPI6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:58:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,670,1400050800"; 
   d="scan'208";a="457583299"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH v3 0/7] ACPICA: Enable ACPICA prototypes for CONFIG_ACPI=n builds.
Date: Wed, 16 Jul 2014 16:57:38 +0800
Message-Id: <cover.1405500886.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1387336613.git.lv.zheng@intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3:
 PATCH 3/7 updated to remove new Kconfig item.

This is the last series for ACPICA header inclusion cleanups.
The whole story can be found below:
  1. Unsafe inclusions:
     origin: https://lkml.org/lkml/2013/11/22/510
     merged: https://lkml.org/lkml/2013/12/6/79
  2. Header orders:
     origin: https://lkml.org/lkml/2014/4/8/57
     merged: https://lkml.org/lkml/2014/5/12/111
  3. Header stubs:
     origin: https://lkml.org/lkml/2014/12/18/149
     merged: https://lkml.org/lkml/2014/4/29/716

This patchset contains patches that are parts of the last series sent
before, so it is marked as v2 belonging to the same thread as this series:
  https://lkml.org/lkml/2014/12/18/149

Now we have cleaned up all mis-ordered ACPICA headers and implemented stubs
for ACPICA prototypes (functions, global variables, macros), we finally can
enable ACPICA headers for CONFIG_ACPI=n builds so that all ACPICA defined
types are visible to all kernel source files.

After exposing ACPICA types to all kernel sources, we can also sort the
final wrong <acpi/acpi.h> inclusion out of <linux/sfi_acpi.h>.

This patchset also includes a rule enforcement patch to avoid future
inclusion mistakes.

The patch set has passed a build/boot test on the following machines:
Dell Inspiron Mini 1010 (i386)
HP Compaq 8200 Elite SFF PC (x86-64)
With the following kernel configuration items enabled:
  All drivers/acpi configurations
  All platform drivers
  All ACPI drivers
  4 DRM drivers that implement ACPI opregion
  All buses with ACPI bindings
  All cpufreq configurations
  All xen configurations
  All ACPI table drivers
They are tested twice with CONFIG_ACPI enabled/disabled.

Also allyes/allno/allmod tests are done for ARCH=i386 and ARCH=x86_64.

A boot test has been done to ARCH=x86_64 default configuration and it is
confirmed that the ACPI devices are successfully created under
/sys/bus/acpi/devices when CONFIG_ACPI is enabled.

Lv Zheng (7):
  ACPICA: Linux: Add stub support for Linux specific variables and
    functions.
  ACPICA: Linux: Add stub implementation of ACPICA 64-bit mathematics.
  ACPICA: Linux: Add support to exclude <asm/acenv.h> inclusion.
  ACPICA: Linux: Allow ACPICA inclusion for CONFIG_ACPI=n builds.
  ACPI/SFI: Fix wrong <acpi/acpi.h> inclusion in SFI/ACPI wrapper -
    table definitions.
  ACPI: Add support to force header inclusion rules for <acpi/acpi.h>.
  ACPI: Cleanup useless ACPI inclusion.

 arch/ia64/include/asm/acenv.h     |    4 ----
 arch/x86/include/asm/acenv.h      |    4 ----
 drivers/acpi/acpica/Makefile      |    2 +-
 drivers/acpi/bus.c                |    3 ---
 include/acpi/acpixf.h             |   28 +++++++++++++++++-----------
 include/acpi/platform/aclinux.h   |   12 ++++++++++++
 include/acpi/platform/aclinuxex.h |   22 ++++++++++++++++++++++
 include/linux/acpi.h              |    6 +++---
 include/linux/sfi_acpi.h          |    3 ---
 sound/soc/intel/sst-haswell-dsp.c |    3 ---
 10 files changed, 55 insertions(+), 32 deletions(-)

-- 
1.7.10

