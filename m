Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaCUUI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 16:08:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58677 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751800AbaCUUI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 16:08:57 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2 0/5] berlin: initial support for the clocks
Date: Fri, 21 Mar 2014 21:08:36 +0100
Message-Id: <1395432521-11055-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the berlin PLLs. This allows to remove the bogus
fixed clocks that are used in the SoCs dts includes.

For now, I have left out the AVPLL to ease reviewing.

This is tested on a BG2Q DMP.

Changes in v2:
 - reworked the DT bindings documentation
 - removed the cpuclk node
 - moved the pll node in the soc node and ordered them by address.
 - renamed clk.h => common.h and removed the stray #include
 - reordered the includes in pll-*.c
 - extended the vcodiv tables so that we can't overflow it
 - reordered the struct berlin_pllmap members assignements
 - replaced the void *data member of the struct berlin_pll by a
   struct berlin_pllmap *map

Alexandre Belloni (5):
  clk: berlin: add support for berlin plls
  clk: berlin: add berlin clocks DT bindings documentation
  ARM: berlin/dt: add cpupll and syspll support to BG2Q
  ARM: berlin/dt: add cpupll and syspll support to BG2CD
  ARM: berlin/dt: add cpupll and syspll support to BG2

 .../devicetree/bindings/clock/berlin-clock.txt     |  29 ++++++
 arch/arm/boot/dts/berlin2.dtsi                     |  48 +++++----
 arch/arm/boot/dts/berlin2cd.dtsi                   |  48 +++++----
 arch/arm/boot/dts/berlin2q.dtsi                    |  22 +++--
 drivers/clk/Makefile                               |   1 +
 drivers/clk/berlin/Makefile                        |   4 +
 drivers/clk/berlin/common.h                        |  35 +++++++
 drivers/clk/berlin/pll-berlin2.c                   |  42 ++++++++
 drivers/clk/berlin/pll-berlin2q.c                  |  42 ++++++++
 drivers/clk/berlin/pll.c                           | 107 +++++++++++++++++++++
 10 files changed, 337 insertions(+), 41 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/berlin-clock.txt
 create mode 100644 drivers/clk/berlin/Makefile
 create mode 100644 drivers/clk/berlin/common.h
 create mode 100644 drivers/clk/berlin/pll-berlin2.c
 create mode 100644 drivers/clk/berlin/pll-berlin2q.c
 create mode 100644 drivers/clk/berlin/pll.c

-- 
1.8.3.2

