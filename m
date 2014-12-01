Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbaLAIww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:52:52 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43749 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbaLAIwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:52:49 -0500
From: Chris Zhong <zyw@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org
Cc: mturquette@linaro.org, Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>, khilman@kernel.org,
        linux-rockchip@lists.infradead.org, Chris Zhong <zyw@rock-chips.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>, Tony Xie <xxx@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v10 0/4] This suspend patch is only support cut off the power of cpu and some external
Date: Mon,  1 Dec 2014 16:52:16 +0800
Message-Id: <1417423940-1669-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devices, since we still lack power_domain driver, so the other power rail
of rk3288 need keep power on.
I have tested it on rk3288-evb board, atop next-20141112. goto suspend by type
"echo mem > /sys/power/state", vdd_cpu is about 0mv by measuring, so it can be
determined in sleep mode, then press power button to wakeup it.

Changes in v10:
- remove regulator-suspend-mem-enabled and regulator-suspend-mem-microvolt
- enable the lcd, codec, sdmmc power during suspend

Changes in v9:
- fold Doug's patches
- modify some print log
- update the subject and description

Changes in v8:
- use enum for define sleep mode
- move rk3288_config_bootdata to the front of sram memcpy
- add ddr pinctrl for suspend
- keep all except cpu&tp power rail on during suspend
- add regulator-on-in-suspend before set suspend voltage
- add a reference of ddrio_pwroff and ddr0_retention

Changes in v7:
- get rid all of unused code
- add regulator-state-mem sub node for suspend

Changes in v6:
- get rid of the save/restore of SRAM
- doing the copy of resume code once at init time
- remove ROCKCHIP_ARM_OFF_LOGIC_DEEP from rk3288_fill_in_bootram
- add of_platform_populate in rockchip_dt_init
- change pmu_intmem@ff720000 to sram@ff720000
- change pmu_intmem@ff720000 to sram@ff720000

Changes in v5:
- use rk3288_bootram_sz for memcpy size
- fixed error of sram save and restore
- change the size of sram in example
- change size to 4k

Changes in v4:
- remove grf regmap

Changes in v3:
- move the pinmux of gpio6_c6 save and restore to pinctrl-rockchip

Changes in v2:
- add the regulator calls in prepare and finish.
- add the pinmux of gpio6_c6 save and restore
- put "rockchip,rk3288-pmu-sram" to first

Chris Zhong (4):
  ARM: rockchip: add suspend and resume for RK3288
  ARM: rockchip: Add pmu-sram binding
  ARM: dts: add RK3288 suspend support
  ARM: dts: rockchip: add suspend settings for rk3288-evb-rk808

 .../devicetree/bindings/arm/rockchip/pmu-sram.txt  |  16 ++
 arch/arm/boot/dts/rk3288-evb-rk808.dts             |  53 ++++-
 arch/arm/boot/dts/rk3288.dtsi                      |  23 ++
 arch/arm/mach-rockchip/Makefile                    |   1 +
 arch/arm/mach-rockchip/pm.c                        | 260 +++++++++++++++++++++
 arch/arm/mach-rockchip/pm.h                        |  99 ++++++++
 arch/arm/mach-rockchip/rockchip.c                  |   2 +
 arch/arm/mach-rockchip/sleep.S                     |  73 ++++++
 8 files changed, 526 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/pmu-sram.txt
 create mode 100644 arch/arm/mach-rockchip/pm.c
 create mode 100644 arch/arm/mach-rockchip/pm.h
 create mode 100644 arch/arm/mach-rockchip/sleep.S

-- 
1.9.1

