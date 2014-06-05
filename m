Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174AbaFEHCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:02:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:3175 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbaFEHCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:02:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,979,1392192000"; 
   d="scan'208";a="551900326"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC Patch 0/3] Deal with CE4100 and NR_IRQS_LEGACY
Date: Thu,  5 Jun 2014 15:04:34 +0800
Message-Id: <1401951877-23032-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <5385BCD0.1080802@linutronix.de>
References: <5385BCD0.1080802@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the review comments, I have worked some patches to deal with
CE4100 and NR_IRQS_LEGACY. Instead of sending out a big patchset,
I just send these three patches for RFC to save the review efforts.
They will be merge into the big patchset once we reach some agreement.

Jiang Liu (3):
  ce4100, irq: make CE4100 depend on CONFIG_X86_IOAPIC
  ce4100, irq: do not set legacy_pic to null_legacy_pic
  x86, irq: count legacy IRQs by legacy_pic->nr_legacy_irqs instead of
    NR_IRQS_LEGACY

 arch/x86/Kconfig                  |    1 +
 arch/x86/include/asm/i8259.h      |    2 ++
 arch/x86/kernel/acpi/boot.c       |   13 +++++------
 arch/x86/kernel/apic/io_apic.c    |   43 +++++++++++++++++++++----------------
 arch/x86/kernel/devicetree.c      |   12 +++++------
 arch/x86/kernel/irqinit.c         |    6 +++---
 arch/x86/pci/xen.c                |    6 +++---
 arch/x86/platform/ce4100/ce4100.c |   11 ++--------
 8 files changed, 49 insertions(+), 45 deletions(-)

-- 
1.7.10.4

