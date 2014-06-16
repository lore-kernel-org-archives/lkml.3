Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaFPLZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:25:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43220 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaFPLZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:25:46 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>, <joe@perches.com>
Subject: [PATCH V3 00/16] irqchip: crossbar: driver fixes
Date: Mon, 16 Jun 2014 16:53:00 +0530
Message-ID: <1402917796-31574-1-git-send-email-r.sricharan@ti.com>
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

[V3] Modified patch#3 to get irqs-skip properties from DT,
     merged path#8 for checkpatch warning to other relevant
     patches and fixed comments for other patches.

Nishanth Menon (14):
  irqchip: crossbar: dont use '0' to mark reserved interrupts
  irqchip: crossbar: check for premapped crossbar before allocating
  irqchip: crossbar: introduce ti,irqs-skip to skip
  irqchip: crossbar: initialise the crossbar with a safe value
  irqchip: crossbar: change allocation logic by reversing search for
    free irqs
  irqchip: crossbar: remove IS_ERR_VALUE check
  irqchip: crossbar: fix sparse and checkpatch warnings
  irqchip: crossbar: fix kerneldoc warning
  irqchip: crossbar: return proper error value
  irqchip: crossbar: change the goto naming
  irqchip: crossbar: introduce ti,max-crossbar-sources to identify
    valid crossbar mapping
  irqchip: crossbar: introduce centralized check for crossbar write
  documentation: dt: omap: crossbar: add description for interrupt
    consumer
  irqchip: crossbar: allow for quirky hardware with direct hardwiring
    of GIC

Sricharan R (2):
  irqchip: crossbar: set cb pointer to null in case of error
  irqchip: crossbar: add kerneldoc for crossbar_domain_unmap callback

 .../devicetree/bindings/arm/omap/crossbar.txt      |   34 ++++
 drivers/irqchip/irq-crossbar.c                     |  168 +++++++++++++++++---
 2 files changed, 177 insertions(+), 25 deletions(-)

-- 
1.7.9.5

