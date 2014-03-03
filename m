Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaCCEcA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 23:32:00 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:47328 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaCCEb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 23:31:58 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: alot/0.3.5
To: torvalds@linux-foundation.org
Message-ID: <20140303043153.12081.51995@quantum>
Subject: [GIT PULL] clk: fixes for 3.14
Date: Sun, 02 Mar 2014 20:31:53 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:

  Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)

are available in the git repository at:

  git://git.linaro.org/people/mike.turquette/linux.git tags/clk-fixes-for-linus

for you to fetch changes up to f63fcc90a379a269a07a1111f5b7ba28ebcb1eb4:

  clk:at91: Fix memory leak in of_at91_clk_master_setup() (2014-02-26 18:00:56 -0800)

----------------------------------------------------------------
Clock framework and driver fixes, all of which fix user-visible
regressions. There is a single framework fix that prevents dereferencing
a NULL pointer when calling clk_get. The range of fixes for clock driver
regressions spans memory leak fixes, touching the wrong registers that
cause things to explode, misconfigured clock rates that result in
non-responsive devices and even some boot failures. The most benign fix
is DT binding doc typo. It is a stable ABI exposed from the kernel that
was introduced in -rc1, so best to fix it now.

----------------------------------------------------------------
Andrew Bresticker (3):
      clk: tegra: fix sdmmc clks on Tegra1x4
      clk: tegra: cclk_lp has a pllx/2 divider
      clk: tegra: use max divider if divider overflows

David Ung (1):
      clk: tegra: PLLD2 fixes for hdmi

Gabe Black (1):
      clk: tegra: Fix PLLP rate table

Ivan Khoronzhuk (2):
      clk: keystone: gate: fix clk_init_data initialization
      ARM: keystone: dts: fix clkvcp3 control register address

Laurent Pinchart (5):
      clk: shmobile: rcar-gen2: Fix clock parent all non-PLL clocks
      clk: shmobile: rcar-gen2: Fix qspi divisor
      clk: shmobile: rcar-gen2: Fix clock parent for all non-PLL clocks
      clk: shmobile: rcar-gen2: Fix qspi divisor
      clk: shmobile: Fix typo in MSTP clock DT bindings

Linus Walleij (1):
      clk: nomadik: fix multiplatform problem

Mark Zhang (1):
      clk: tegra: fix host1x clock on Tegra124

Masanari Iida (1):
      clk:at91: Fix memory leak in of_at91_clk_master_setup()

Mike Turquette (4):
      Merge tag 'mvebu-clk-fixes-3.14' of git://git.infradead.org/linux-mvebu into clk-fixes
      Merge branch 'for_3.14-rcx/clk-fixes' of git://git.kernel.org/.../ssantosh/linux-keystone into clk-fixes
      Merge branch 'clk-tegra-more-fixes-3.14' of git://nv-tegra.nvidia.com/user/pdeschrijver/linux into clk-fixes
      Merge branch 'clocks/fixes/drivers' of git://linuxtv.org/pinchartl/fbdev into clk-fixes

Peter De Schrijver (3):
      clk: tegra: Add missing Tegra20 fuse clks
      clk: tegra: Fix vic03 mux index
      clk: tegra124: remove gr2d and gr3d clocks

Rhyland Klein (1):
      clk: tegra: Fix PLLD mnp table

Sebastian Hesselbarth (4):
      clk: mvebu: armada-370: maintain clock init order
      clk: mvebu: armada-xp: maintain clock init order
      clk: mvebu: dove: maintain clock init order
      clk: mvebu: kirkwood: maintain clock init order

Sylwester Nawrocki (1):
      clk: Correct handling of NULL clk in __clk_{get, put}

Thierry Reding (1):
      clk: tegra: Correct clock number for UARTE

 .../bindings/clock/renesas,cpg-mstp-clocks.txt     |  4 +-
 arch/arm/boot/dts/keystone-clocks.dtsi             |  2 +-
 drivers/clk/at91/clk-master.c                      |  2 +-
 drivers/clk/clk-nomadik.c                          |  3 ++
 drivers/clk/clk.c                                  | 13 +++---
 drivers/clk/keystone/gate.c                        |  1 +
 drivers/clk/mvebu/armada-370.c                     | 21 +++++-----
 drivers/clk/mvebu/armada-xp.c                      | 20 ++++-----
 drivers/clk/mvebu/dove.c                           | 19 ++++-----
 drivers/clk/mvebu/kirkwood.c                       | 34 ++++++++-------
 drivers/clk/shmobile/clk-rcar-gen2.c               | 12 +++++-
 drivers/clk/tegra/clk-divider.c                    |  2 +-
 drivers/clk/tegra/clk-id.h                         |  4 ++
 drivers/clk/tegra/clk-tegra-periph.c               | 10 +++--
 drivers/clk/tegra/clk-tegra-super-gen4.c           |  2 +-
 drivers/clk/tegra/clk-tegra114.c                   |  8 ++--
 drivers/clk/tegra/clk-tegra124.c                   | 48 ++++++++++++----------
 drivers/clk/tegra/clk-tegra20.c                    |  2 +
 include/dt-bindings/clock/tegra124-car.h           |  4 +-
 19 files changed, 116 insertions(+), 95 deletions(-)
