Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbaFZP4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:56:09 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:42106 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbaFZP4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:56:06 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v4 0/6] clk: sunxi: fixes, cleanups and A23 basic clocks
Date: Thu, 26 Jun 2014 23:55:38 +0800
Message-Id: <1403798144-32188-1-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This is v4 of the sun8i clock series, which adds basic clock
support for the A23 SoC. It is based on my initial sun8i bring
up series [1]. This series was split up from the original A23
series [2]. Yet to come are more clocks, reset controllers,
prcm, pinctrl, and mmc.

The first patch fixes the reworked clock protection code merged in
3.16-rc1, which unintentionally made clock gates unprotectable.

The second patch moves the remaining "ahb_sdram" clock to the
protected clock list, now that it works.

The third patch adds support for factor clocks that have an N factor
not starting from 0. This is found on some PLLs in A31/A23.

The fourth patch adds table-based dividers for div clocks, as some
clocks, such as apb0 divider on sun4/5/7i, apb1 on sun6/8i and axi
on sun8i.

The fifth patch adds support for the basic clocks in the A23, just
PLL1 for cpus, and the system bus clocks and gates.

The last patch adds the DT nodes for the newly added clocks, and
updates clock phandles for existing peripherals, the uarts.

Originally I intended for patch 1 to be merged as a fix for 3.16.
However, the only user of the affected code, sun6i's "ahb1_sdram"
clock, doesn't seem to result in any runtime issues. So this whole
series can go into 3.17.


Related changes since v3:

  - Dropped fields with default values from sun8i_a23_axi_div_data
  - Added Maxime's Acked-by
  - Fixed incorrect compatible string for axi clock node
  - Updated clock phandles for uarts in dtsi

Related changes since v2:

  - Rewrote factor clocks to support any (0~255) N factor starting value

Related changes since v1:

  - Added "clk: sunxi: Add support for table-based divider clocks"
  - Added table-based divider axi clock
  - Fixed incorrectly squashed fixups


Cheers
ChenYu


  [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/265211.html
  [2] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/259097.html

Chen-Yu Tsai (6):
  clk: sunxi: register clock gates with clkdev
  clk: sunxi: move "ahb_sdram" to protected clock list
  clk: sunxi: Support factor clocks with N factor starting not from 0
  clk: sunxi: Add support for table-based divider clocks
  clk: sunxi: Add A23 clocks support
  ARM: sun8i: Add basic clock nodes to the DTSI

 Documentation/devicetree/bindings/clock/sunxi.txt |   5 +
 arch/arm/boot/dts/sun8i-a23.dtsi                  | 125 +++++++++++++++++++++-
 drivers/clk/sunxi/clk-factors.c                   |   2 +-
 drivers/clk/sunxi/clk-factors.h                   |   1 +
 drivers/clk/sunxi/clk-sunxi.c                     | 119 ++++++++++++++++++--
 5 files changed, 237 insertions(+), 15 deletions(-)

-- 
2.0.0

