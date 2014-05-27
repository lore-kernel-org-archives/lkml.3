Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaE0IWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:22:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:9853 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbaE0IV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:21:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,917,1392192000"; 
   d="scan'208";a="545380486"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC Patch V1 0/4] enhance IOAPIC core to support hotplug
Date: Tue, 27 May 2014 16:24:33 +0800
Message-Id: <1401179077-2020-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set enhances IOAPIC core to support IOAPIC hotplug on x86
platforms. It's based on another patch set "use irqdomain to dynamically
allocate IRQ for IOAPIC" at https://lkml.org/lkml/2014/5/27/86

You may pull from 
https://github.com/jiangliu/linux.git ioapic/hotplug

Once passed review, we will use Yinghai's patches to glue IOAPIC
driver and ACPI PCI root driver to handle hotplug events.

Jiang Liu (4):
  x86, irq: refine mp_register_ioapic() to prepare for IOAPIC hotplug
  x86, irq, ACPI: introduce a rwsem to protect IOAPIC operations from
    hotplug
  x86, irq, ACPI: implement interface to support ACPI based IOAPIC
    hot-addition
  x86, irq, ACPI: implement interface to support ACPI based IOAPIC
    hot-removal

 arch/x86/include/asm/io_apic.h |    5 +-
 arch/x86/kernel/acpi/boot.c    |   44 +++++++--
 arch/x86/kernel/apic/io_apic.c |  207 ++++++++++++++++++++++++++++++----------
 3 files changed, 196 insertions(+), 60 deletions(-)

-- 
1.7.10.4

