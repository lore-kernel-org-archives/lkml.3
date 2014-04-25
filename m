Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbaDYUAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:00:31 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49590 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751911AbaDYUA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:00:29 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [RFC 0/5] berlin: add support for clocks sharing registers
Date: Fri, 25 Apr 2014 22:00:18 +0200
Message-Id: <1398456024-27876-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some clock on the berlin are sharing registers, this is an attempt at supporting
them.

I think there is a third set of regiters to enable/disable the clocks but I
don't have any information on that.

I'm also not completely sure of the DT bindings and I know that this is not the
way Sebastian was envisionning it.

Alexandre Belloni (5):
  clk: berlin: add support for clock groups
  clk: berlin: add berlin clock groups DT bindings documentation
  ARM: berlin/dt: add support for the clock group to BG2
  ARM: berlin/dt: add support for the clock group to BG2D
  ARM: berlin/dt: add support for the clock group to BG2Q

 .../devicetree/bindings/clock/berlin-clock.txt     |  29 +++
 arch/arm/boot/dts/berlin2.dtsi                     |  30 ++-
 arch/arm/boot/dts/berlin2cd.dtsi                   |  36 +++-
 arch/arm/boot/dts/berlin2q.dtsi                    |  24 ++-
 drivers/clk/berlin/Makefile                        |   2 +-
 drivers/clk/berlin/grp.c                           | 208 +++++++++++++++++++++
 6 files changed, 310 insertions(+), 19 deletions(-)
 create mode 100644 drivers/clk/berlin/grp.c

-- 
1.9.1

