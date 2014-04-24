Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbaDXTE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:04:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43956 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758843AbaDXTEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:04:25 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 0/5] Berlin: add clock support
Date: Thu, 24 Apr 2014 21:04:07 +0200
Message-Id: <1398366252-19582-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for the clocks having their own register set. Other
clocks are available but they are sharing a common register in addition of their
own registers. They will be supported in a following series.

Also, I realized that when moving the pll nodes out of the clocks container,
they didn't get reorder.

Changes in v2:
 - reworked berlin_clk_recalc_rate() as suggested by Sebastian
 - some dts tweaks, as suggested by Antoine

Alexandre Belloni (5):
  clk: berlin: add support for clocks
  clk: berlin: add berlin clocks DT bindings documentation
  ARM: berlin/dt: add sdio clocks to BG2
  ARM: berlin/dt: add sdio clocks to BG2CD
  ARM: berlin/dt: add sdio clocks to BG2Q

 .../devicetree/bindings/clock/berlin-clock.txt     |   9 +-
 arch/arm/boot/dts/berlin2.dtsi                     |  42 ++++---
 arch/arm/boot/dts/berlin2cd.dtsi                   |  42 ++++---
 arch/arm/boot/dts/berlin2q.dtsi                    |  28 +++--
 drivers/clk/berlin/Makefile                        |   2 +-
 drivers/clk/berlin/clk.c                           | 134 +++++++++++++++++++++
 6 files changed, 220 insertions(+), 37 deletions(-)
 create mode 100644 drivers/clk/berlin/clk.c

-- 
1.9.1

