Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbaDWGxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:53:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:27710 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbaDWGxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:53:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,910,1389772800"; 
   d="scan'208";a="497869546"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 0/5] ACPICA: Fix some mis-ordered inclusions.
Date: Wed, 23 Apr 2014 14:53:33 +0800
Message-Id: <cover.1398232408.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1396930406.git.lv.zheng@intel.com>
References: <cover.1396930406.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some mis-ordered inclusions for Linux resident ACPICA.

There is no real issue in the Linux kernel, but this can help to cleanup
the code so that (benefits):
1. Redundant environment definitions can be removed from <asm/acpi.h> and
   <acpi/platform/aclinux.h>.
2. Lift a burden off the ACPICA release automation - copying default ACPICA
   environment setting to all <asm/acpi.h> file each time a new environment
   is introduced just in order to avoid build errors.
3. The wrong <acpi/actypes.h> inclusion can be removed from
   <acpi/platform/aclinux.h>.
4. Using ACPICA defined types in <asm/acpi.h> is possible.
5. Using "static inline" to define ACPICA OSL functions is still possible
   and won't cause build errors any longer.
6. All non back ported prototypes are collected in a single file.

The patch set has passed the following build/boot tests.
Build tests are performed as follows:
1. i386 + default + COFNIG_ACPI=y
2. i386 + default + COFNIG_ACPI=n
3. x86_64 + default + COFNIG_ACPI=y
4. x86_64 + default + COFNIG_ACPI=n
Boot tests are performed as follows:
1. i386 + default + COFNIG_ACPI=y
2. x86_64 + default + COFNIG_ACPI=y
Where:
1. i386: machine named as "Dell Inspiron Mini 1010"
2. x86_64: machine named as "HP Compaq 8200 Elite SFF PC"
3. default: kernel configuration with following items enabled:
   All hardware drivers related to the machines of i386/x86_64
   All drivers/acpi configurations
   All platform drivers
   All ACPI drivers
   4 DRM drivers that implement ACPI opregion
   All buses with ACPI bindings
   All cpufreq configurations
   All xen configurations
   All ACPI tabln drivers

Lv Zheng (5):
  ACPICA: OSL: Add direct inclusion of extra header.
  ACPICA: Add <acpi/acpi_opt.h> to remove mis-ordered inclusion of
    <acpi/actypes.h> from <acpi/platform/aclinux.h>.
  ACPICA: Add <asm/acenv.h> to remove mis-ordered inclusion of
    <asm/acpi.h> from <acpi/platform/aclinux.h>.
  ACPICA: Cleanup redudant definitions that already have defaults in
    <acpi/platform/acenv.h>.
  ACPICA: Remove deprecated _LINUX definitions for ACPICA.

 arch/ia64/include/asm/acenv.h   |   56 +++++++++++++++++++++
 arch/ia64/include/asm/acpi.h    |   50 -------------------
 arch/x86/include/asm/acenv.h    |   49 ++++++++++++++++++
 arch/x86/include/asm/acpi.h     |   45 -----------------
 include/acpi/acpi.h             |    4 +-
 include/acpi/acpi_opt.h         |   90 +++++++++++++++++++++++++++++++++
 include/acpi/platform/aclinux.h |  104 +++++----------------------------------
 include/linux/acpi.h            |    4 --
 8 files changed, 209 insertions(+), 193 deletions(-)
 create mode 100644 arch/ia64/include/asm/acenv.h
 create mode 100644 arch/x86/include/asm/acenv.h
 create mode 100644 include/acpi/acpi_opt.h

-- 
1.7.10

