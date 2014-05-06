Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbaEFN6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:58:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45864 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815AbaEFN6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:58:30 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <mark.rutland@arm.com>, <tglx@linutronix.de>, <galak@codeaurora.org>,
        <santosh.shilimkar@ti.com>, <nm@ti.com>, <bcousson@baylibre.com>,
        <robherring2@gmail.com>
CC: Sricharan R <r.sricharan@ti.com>
Subject: [PATCH V5 0/3] arm: dts: dra7: Updates for adding crossbar device
Date: Tue, 6 May 2014 19:26:16 +0530
Message-ID: <1399384579-25620-1-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some socs have a large number of interrupts requests to service
the needs of its many peripherals and subsystems. All of the interrupt
requests lines from the subsystems are not needed at the same
time, so they have to be muxed to the controllers appropriately.
In such places a interrupt controllers are preceded by an
IRQ CROSSBAR that provides flexibility in muxing the device interrupt
requests to the controller inputs.

The dts file update to support the crossbar device and convert
peripheral irq numbers to crossbar number are added here.

This is a rebase of V4 series on top of 3.15-rc4

This series depends on crossbar-driver-fixes sent below
http://marc.info/?l=linux-omap&m=139929963420299&w=2

Sricharan R (3):
  arm: dts: dra7: Add crossbar device binding
  arm: dts: dra7: Replace peripheral interrupt numbers with crossbar
    inputs
  arm: dts: dra7: Add routable-irqs property for gic node

 arch/arm/boot/dts/dra7.dtsi |  109 +++++++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 46 deletions(-)

-- 
1.7.9.5

