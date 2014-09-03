Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbaICJH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:07:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44132 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755996AbaICJHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:07:55 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 0/5] irqchip: atmel-aic: add RTT irq fixup
Date: Wed,  3 Sep 2014 11:07:46 +0200
Message-Id: <1409735271-15353-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series add a new fixup function for the RTT (Real Time Timer)
block and make use of it on SoCs integrating at least one RTT to prevent
spurious interrupts on the first interrupt line.

This fixup function was previously implemented in
arch/arm/mach-at91/sysirq_mask.c, but is now moved to the AIC driver so
that we can remove SoC specific hooks in arch/arm/mach-at91/ when booting
a DT kernel.

This series also reworks the naming convention of the SoC specific fixup
functions and add an entry for the at91rm9200.

The series depends on the acceptation of the RTT DT bindings proposed here
[1].

Best Regards,

Boris

[1]https://lkml.org/lkml/2014/9/3/145

Boris BREZILLON (5):
  irqchip: atmel-aic: add irq fixup for RTT block
  irqchip: atmel-aic: add irq fixups for at91sam926x SoCs
  irqchip: atmel-aic: add specific irq fixup function for sam9g45 and
    sam9rl
  irqchip: atmel-aic: rename at91sam9_aic_irq_fixup for naming
    consistency
  irqchip: atmel-aic: add missing entry for rm9200 irq fixups

 drivers/irqchip/irq-atmel-aic-common.c | 26 ++++++++++++++++++++++++++
 drivers/irqchip/irq-atmel-aic-common.h |  2 ++
 drivers/irqchip/irq-atmel-aic.c        | 26 +++++++++++++++++++++-----
 3 files changed, 49 insertions(+), 5 deletions(-)

-- 
1.9.1

