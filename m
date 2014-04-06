Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaDFFiN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 01:38:13 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19726 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaDFFiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 01:38:05 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [RFC PATCH 0/5] irq: Kill irq_reserve_irq
Date: Sat,  5 Apr 2014 22:39:21 -0700
Message-Id: <1396762766-4942-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

During reviewing ioapic hotplug patchset, Thomas pointed out that
should not extend irq_reserve_irq for that purpose as that is not
actually reserve.

Neet to clean up old irq_reserve_irq before introduce reserve/alloc_reserved
method for ioapic hotplug.

So here patchset that kill irq_reserve_irq that actually set allocated_irqs.

First remove irq_reserve_irqs for x86, and remove irq_reserve_irq
for sh.
Then in set_irq_chip use irq_alloc_desc instead of irq_reserve_irq.
At last will mark bits in allocated_irqs early for init irqs in !SPARSE_IRQ

Thanks

Yinghai

Yinghai Lu (5):
  x86, irq: Remove not needed irq_reserve_irqs calling
  sh: Remove irq_reserve_irq calling
  irq: Use irq_alloc_desc_at instead of irq_reserve_irq
  s390: Mark bits in allocated_irqs in general code
  genirq: Kill irq_reserve_irq/irq_reserve_irqs

 arch/s390/kernel/irq.c         |  6 +++++-
 arch/x86/kernel/apic/io_apic.c |  3 ---
 drivers/sh/intc/core.c         |  5 +----
 include/linux/irq.h            |  7 +------
 kernel/irq/chip.c              | 14 +++++++-------
 kernel/irq/irqdesc.c           | 35 ++++++++++-------------------------
 6 files changed, 24 insertions(+), 46 deletions(-)

-- 
1.8.4.5

