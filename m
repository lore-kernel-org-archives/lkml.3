Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaGMQhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 12:37:42 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:55836 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbaGMQhe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 12:37:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: alot/0.3.5
To: torvalds@linux-foundation.org
Message-ID: <20140713163727.9850.72520@quantum>
Subject: [GIT PULL] clk: fixes for 3.16
Date: Sun, 13 Jul 2014 09:37:27 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4c834452aad01531db949414f94f817a86348d59:

  Linux 3.16-rc3 (2014-06-29 14:11:36 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mike.turquette/linux.git tags/clk-fixes-for-linus

for you to fetch changes up to 449437778bd09b73a5e51554f7219706da08917f:

  clk: spear3xx: Set proper clock parent of uart1/2 (2014-07-13 07:12:11 -0700)

----------------------------------------------------------------
This batch of fixes is for a handful of clock drivers from Allwinner,
Samsung, ST & TI. Most of them are of the "this hardware won't work
without this fix" variety, including patches that fix platforms that did
not boot under certain configurations. Other fixes are the result of
changes to the clock core introduced in 3.15 that had subtle impacts on
the clock drivers.

There are no fixes to the clock framework core in this pull request.

----------------------------------------------------------------
Charles Keepax (1):
      clk: s3c64xx: Hookup SPI clocks correctly

Dan Carpenter (1):
      clk: ti: apll: not allocating enough data

Doug Anderson (1):
      clk: exynos5420: Remove aclk66_peric from the clock tree description

Himangi Saraogi (1):
      clk: sunxi: fix devm_ioremap_resource error detection code

Julia Lawall (1):
      clk: ti: dra7: return error code in failure case

Krzysztof Kozlowski (1):
      clk: s2mps11: Fix double free corruption during driver unbind

Mike Turquette (2):
      Merge branch 'for-v3.16-rc/ti-clk-drv' of github.com:t-kristo/linux-pm into clk-fixes-ti
      Merge tag 'for_3.16/samsung-clk-fixes' of git://git.kernel.org/.../tfiga/samsung-clk into clk-fixes-samsung

Rahul Sharma (1):
      clk/exynos5250: fix bit number for tv sysmmu clock

Roger Quadros (2):
      clk: ti: am43x: Fix boot with CONFIG_SOC_AM33XX disabled
      clk: ti: am43x: Fix boot with CONFIG_SOC_AM33XX disabled

Stephen Boyd (1):
      clk: qcom: HDMI source sel is 3 not 2

Thomas Gleixner (2):
      clk: spear3xx: Use proper control register offset
      clk: spear3xx: Set proper clock parent of uart1/2

Tomasz Figa (1):
      clk: samsung: exynos4: Remove SRC_MASK_ISP gates

Tomi Valkeinen (1):
      clk: ti: set CLK_SET_RATE_NO_REPARENT for ti,mux-clock

Vasily Khoruzhick (2):
      clk: samsung: fix several typos to fix boot on s3c2410
      clk: samsung: add more aliases for s3c24xx

 drivers/clk/clk-s2mps11.c                |  7 +--
 drivers/clk/qcom/mmcc-msm8960.c          |  2 +-
 drivers/clk/samsung/clk-exynos4.c        | 16 ++----
 drivers/clk/samsung/clk-exynos5250.c     |  2 +-
 drivers/clk/samsung/clk-exynos5420.c     | 85 +++++++++++++++++++++-----------
 drivers/clk/samsung/clk-s3c2410.c        |  9 +++-
 drivers/clk/samsung/clk-s3c64xx.c        |  6 ++-
 drivers/clk/spear/spear3xx_clock.c       | 16 ++++--
 drivers/clk/sunxi/clk-sun6i-apb0-gates.c |  2 +-
 drivers/clk/ti/apll.c                    |  8 ++-
 drivers/clk/ti/dpll.c                    |  5 +-
 drivers/clk/ti/mux.c                     |  2 +-
 include/dt-bindings/clock/exynos5420.h   |  1 -
 13 files changed, 93 insertions(+), 68 deletions(-)
