Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaFZHNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 03:13:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48737 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbaFZHNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 03:13:14 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>, <joe@perches.com>
Subject: [PATCH V4 00/16] irqchip: crossbar: Driver fixes
Date: Thu, 26 Jun 2014 12:40:18 +0530
Message-ID: <1403766634-18543-1-git-send-email-r.sricharan@ti.com>
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

Based on 3.16 rc2 mainline.

All the patches are available here
 git@github.com:Sricharanti/sricharan.git crossbar_updates

The fixes series[1] earlier posted is merged in to this.
[1] http://www.spinics.net/lists/arm-kernel/msg328273.html

[V2] Merged the above series and rebased on 3.15 mainline

[V3] Modified patch#3 to get irqs-skip properties from DT,
     merged path#8 for checkpatch warning to other relevant
     patches and fixed comments for other patches.

[V4] Based on 3.16rc2 and fixed Jason's <jason@lakedaemon.net> comments.

Nishanth Menon (14):
  irqchip: crossbar: Dont use '0' to mark reserved interrupts
  irqchip: crossbar: Check for premapped crossbar before allocating
  irqchip: crossbar: Introduce ti,irqs-skip to skip irqs that bypass
    crossbar
  irqchip: crossbar: Initialise the crossbar with a safe value
  irqchip: crossbar: Change allocation logic by reversing search for
    free irqs
  irqchip: crossbar: Remove IS_ERR_VALUE check
  irqchip: crossbar: Fix sparse and checkpatch warnings
  irqchip: crossbar: Fix kerneldoc warning
  irqchip: crossbar: Return proper error value
  irqchip: crossbar: Change the goto naming
  irqchip: crossbar: Introduce ti,max-crossbar-sources to identify
    valid crossbar mapping
  irqchip: crossbar: Introduce centralized check for crossbar write
  documentation: dt: omap: crossbar: Add description for interrupt
    consumer
  irqchip: crossbar: Allow for quirky hardware with direct hardwiring
    of GIC

Sricharan R (2):
  irqchip: crossbar: Set cb pointer to null in case of error
  irqchip: crossbar: Add kerneldoc for crossbar_domain_unmap callback

 .../devicetree/bindings/arm/omap/crossbar.txt      |   36 +++++
 drivers/irqchip/irq-crossbar.c                     |  168 +++++++++++++++++---
 2 files changed, 179 insertions(+), 25 deletions(-)

-- 
1.7.9.5

