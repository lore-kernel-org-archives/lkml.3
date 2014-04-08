Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbaDHH4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 03:56:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:16189 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbaDHH4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:56:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,816,1389772800"; 
   d="scan'208";a="516488052"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 0/4] ACPICA: Fix some mis-ordered inclusions.
Date: Tue,  8 Apr 2014 15:55:37 +0800
Message-Id: <cover.1396930406.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1385110130.git.lv.zheng@intel.com>
References: <cover.1385110130.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some mis-ordered inclusions for Linux resident ACPICA.
There is no real issue in the Linux kernel, but this can help to cleanup
the inclusions so that:
1. Redundant environment definitions can be removed from <asm/acpi.h> and
   <acpi/platform/aclinux.h>
2. Using ACPICA defined types in <asm/acpi.h> is possible.

Lv Zheng (4):
  ACPICA: Add <acpi/platform/aclinuxxf.h> to remove mis-ordered
    inclusion of <acpi/actypes.h> from <acpi/platform/aclinux.h>.
  ACPICA: Add <asm/acenv.h> to remove mis-ordered inclusion of
    <asm/acpi.h> from <acpi/platform/aclinux.h>.
  ACPICA: Cleanup redudant definitions that already have defaults in
    <acpi/platform/acenv.h>.
  ACPICA: Remove deprecated _LINUX definitions for ACPICA.

 arch/ia64/include/asm/acenv.h     |   56 +++++++++++++++++
 arch/ia64/include/asm/acpi.h      |   50 ---------------
 arch/x86/include/asm/acenv.h      |   49 +++++++++++++++
 arch/x86/include/asm/acpi.h       |   45 --------------
 include/acpi/platform/aclinux.h   |  104 ++++---------------------------
 include/acpi/platform/aclinuxxf.h |  122 +++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h              |    4 --
 7 files changed, 239 insertions(+), 191 deletions(-)
 create mode 100644 arch/ia64/include/asm/acenv.h
 create mode 100644 arch/x86/include/asm/acenv.h
 create mode 100644 include/acpi/platform/aclinuxxf.h

-- 
1.7.10

