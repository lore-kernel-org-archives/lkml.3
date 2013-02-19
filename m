Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934134Ab3BSUht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 15:37:49 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:58784 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582Ab3BSUhr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 15:37:47 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
User-Agent: alot/0.3.3+
To: torvalds@linux-foundation.org
Message-ID: <20130219203742.27993.42947@quantum>
Subject: [GIT PULL] clk: changes for 3.9
Date: Tue, 19 Feb 2013 12:37:42 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://git.linaro.org/people/mturquette/linux.git tags/clk-for-linus

for you to fetch changes up to fde8bc59c03c0ad1fa4f655e0ed5cc1f76d11e8b:

  clk: sunxi: remove stale Makefile entry (2013-02-14 20:51:58 -0800)

----------------------------------------------------------------
The common clock framework changes for 3.9 are almost entirely fixes.
None are dire enough to be Cc'd to stable which may be interpreted to
mean that users of the framework are reaching stability.  Lots of new
adoption of this framework is via DeviceTree data and that comes through
the respective architecture and platform trees instead of through the
clk framework tree.  Two new features are improved debugfs output and an
improvement to how DT clocks are initialized by reusing a common method.

----------------------------------------------------------------
Arnd Bergmann (1):
      clk: sunxi: remove stale Makefile entry

Axel Lin (2):
      clk: max77686: Fix return value checking for devm_kzalloc
      clk: max77686: Remove unnecessary NULL checking for container_of()

Barry Song (1):
      clk: prima2: enable dt-binding clkdev mapping

Denis Efremov (1):
      clk: remove exported function from __init section

Fabio Estevam (1):
      clk: mxs: Index is always positive

Haojian Zhuang (1):
      clk: fixed-factor: round_rate should use do_div

James Hogan (1):
      clk-divider: fix macros

Laurent Pinchart (1):
      clk: max77686: Avoid double free at remove time

Mike Turquette (1):
      clk: beautify Makefile

Nestor Ovroy (1):
      clk: Deduplicate exit code in clk_set_rate

Niels de Vos (1):
      clk: export __clk_get_name for re-use in imx-ipu-v3 and others

Prashant Gaikwad (8):
      clk: human-readable debugfs clock tree summary
      clk: JSON debugfs clock tree summary
      clk: add common of_clk_init() function
      clk: sunxi: Use common of_clk_init() function
      clk: highbank: Use common of_clk_init() function
      clk: vt8500: Use common of_clk_init() function
      clk: zynq: Use common of_clk_init() function
      clk: vexpress: Use common of_clk_init() function

Russ Dill (1):
      clk: Don't mark shared helper functions as inline

Tony Prisk (4):
      clk: vt8500: Fix error in PLL calculations on non-exact match.
      clk: vt8500: Fix device clock divisor calculations
      clk: vt8500: Fix division-by-0 when requested rate=0
      clk: vt8500: Add support for WM8750/WM8850 PLL clocks

 .../devicetree/bindings/clock/prima2-clock.txt     |   73 +++++++
 arch/arm/boot/dts/prima2.dtsi                      |   31 ++-
 arch/arm/mach-highbank/core.h                      |    1 -
 arch/arm/mach-highbank/highbank.c                  |    3 +-
 drivers/clk/Makefile                               |   10 +-
 drivers/clk/clk-divider.c                          |    6 +-
 drivers/clk/clk-fixed-factor.c                     |    5 +-
 drivers/clk/clk-fixed-rate.c                       |    3 +-
 drivers/clk/clk-highbank.c                         |   18 +-
 drivers/clk/clk-max77686.c                         |   37 ++--
 drivers/clk/clk-prima2.c                           |  205 ++++++++------------
 drivers/clk/clk-sunxi.c                            |   30 ---
 drivers/clk/clk-vt8500.c                           |  143 ++++++++++++--
 drivers/clk/clk-zynq.c                             |   14 +-
 drivers/clk/clk.c                                  |  169 +++++++++++++++-
 drivers/clk/mxs/clk-imx23.c                        |    2 +-
 drivers/clk/mxs/clk-imx28.c                        |    2 +-
 drivers/clk/versatile/clk-vexpress-osc.c           |    1 +
 drivers/clk/versatile/clk-vexpress.c               |    8 +-
 drivers/clocksource/sunxi_timer.c                  |    4 +-
 include/asm-generic/vmlinux.lds.h                  |   10 +
 include/linux/clk-provider.h                       |    6 +
 include/linux/clk/sunxi.h                          |   22 ---
 23 files changed, 527 insertions(+), 276 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/prima2-clock.txt
 delete mode 100644 drivers/clk/clk-sunxi.c
 delete mode 100644 include/linux/clk/sunxi.h
