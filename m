Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab3EMRrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 13:47:06 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63707 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3EMRrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 13:47:04 -0400
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
Subject: [PATCH v2 0/5] Zynq: revised CCF code
Date: Mon, 13 May 2013 10:46:34 -0700
Message-Id: <1368467199-8702-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I rebased this series on v3.10-rc1 eliminating all dependencies and incorporated
Greg's feedback.
I'll push this also to my github repository.
https://github.com/sorenb-xlnx/linux-xlnx/tree/zynq/clkc

v2:
 - dropped the 'sort #includes' patches

	Sören


Soren Brinkmann (5):
  tty: xuartps: Remove suspend/resume functions
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
 drivers/clocksource/cadence_ttc_timer.c            |  23 +-
 drivers/tty/serial/xilinx_uartps.c                 | 115 +++--
 include/linux/clk/zynq.h                           |   8 +-
 12 files changed, 974 insertions(+), 527 deletions(-)
 delete mode 100644 drivers/clk/clk-zynq.c
 create mode 100644 drivers/clk/zynq/Makefile
 create mode 100644 drivers/clk/zynq/clkc.c
 create mode 100644 drivers/clk/zynq/pll.c

-- 
1.8.2.3

