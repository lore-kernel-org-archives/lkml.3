Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbbAVJtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:49:09 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:38958 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbbAVJtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:49:01 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, tglx@linutronix.de,
        jason@lakedaemon.net, devicetree@vger.kernel.org
Subject: [PATCH v2 RESEND 0/8] irqchip: New driver for ST's SysCfg controlled IRQs
Date: Thu, 22 Jan 2015 09:48:45 +0000
Message-Id: <1421920133-7914-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rebased and resending, as requested by Jason.

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
 arch/arm/boot/dts/stih407-family.dtsi              |  16 ++
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

