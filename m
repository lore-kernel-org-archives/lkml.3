Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbaLJGon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 01:44:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:39239 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbaLJGom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 01:44:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,550,1413270000"; 
   d="scan'208";a="645282944"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC Patch V1 0/9] Simplify initialization of IR on x86 platforms
Date: Wed, 10 Dec 2014 14:47:42 +0800
Message-Id: <1418194071-13785-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a following-on patch set to simplify initialization of interrupt
remapping subsystem on x86 platforms. Please refer to
	https://lkml.org/lkml/2014/12/5/114
for the whole story.

With this patch set applied, there are three steps to initialize IR on x86:
1) "Detect" stage to detect ACPI table for IR at early booting stage
2) "Prepare" stage to allocate resources for IR
3) "Enable" stage to program hardware device to enable IR

Patch 1-3 clean up the code to initialize IR and X2APIC on x86
Patch 4-5 kill the irq_remapping_supported() and related code
Patch 6-9 clean up IR code further.

It's based on tip/x86/apic branch and could be pulled from:
https://github.com/jiangliu/linux.git irq_remapping_v1

It has been tested on Intel platform with X2APIC enabled and disabled.
It also passes Fengguang's 0day test suite. Tests on AMD platform are
welcomed!

Jiang Liu (9):
  x86, apic: Kill useless variable x2apic_enabled in function
    enable_IR_x2apic()
  x86, apic: Correctly detect X2APIC status in function enable_IR()
  x86, apic: Refine enable_IR_x2apic() and related functions
  iommu/vt-d: Prepare for killing function irq_remapping_supported()
  iommu/irq_remapping: Kill function irq_remapping_supported() and
    related code
  iommu/irq_remapping: Refine function irq_remapping_prepare() for
    maintenance
  iommu/irq_remapping: Change variable disable_irq_remap to be static
  iommu/irq_remapping: Normailize the way to detect whether IR is
    enabled
  iommu/irq_remapping: Kill unused function irq_remapping_print_chip()

 arch/x86/include/asm/irq_remapping.h |    4 --
 arch/x86/kernel/apic/apic.c          |   89 +++++++++++++++-------------------
 drivers/iommu/amd_iommu.c            |    1 -
 drivers/iommu/amd_iommu_init.c       |   10 +---
 drivers/iommu/amd_iommu_proto.h      |    1 -
 drivers/iommu/intel_irq_remapping.c  |   59 ++++++++--------------
 drivers/iommu/irq_remapping.c        |   74 +++++++++-------------------
 drivers/iommu/irq_remapping.h        |    5 --
 8 files changed, 84 insertions(+), 159 deletions(-)

-- 
1.7.10.4

