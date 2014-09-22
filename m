Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbaIVVJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:09:47 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:42252 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbaIVVJq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:09:46 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: alot/0.3.5
To: torvalds@linux-foundation.org
Message-ID: <20140922210924.19023.36624@quantum>
Subject: [GIT PULL] clk: fixes for 3.17
Date: Mon, 22 Sep 2014 14:09:24 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:

  http://git.linaro.org/people/mike.turquette/linux.git tags/clk-fixes-for-linus

for you to fetch changes up to 8ce8ebeb572d70e672a8d158e93ffaac80ea7576:

  clk/efm32gg: fix dt init prototype (2014-09-09 13:52:18 -0700)

----------------------------------------------------------------
The fixes for the clock tree are mostly run-time bugs in clock drivers.
The fixes for TI DRA7 remove divide-by-zero errors. The recently merged
AT91 clock driver fixes some bad error checking and the QCOM driver fix
restores audio for that platform, a clear regression. A list iteration
bug in the framework core was hit recently and is fixed up here. Finally
a compilation warning is fixed for efm32gg, which is also a regression
fix.

----------------------------------------------------------------
Boris BREZILLON (1):
      clk: at91: fix num_parents test in at91sam9260 slow clk implementation

Doug Anderson (1):
      clk: rockchip: Fix the clocks for i2c1 and i2c2

Mike Turquette (1):
      Merge branch 'for-v3.17-rc/ti-clk-driver' of github.com:t-kristo/linux-pm into clk-fixes

Nishanth Menon (2):
      clk: ti: divider: Provide error check for incoming parameters in set_rate
      clk: ti: dra7-atl: Provide error check for incoming parameters in set_rate

Stephen Boyd (1):
      clk: qcom: Fix sdc 144kHz frequency entry

Tero Kristo (1):
      clk: prevent erronous parsing of children during rate change

Uwe Kleine-König (1):
      clk/efm32gg: fix dt init prototype

 drivers/clk/at91/clk-slow.c       | 2 +-
 drivers/clk/clk-efm32gg.c         | 6 +++---
 drivers/clk/clk.c                 | 7 ++++++-
 drivers/clk/qcom/gcc-ipq806x.c    | 2 +-
 drivers/clk/rockchip/clk-rk3288.c | 4 ++--
 drivers/clk/ti/clk-dra7-atl.c     | 6 +++++-
 drivers/clk/ti/divider.c          | 7 ++++++-
 7 files changed, 24 insertions(+), 10 deletions(-)
