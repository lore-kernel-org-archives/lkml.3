Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaKCIbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:31:19 -0500
Received: from down.free-electrons.com ([37.187.137.238]:51381 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751081AbaKCIbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:31:09 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 0/5] irqchip: atmel-aic: add RTT irq fixup
Date: Mon,  3 Nov 2014 09:30:59 +0100
Message-Id: <1415003464-29239-1-git-send-email-boris.brezillon@free-electrons.com>
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

Best Regards,

Boris

Changes since v1:
- rebased on linux-3.18-rc2

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

