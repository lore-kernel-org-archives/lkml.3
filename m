Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaJQUpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 16:45:19 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:49127 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaJQUpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 16:45:18 -0400
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <0cb338f3bb10185f8dee5b4c1d4e96a6>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: zyw@rock-chips.com
To: Heiko Stuebner <heiko@sntech.de>
Cc: Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, dianders@chromium.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Chris Zhong <zyw@rock-chips.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/4] add suspend support for RK3288
Date: Fri, 17 Oct 2014 13:44:56 -0700
Message-Id: <1413578696-26125-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Zhong <zyw@rock-chips.com>

this is the 1st version of suspend. RK3288 can shut down the cpu, gpu and
other device controllers in suspend, and it will pull the GLOBAL_PWROFF pin
to high in the final stage of the process of suspend, pull the pin to low again
when resume.

Changes in v2:
- __raw_readl/__raw_writel replaced by readl_relaxed/writel_relaxed
- add the regulator calls in prepare and finish.
- add the pinmux of gpio6_c6 save and restore
- put "rockchip,rk3288-pmu-sram" to first

Chris Zhong (4):
  clk: rockchip: RK3288: add suspend and resume
  ARM: rockchip: add suspend and resume for RK3288
  ARM: rockchip: Add pmu-sram binding
  ARM: dts: add RK3288 suspend support

 .../devicetree/bindings/arm/rockchip/pmu-sram.txt  |   15 +
 arch/arm/boot/dts/rk3288.dtsi                      |   11 +
 arch/arm/mach-rockchip/Makefile                    |    1 +
 arch/arm/mach-rockchip/pm.c                        |  323 ++++++++++++++++++++
 arch/arm/mach-rockchip/pm.h                        |  105 +++++++
 arch/arm/mach-rockchip/rockchip.c                  |   11 +-
 arch/arm/mach-rockchip/sleep.S                     |   87 ++++++
 drivers/clk/rockchip/clk-rk3288.c                  |   63 ++++
 8 files changed, 614 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/pmu-sram.txt
 create mode 100644 arch/arm/mach-rockchip/pm.c
 create mode 100644 arch/arm/mach-rockchip/pm.h
 create mode 100644 arch/arm/mach-rockchip/sleep.S

-- 
1.7.9.5

