Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750888AbaKYQZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:25:22 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:57935 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaKYQZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:25:20 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, tglx@linutronix.de,
        jason@lakedaemon.net, devicetree@vger.kernel.org
Subject: [PATCH v2 0/8] irqchip: New driver for ST's SysCfg controlled IRQs
Date: Tue, 25 Nov 2014 16:24:57 +0000
Message-Id: <1416932705-16880-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver enables IRQs which are controlled using System Configuration
registers.  Without it Performance Monitoring, Core Sight Tracing and some
L2 Caches will fail to function.

v1 => v2:
 - Fixed up Jason's review comments

Lee Jones (8):
  dt: bindings: Supply shared ST IRQ defines
  irqchip: Supply new driver for STi based devices
  irqchip: irq-st: Add documentation for STi based syscfg IRQs
  ARM: STi: STiH416: Enable Cortex-A9 PMU support
  ARM: STi: STiH416: Enable PMU IRQs
  ARM: STi: STiH407: Enable Cortex-A9 PMU support
  ARM: STi: STiH407: Enable PMU IRQs
  ARM: STI: Ensure requested STi's SysCfg Controlled IRQs are enabled at
    boot

 .../interrupt-controller/st,sti-irq-syscfg.txt     |  35 ++++
 arch/arm/boot/dts/stih407.dtsi                     |  16 ++
 arch/arm/boot/dts/stih416.dtsi                     |  16 ++
 arch/arm/mach-sti/Kconfig                          |   1 +
 drivers/irqchip/Kconfig                            |   7 +
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-st.c                           | 208 +++++++++++++++++++++
 include/dt-bindings/interrupt-controller/irq-st.h  |  30 +++
 8 files changed, 314 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/st,sti-irq-syscfg.txt
 create mode 100644 drivers/irqchip/irq-st.c
 create mode 100644 include/dt-bindings/interrupt-controller/irq-st.h

-- 
1.9.1

