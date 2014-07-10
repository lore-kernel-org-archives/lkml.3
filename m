Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaGJSZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:25:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58016 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751170AbaGJSZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:25:45 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 0/3] irqchip: atmel-aic: Add irq RTC fixups
Date: Thu, 10 Jul 2014 20:25:38 +0200
Message-Id: <1405016741-2407-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series introduce the notion of irq fixups for atmel SoCs.

In most at91 SoCs the first interrupt line is shared by several IPs, and
some of these HW blocks might be in an unknown state when booting the
Linux kernel.
Hence these IPs might generate spurious interrupts if they've not masked
their irqs and the shared irq line is requested by another peripheral.

These fixups were previously done in arch/arm/mach-at91/sysirq_mask.c
but as we're trying to use standard implementation (IRQCHIP_DECLARE and
automatic call of irqchip_init within arch/arm/kernel/irq.c) we need to
do those fixups in the irqchip driver.

This series only fix RTC irqs, but other HW blocks (RTT, PMC, ...) will
be added later on.

This series depends on this one [1].

Best Regards,

Boris

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/271413.html

Boris BREZILLON (3):
  irqchip: atmel-aic: Add irq fixup infrastructure
  irqchip: atmel-aic: Implement RTC irq fixup
  irqchip: atmel-aic: Define irq fixups for atmel SoCs

 drivers/irqchip/irq-atmel-aic-common.c | 47 ++++++++++++++++++++++++++++++++++
 drivers/irqchip/irq-atmel-aic-common.h |  4 +++
 drivers/irqchip/irq-atmel-aic.c        | 15 +++++++++++
 drivers/irqchip/irq-atmel-aic5.c       | 12 +++++++++
 4 files changed, 78 insertions(+)

-- 
1.8.3.2

