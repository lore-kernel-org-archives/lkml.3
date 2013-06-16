Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab3FPTNP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 15:13:15 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:49596 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab3FPTNO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 15:13:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: alot/0.3.4
To: torvalds@linux-foundation.org
Message-ID: <20130616191311.7541.43872@quantum>
Subject: [GIT PULL] clk: fixes for 3.10-rc7
Date: Sun, 16 Jun 2013 12:13:11 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:

  Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)

are available in the git repository at:

  git://git.linaro.org/people/mturquette/linux.git tags/clk-fixes-for-linus

for you to fetch changes up to ff49fad1d9bf2c49f52817b04cde8e4412434637:

  ARM: tegra30: clocks: Fix pciex clock registration (2013-06-16 11:25:45 -0700)

----------------------------------------------------------------
Half of the fixes here are for Exynos5, fixing regressions in CPUfreq
due to the common clock framework conversion as well as one fix which
allows the platform to properly reboot again. One core framework fix
patches up a memory leak, another fixes a build error for the SPEAr
platform and finally a Tegra-specific fix allows PCIe to initialize
properly on that platform again.

----------------------------------------------------------------
Arnd Bergmann (1):
      clk: spear: fix build error for spear3xx

Doug Anderson (1):
      clk: samsung: Fix pll36xx_recalc_rate to handle kdiv properly

Jay Agarwal (1):
      ARM: tegra30: clocks: Fix pciex clock registration

Lai Jiangshan (1):
      clk: remove notifier from list before freeing it

Tushar Behera (3):
      clk: exynos5250: Update cpufreq related clocks for EXYNOS5250
      clk: exynos5250: Add sclk_mpll to the parent list of mout_cpu clock
      clk: exynos5250: Add CLK_IGNORE_UNUSED flag for pmu clock

 drivers/clk/clk.c                    |  1 +
 drivers/clk/samsung/clk-exynos5250.c | 10 +++++-----
 drivers/clk/samsung/clk-pll.c        |  5 +++--
 drivers/clk/spear/spear3xx_clock.c   |  2 +-
 drivers/clk/tegra/clk-tegra30.c      | 11 ++++++-----
 5 files changed, 16 insertions(+), 13 deletions(-)
