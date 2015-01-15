Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbbAOKex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:34:53 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42981 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbbAOKej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:34:39 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Mark Rutland <mark.rutland@arm.com>, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH v3 0/2] irqchip: Conexant CX92755 interrupts controller support
Date: Thu, 15 Jan 2015 12:33:58 +0200
Message-Id: <cover.1421317616.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This short series adds support for the Conexant CX92755 SoC interrupts 
controller. This SoC is part of the Conexant Digicolor series of SoCs.

v3:
   * Split from the "ARM: Conexant Digicolor CX92755 SoC support" series, as 
     these patches should go via the irqchip maintainers

   * Use syscon to access the system global UC_IRQ_CONTROL register

   * Add description of the "syscon" property to the device tree binding 
     documentation

   * Rename the interrupt controller node name to "interrupt-controller" 
     (Sergei Shtylyov)

v2:
   http://marc.info/?t=142074613900007&r=1&w=2

   * Migrate the irq driver to generic irq chip, simplifying the code somewhat
     (Arnd Bergmann)                                                          

v1:
   http://thread.gmane.org/gmane.linux.kernel/1855027

Baruch Siach (2):
  irqchip: devicetree: document Conexant Digicolor irq binding
  irqchip: Conexant CX92755 interrupts controller driver

 .../bindings/interrupt-controller/digicolor-ic.txt |  22 ++++
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-digicolor.c                    | 120 +++++++++++++++++++++
 3 files changed, 143 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/digicolor-ic.txt
 create mode 100644 drivers/irqchip/irq-digicolor.c

-- 
2.1.4

