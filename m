Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbaAWWiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 17:38:19 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:46840 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaAWWiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 17:38:15 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] irqchip: orion: bridge irq fixes for v3.14-rc1
Date: Thu, 23 Jan 2014 23:38:03 +0100
Message-Id: <1390516686-2224-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a small patch set to fix some shortcomings how Orion bridge
irqs are handled. The patches are based on v3.13-rc8 and should go
into v3.14. They can possibly also marked for -stable down to v3.10.

This patches are the result of a discussion about a stale watchdog irq,
that can accidentially trigger the watchdog's irq handler and cause a
reset [1].

The first patch will add a write to clear already pending interrupts
on init. The second patch replaces handle_level_irq with handle_edge_irq
which is more appropriate for bridge irqs which are edge-triggered.
The last patch finally, fixes stale interrupts by installing an
.irq_enable callback, that will clear a possible pending interrupt
before unmasking it.

[1] http://www.spinics.net/lists/arm-kernel/msg302106.html

Sebastian Hesselbarth (3):
  irqchip: orion: clear bridge cause register on init
  irqchip: orion: use handle_edge_irq on bridge irqs
  irqchip: orion: clear stale interrupts in irq_enable

 drivers/irqchip/irq-orion.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

---
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.8.5.2

