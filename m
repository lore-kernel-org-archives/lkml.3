Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872AbaJ2Lwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:52:45 -0400
Received: from mail-pd0-f195.google.com ([209.85.192.195]:46725 "EHLO
	mail-pd0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512AbaJ2Lwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:52:42 -0400
From: Chris Zhong <zyw@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org
Cc: mturquette@linaro.org, Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>, khilman@kernel.org,
        linux-rockchip@lists.infradead.org, Chris Zhong <zyw@rock-chips.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        Tony Xie <xxx@rock-chips.com>, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6 0/7] This is the 1st version of suspend for RK3288.
Date: Wed, 29 Oct 2014 19:51:58 +0800
Message-Id: <1414583525-17395-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RK3288 can shut down the cpu, gpu and other device controllers in suspend,
and it will pull the GLOBAL_PWROFF pin to high in the final stage of the
process of suspend, pull the pin to low again when resume.

Changes in v6:
- modify comments
- get rid of the save/restore of SRAM
- doing the copy of resume code once at init time
- remove ROCKCHIP_ARM_OFF_LOGIC_DEEP from rk3288_fill_in_bootram
- add of_platform_populate in rockchip_dt_init
- change pmu_intmem@ff720000 to sram@ff720000
- change pmu_intmem@ff720000 to sram@ff720000

Changes in v5:
- reset-author
- use "__maybe_unused" annotation
- add pinctrl_force_default() in the error case
- modify comments
- use rk3288_bootram_sz for memcpy size
- fixed error of sram save and restore
- change the size of sram in example
- change size to 4k

Changes in v4:
- use SIMPLE_DEV_PM_OPS for suspend/resume struct
- remove grf regmap

Changes in v3:
- move the pinmux of gpio6_c6 save and restore to pinctrl-rockchip

Changes in v2:
- __raw_readl/__raw_writel replaced by readl_relaxed/writel_relaxed
- add the regulator calls in prepare and finish.
- add the pinmux of gpio6_c6 save and restore
- put "rockchip,rk3288-pmu-sram" to first

Chris Zhong (7):
  pinctrl: rockchip: add suspend/resume functions
  pinctrl: rockchip: save and restore gpio6_c6 pinmux in suspend/resume
  clk: rockchip: RK3288: add suspend and resume
  ARM: rockchip: add suspend and resume for RK3288
  ARM: rockchip: Add pmu-sram binding
  ARM: dts: add RK3288 suspend support
  ARM: dts: add suspend voltage setting for RK808

 .../devicetree/bindings/arm/rockchip/pmu-sram.txt  |   16 ++
 arch/arm/boot/dts/rk3288-evb-rk808.dts             |   16 +-
 arch/arm/boot/dts/rk3288.dtsi                      |   11 +
 arch/arm/mach-rockchip/Makefile                    |    1 +
 arch/arm/mach-rockchip/pm.c                        |  278 ++++++++++++++++++++
 arch/arm/mach-rockchip/pm.h                        |  103 ++++++++
 arch/arm/mach-rockchip/rockchip.c                  |    8 +
 arch/arm/mach-rockchip/sleep.S                     |   90 +++++++
 drivers/clk/rockchip/clk-rk3288.c                  |   60 +++++
 drivers/pinctrl/pinctrl-rockchip.c                 |   46 ++++
 10 files changed, 628 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/pmu-sram.txt
 create mode 100644 arch/arm/mach-rockchip/pm.c
 create mode 100644 arch/arm/mach-rockchip/pm.h
 create mode 100644 arch/arm/mach-rockchip/sleep.S

-- 
1.7.9.5

