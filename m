Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423AbaFLLz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:55:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58190 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080AbaFLLz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:55:56 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>
Subject: [PATCH V2 00/19] irqchip: crossbar: driver fixes
Date: Thu, 12 Jun 2014 17:23:08 +0530
Message-ID: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series does some cleanups, fixes for handling two interrupts
getting mapped twice to same crossbar and provides support for
hardwired IRQ and crossbar definitions.

On certain platforms such as DRA7, SPIs 0, 1, 2, 3, 5, 6, 10,
131, 132, 133 are direct wired to hardware blocks bypassing
crossbar. This quirky implementation is *NOT* supposed to be the
expectation of crossbar hardware usage. This series adds support
to represent such hard-wired irqs through DT and avoid generic
allocation/programming of crossbar in the driver.

This way of supporting hard-wired irqs was a result of
the below discussions.
http://www.spinics.net/lists/arm-kernel/msg329946.html

Based on 3.15 mainline.

All the patches are available here
 git@github.com:Sricharanti/sricharan.git crossbar_updates

The fixes series[1] earlier posted is merged in to this.
[1] http://www.spinics.net/lists/arm-kernel/msg328273.html

[V2] Merged the above series and rebased on 3.15 mainline

Nishanth Menon (16):
  irqchip: crossbar: dont use '0' to mark reserved interrupts
  irqchip: crossbar: check for premapped crossbar before allocating
  irqchip: crossbar: Skip some irqs from getting mapped to crossbar
  irqchip: crossbar: Initialise the crossbar with a safe value
  irqchip: crossbar: Change allocation logic by reversing search for
    free irqs
  irqchip: crossbar: remove IS_ERR_VALUE check
  irqchip: crossbar: fix sparse warnings
  irqchip: crossbar: fix checkpatch warning
  irqchip: crossbar: fix kerneldoc warning
  irqchip: crossbar: fix memory leak incase of invalid entry
  irqchip: crossbar: return proper error value
  irqchip: crossbar: change the goto naming
  irqchip: crossbar: introduce ti,max-crossbar-sources to identify
    valid crossbar mapping
  irqchip: crossbar: introduce centralized check for crossbar write
  Documentation: dt: OMAP: crossbar: add description for interrupt
    consumer
  irqchip: crossbar allow for quirky hardware with direct hardwiring of
    GIC

Rajendra Nayak (1):
  irqchip: crossbar: DRA7: Fix unused crossbar list

Sricharan R (2):
  irqchip: crossbar: set cb pointer to null in case of error
  irqchip: crossbar: Add kerneldoc for crossbar_domain_unmap callback

 .../devicetree/bindings/arm/omap/crossbar.txt      |   27 +++
 drivers/irqchip/irq-crossbar.c                     |  193 +++++++++++++++++---
 2 files changed, 191 insertions(+), 29 deletions(-)

-- 
1.7.9.5
