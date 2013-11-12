Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab3KLAMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:12:50 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43361 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab3KLAMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:12:42 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: alot/0.3.4
To: torvalds@linux-foundation.org
Message-ID: <20131112001026.19193.46963@quantum>
Subject: [GIT PULL] clk: changes for 3.13
Date: Mon, 11 Nov 2013 16:10:26 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 15c03dd4859ab16f9212238f29dd315654aa94f6:

  Linux 3.12-rc3 (2013-09-29 15:02:38 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mturquette/linux.git tags/clk-for-linus-3.13

for you to fetch changes up to 9ed9c07d9b7d42fc7042247c2be283731186464f:

  clk: new driver for efm32 SoC (2013-11-04 12:23:18 -0800)

----------------------------------------------------------------
The clock changes for 3.13 are an even mix of framework improvements &
bug fixes along with updates to existing clock drivers and the
additional of new clock drivers.

----------------------------------------------------------------
Felipe Pena (1):
      clk/zynq: Fix possible memory leak

Laxman Dewangan (1):
      clk: wm831x: get rid of the implementation of remove function

Loc Ho (3):
      clk: Add APM X-Gene SoC clock driver
      clk: arm64: Add DTS clock entry for APM X-Gene Storm SoC
      Documentation: Add documentation for APM X-Gene clock binding

Mike Turquette (1):
      clk: of: helper for determining number of parent clocks

Santosh Shilimkar (3):
      clk: keystone: add Keystone PLL clock driver
      clk: keystone: Add gate control clock driver
      clk: keystone: Build Keystone clock drivers

Tomasz Figa (3):
      clk: Add error handling to clk_fetch_parent_index()
      clk: Use kcalloc() to allocate arrays
      clk: Correct lookup logic in clk_fetch_parent_index()

Uwe Kleine-König (1):
      clk: new driver for efm32 SoC

 .../devicetree/bindings/clock/efm32-clock.txt      |  11 +
 .../devicetree/bindings/clock/keystone-gate.txt    |  29 ++
 .../devicetree/bindings/clock/keystone-pll.txt     |  84 ++++
 Documentation/devicetree/bindings/clock/xgene.txt  | 111 +++++
 arch/arm64/boot/dts/apm-storm.dtsi                 |  75 +++
 drivers/clk/Kconfig                                |  14 +
 drivers/clk/Makefile                               |   3 +
 drivers/clk/clk-efm32gg.c                          |  81 ++++
 drivers/clk/clk-wm831x.c                           |   6 -
 drivers/clk/clk-xgene.c                            | 521 +++++++++++++++++++++
 drivers/clk/clk.c                                  |  56 ++-
 drivers/clk/keystone/Makefile                      |   1 +
 drivers/clk/keystone/gate.c                        | 264 +++++++++++
 drivers/clk/keystone/pll.c                         | 305 ++++++++++++
 drivers/clk/zynq/clkc.c                            |  16 +-
 include/dt-bindings/clock/efm32-cmu.h              |  42 ++
 include/linux/clk-provider.h                       |   1 +
 17 files changed, 1591 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/efm32-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/keystone-gate.txt
 create mode 100644 Documentation/devicetree/bindings/clock/keystone-pll.txt
 create mode 100644 Documentation/devicetree/bindings/clock/xgene.txt
 create mode 100644 drivers/clk/clk-efm32gg.c
 create mode 100644 drivers/clk/clk-xgene.c
 create mode 100644 drivers/clk/keystone/Makefile
 create mode 100644 drivers/clk/keystone/gate.c
 create mode 100644 drivers/clk/keystone/pll.c
 create mode 100644 include/dt-bindings/clock/efm32-cmu.h
