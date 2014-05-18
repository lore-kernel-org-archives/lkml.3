Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaERTB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 15:01:27 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35519 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaERTBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 15:01:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: alot/0.3.5
To: torvalds@linux-foundation.org
Message-ID: <20140518190116.9521.52593@quantum>
Subject: [GIT PULL] clk: fixes for 3.15
Date: Sun, 18 May 2014 12:01:16 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d1db0eea852497762cab43b905b879dfcd3b8987:

  Linux 3.15-rc3 (2014-04-27 19:29:27 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mike.turquette/linux.git tags/clk-fixes-for-linus

for you to fetch changes up to d2c834abe2b39a2d5a6c38ef44de87c97cbb34b4:

  clk: tegra: Fix wrong value written to PLLE_AUX (2014-05-16 15:49:23 -0700)

----------------------------------------------------------------
Clock framework and driver fixes, all of which fix user-visible
regressions. As usual most fixes are for platform-specific clock
drivers, but there are also two fixes to the clk core after recent
changes to the way that clock unregistration is handled.

----------------------------------------------------------------
Alex Elder (1):
      clk: bcm281xx: don't use unnamed structs or unions

Ben Dooks (1):
      clk: shmobile: clk-mstp: change to using clock-indices

Dinh Nguyen (1):
      clk: socfpga: fix clock driver for 3.15

Maxime COQUELIN (1):
      clk: divider: Fix best div calculation for power-of-two and table dividers

Mike Turquette (1):
      Merge tag 'socfpga-clk-fix-for-3.15' of git://git.rocketboards.org/linux-socfpga-next into clk-fixes-socfpga

Stephen Boyd (2):
      clk: Fix double free due to devm_clk_register()
      clk: Fix slab corruption in clk_unregister()

Tuomas Tynkkynen (1):
      clk: tegra: Fix wrong value written to PLLE_AUX

 .../bindings/clock/renesas,cpg-mstp-clocks.txt     |  2 +-
 drivers/clk/bcm/clk-kona-setup.c                   | 33 +++++-----
 drivers/clk/bcm/clk-kona.c                         | 64 ++++++++++---------
 drivers/clk/bcm/clk-kona.h                         | 28 ++++----
 drivers/clk/clk-divider.c                          | 37 ++++++++++-
 drivers/clk/clk.c                                  | 74 ++++++++++------------
 drivers/clk/shmobile/clk-mstp.c                    |  9 ++-
 drivers/clk/socfpga/clk-pll.c                      |  7 ++
 drivers/clk/socfpga/clk.c                          | 23 +------
 drivers/clk/tegra/clk-pll.c                        |  2 +-
 10 files changed, 151 insertions(+), 128 deletions(-)
