Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035Ab3D3X6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 19:58:48 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:58162 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933959Ab3D3X6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 19:58:46 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Josh Cartwright <joshc@eso.teric.us>,
        Mike Turquette <mturquette@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 0/7] Zynq: revised CCF code
Date: Tue, 30 Apr 2013 16:57:57 -0700
Message-Id: <1367366284-28304-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a first shot a revised version of Zynq's CCF code.
This should model the whole clock tree and support clock gating for all
relevant clocks.

This follows Tegra and other ARM SOCs in containing the clock tree
within a single block, which in this case is simply named clock
controller.

The patch is based on the current Linus tree + armsoc/zynq/smp. A
branch for testing is available on github:
https://github.com/sorenb-xlnx/linux-xlnx/tree/zynq/clkc

ps: I hope this thread comes through fine. Corporate email is unwilling
to cooperate and I have to jump through some hoops. My testmail went
through fine though.

	Sören

Soren Brinkmann (7):
  tty: xuartps: Sort #includes alphabetically
  tty: xuartps: Remove suspend/resume functions
  clocksource/cadence_ttc: Sort #includes alphabetically
  clk: zynq: Factor out PLL driver
  clk: zynq: Add clock controller driver
  arm: zynq: Migrate platform to clock controller
  clk: zynq: Remove deprecated clock code

 .../devicetree/bindings/clock/zynq-7000.txt        | 127 +++--
 arch/arm/boot/dts/zynq-7000.dtsi                   |  71 +--
 arch/arm/boot/dts/zynq-zc702.dts                   |   4 -
 arch/arm/mach-zynq/slcr.c                          |   2 +-
 drivers/clk/Makefile                               |   2 +-
 drivers/clk/clk-zynq.c                             | 378 ---------------
 drivers/clk/zynq/Makefile                          |   3 +
 drivers/clk/zynq/clkc.c                            | 533 +++++++++++++++++++++
 drivers/clk/zynq/pll.c                             | 235 +++++++++
 drivers/clocksource/cadence_ttc_timer.c            |  27 +-
 drivers/tty/serial/xilinx_uartps.c                 | 127 ++---
 include/linux/clk/zynq.h                           |   8 +-
 12 files changed, 982 insertions(+), 535 deletions(-)
 delete mode 100644 drivers/clk/clk-zynq.c
 create mode 100644 drivers/clk/zynq/Makefile
 create mode 100644 drivers/clk/zynq/clkc.c
 create mode 100644 drivers/clk/zynq/pll.c

-- 
1.8.2.2

