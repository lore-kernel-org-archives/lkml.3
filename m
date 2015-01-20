Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbbATCSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:18:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:18726 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510AbbATCSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:18:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,431,1418112000"; 
   d="scan'208";a="514609157"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [Bugfix 0/3] Xen IRQ related hotfixes for v3.19
Date: Tue, 20 Jan 2015 10:21:04 +0800
Message-Id: <1421720467-7709-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
	This patch set includes three hotfixes related Xen IRQ for v3.19.
Sorry for the long delay to get these two regressions fixed, it really
cost me some time to read and understand Xen IRQ code.

Patch 1 fixes the failure to register ACPI SCI interrupt on Xen
domain0 by reworking acpi_gsi_to_irq(). I will backport it to v3.18
too once it reaches the mainstream kernel.

Patch 2 fixes the regression in Xen PCI device passthrough(pciback).
It's a temporary solution, I will send the formal fix for v3.20 and
it has passed tests too.

Patch 3 fixes an issue found when reading code. There's no real bug
reports related to this issue yet.

Great thanks to Konrad and Sander for testing fixes for these regressions.

Regards,
Gerry

Jiang Liu (3):
  xen/pci: Kill function xen_setup_acpi_sci()
  xen/irq, ACPI: Fix regression in xen PCI passthrough caused by
    cffe0a2b5a34
  xen/irq: Override ACPI IRQ management callback __acpi_unregister_gsi

 arch/x86/include/asm/acpi.h |    1 +
 arch/x86/kernel/acpi/boot.c |   26 +++++++++++------------
 arch/x86/pci/xen.c          |   49 ++-----------------------------------------
 drivers/acpi/pci_irq.c      |    1 -
 4 files changed, 16 insertions(+), 61 deletions(-)

-- 
1.7.10.4

