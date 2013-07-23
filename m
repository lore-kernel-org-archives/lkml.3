Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934218Ab3GWWZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:25:27 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51638 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933734Ab3GWWZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:25:26 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, albert.u.boot@aribaud.net,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 00/10] ARM: sunxi: Add support for the Allwinner A31 SoC
Date: Wed, 24 Jul 2013 00:25:02 +0200
Message-Id: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This patchset add support in Linux for the Allwinner A31 SoC. This SoC is the
current high-end Allwinner SoC, and is powered by 4 Cortex-A7.

SMP support is not there yet, but should come eventually, so does the clock
support.

As usual, since we don't have any storage device driver yet, it only boots from
an initramfs.

Finally, something worth mentionning is that with the current bootloader,
you'll encounter 2 ~6s hangs during the boot. This is because the SMP bit of
the Cortex-A7 doesn't appear to be set, leading to the CPU caches being
disabled. This can partially be addressed by selecting CONFIG_SMP, that will
remove the second hang, because the SMP bit is set after kernel decompression.

Obviously, this won't remove the first hang that happens during decompression,
but it's better than nothing. A proper fix would be to fix the bootloader.

Thanks,
Maxime

Emilio López (1):
  clk: sunxi: fix initialization of basic clocks

Maxime Ripard (9):
  irqchip: GIC: Add Cortex-A7 compatible string
  ARM: sunxi: Add the Allwinner A31 compatible to the machine definition
  ARM: sun6i: Add restart code for the A31
  ARM: sunxi: Add Allwinner A31 DTSI
  ARM: sun6i: Add WITS Colombus A31 evaluation kit support
  pinctrl: sunxi: Add Allwinner A31 pins set
  ARM: sunxi: dt: Add PIO controller to A31 DTSI
  ARM: sun6i: Add UART0 muxing options
  ARM: sun6i: colombus: Add uart0 muxing

 arch/arm/boot/dts/Makefile               |   3 +-
 arch/arm/boot/dts/sun6i-a31-colombus.dts |  32 ++
 arch/arm/boot/dts/sun6i-a31.dtsi         | 174 +++++++
 arch/arm/mach-sunxi/Kconfig              |   2 +
 arch/arm/mach-sunxi/sunxi.c              |  38 ++
 drivers/clk/sunxi/clk-sunxi.c            |  11 +-
 drivers/irqchip/irq-gic.c                |   1 +
 drivers/pinctrl/pinctrl-sunxi-pins.h     | 820 +++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-sunxi.c          |   1 +
 9 files changed, 1073 insertions(+), 9 deletions(-)
 create mode 100644 arch/arm/boot/dts/sun6i-a31-colombus.dts
 create mode 100644 arch/arm/boot/dts/sun6i-a31.dtsi

-- 
1.8.3.2

