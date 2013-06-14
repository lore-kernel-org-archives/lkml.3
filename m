Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab3FNQlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:41:01 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46935 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3FNQk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:40:59 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 0/7] genirq: add irq_get_trigger_type() to get IRQ flags
Date: Fri, 14 Jun 2013 18:40:42 +0200
Message-Id: <1371228049-27080-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers that want to get the trigger edge/level type flags for a
given interrupt have to first call irq_get_irq_data(irq) to get
the struct irq_data and then irqd_get_trigger_type(irq_data) to
obtain the IRQ flags.

This is not only error prone but also unnecessary exposes the
struct irq_data to callers. This patch-set adds a new function
irq_get_trigger_type() to obtain the edge/level flags for an IRQ
and updates the places where irq_get_irq_data(irq) was called
just to obtain the flags from the struct irq_data.

The patch-set is composed of the following patches:

[PATCH 1/7] genirq: add irq_get_trigger_type() to get IRQ flags
[PATCH 2/7] gpio: mvebu: use irq_get_trigger_type() to get IRQ flags
[PATCH 3/7] mfd: twl4030-irq: use irq_get_trigger_type() to get IRQ flags
[PATCH 4/7] mfd: stmpe: use irq_get_trigger_type() to get IRQ flags
[PATCH 5/7] arm: orion: use irq_get_trigger_type() to get IRQ flags
[PATCH 6/7] MIPS: octeon: use irq_get_trigger_type() to get IRQ flags
[PATCH 7/7] irqdomain: use irq_get_trigger_type() to get IRQ flags

 arch/arm/plat-orion/gpio.c           |    2 +-
 arch/mips/cavium-octeon/octeon-irq.c |    2 +-
 drivers/gpio/gpio-mvebu.c            |    2 +-
 drivers/mfd/stmpe.c                  |    3 +--
 drivers/mfd/twl4030-irq.c            |    5 +----
 include/linux/irq.h                  |    6 ++++++
 kernel/irq/irqdomain.c               |    2 +-
 7 files changed, 12 insertions(+), 10 deletions(-)

Best regards,
Javier
