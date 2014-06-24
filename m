Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaFXKBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:01:35 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:41908 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaFXKAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:00:21 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v3 0/6] clk: sunxi: fixes, cleanups and A23 basic clocks
Date: Tue, 24 Jun 2014 17:59:34 +0800
Message-Id: <1403603980-31101-1-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This is a followup series to my A23 bare-minimum bringup series [1],
which adds basic clock support for the A23 SoC. It is one of many
split up from the original A23 series [2]. Yet to come are more
clocks, reset controllers, pinctrl, prcm, and mmc.

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

The last patch adds the DT nodes for the newly added clocks.

Patch 1 should be merged for 3.16, while the rest should go in 3.17.


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
 arch/arm/boot/dts/sun8i-a23.dtsi                  | 115 ++++++++++++++++++++
 drivers/clk/sunxi/clk-factors.c                   |   2 +-
 drivers/clk/sunxi/clk-factors.h                   |   1 +
 drivers/clk/sunxi/clk-sunxi.c                     | 121 ++++++++++++++++++++--
 5 files changed, 234 insertions(+), 10 deletions(-)

-- 
2.0.0

