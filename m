Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaGaPiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:38:52 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35148 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaGaPiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:38:50 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
X-Google-Original-From: Tomasz Figa <t.figa@samsung.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: [GIT PULL] Samsung clock changes for v3.17
Date: Thu, 31 Jul 2014 17:37:35 +0200
Message-Id: <1406821055-7290-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 2.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <tomasz.figa@gmail.com>

Hi Mike,

The following changes since commit bdfcdf18c380a3c376b42709a89eb2cc52e95ae0:

  Merge branch 'v3.16-samsung-clk-fixes-1' into samsung-clk-next (2014-06-30 15:06:43 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tfiga/samsung-clk.git tags/for_3.17/samsung-clk

for you to fetch changes up to f65d518942325d4bfa74b5c9d42ea5a89e4f6943:

  clk: samsung: trivial: Correct typo in author's name (2014-07-26 02:57:20 +0200)

----------------------------------------------------------------
Samsung clock patches for 3.17

1) non-critical fixes (without need to push to stable):

d5e136a clk: samsung: Register clk provider only after registering its all clocks
305cfab clk: samsung: Make of_device_id array const
e9d5295 clk: samsung: exynos5420: Setup clocks before system suspend
f65d518 clk: samsung: trivial: Correct typo in author's name

2) Exynos CLKOUT driver:

800c979 clk: samsung: exynos4: Add missing CPU/DMC clock hierarchy
01f7ec2 clk: samsung: exynos4: Add CLKOUT clock hierarchy
1e832e5 clk: samsung: Add driver to control CLKOUT line on Exynos SoCs
d19bb39 ARM: dts: exynos: Update PMU node with CLKOUT related data

3) Clock hierarchy extensions:

17d3f1d clk: exynos4: Add PPMU IP block source clocks.
ca5b402 clk: samsung: register exynos5420 apll/kpll configuration data

4) ARM CLKDOWN functionality enablement for Exynos4 and 3250:

42773b2 clk: samsung: exynos4: Enable ARMCLK down feature
45c5b0a clk: samsung: exynos3250: Enable ARMCLK down feature

----------------------------------------------------------------
Jonghwa Lee (1):
      clk: exynos4: Add PPMU IP block source clocks.

Krzysztof Kozlowski (3):
      clk: samsung: exynos4: Enable ARMCLK down feature
      clk: samsung: exynos3250: Enable ARMCLK down feature
      clk: samsung: Make of_device_id array const

Sylwester Nawrocki (1):
      clk: samsung: Register clk provider only after registering its all clocks

Thomas Abraham (1):
      clk: samsung: register exynos5420 apll/kpll configuration data

Tomasz Figa (5):
      clk: samsung: exynos4: Add missing CPU/DMC clock hierarchy
      clk: samsung: exynos4: Add CLKOUT clock hierarchy
      clk: samsung: Add driver to control CLKOUT line on Exynos SoCs
      ARM: dts: exynos: Update PMU node with CLKOUT related data
      clk: samsung: trivial: Correct typo in author's name

Vikas Sajjan (1):
      clk: samsung: exynos5420: Setup clocks before system suspend

 .../devicetree/bindings/arm/samsung/pmu.txt        |  30 +++
 arch/arm/boot/dts/exynos4210.dtsi                  |  10 +
 arch/arm/boot/dts/exynos4x12.dtsi                  |   7 +
 arch/arm/boot/dts/exynos5250.dtsi                  |   3 +
 arch/arm/boot/dts/exynos5420.dtsi                  |   3 +
 drivers/clk/samsung/Makefile                       |   1 +
 drivers/clk/samsung/clk-exynos-clkout.c            | 153 ++++++++++++++
 drivers/clk/samsung/clk-exynos3250.c               |  43 ++++
 drivers/clk/samsung/clk-exynos4.c                  | 231 ++++++++++++++++++++-
 drivers/clk/samsung/clk-exynos5250.c               |   4 +-
 drivers/clk/samsung/clk-exynos5260.c               |   2 +
 drivers/clk/samsung/clk-exynos5410.c               |   2 +
 drivers/clk/samsung/clk-exynos5420.c               |  61 +++++-
 drivers/clk/samsung/clk-exynos5440.c               |   4 +-
 drivers/clk/samsung/clk-s3c2410.c                  |   2 +
 drivers/clk/samsung/clk-s3c2412.c                  |   2 +
 drivers/clk/samsung/clk-s3c2443.c                  |   2 +
 drivers/clk/samsung/clk-s3c64xx.c                  |   2 +
 drivers/clk/samsung/clk.c                          |  21 +-
 drivers/clk/samsung/clk.h                          |   4 +-
 include/dt-bindings/clock/exynos4.h                |  25 ++-
 include/dt-bindings/clock/exynos5250.h             |   2 +-
 include/dt-bindings/clock/exynos5420.h             |   2 +-
 include/dt-bindings/clock/exynos5440.h             |   2 +-
 24 files changed, 599 insertions(+), 19 deletions(-)
 create mode 100644 drivers/clk/samsung/clk-exynos-clkout.c
