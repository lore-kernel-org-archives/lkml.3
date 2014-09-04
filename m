Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652AbaIDBNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 21:13:07 -0400
Received: from mail-pa0-f67.google.com ([209.85.220.67]:39717 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933430AbaIDBNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 21:13:04 -0400
From: Chris Zhong <zyw@rock-chips.com>
To: dianders@chromium.org, heiko@sntech.de
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        a.zummo@towertech.it, mturquette@linaro.org, akpm@linux-foundation.org,
        broonie@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        grant.likely@linaro.org, hl@rock-chips.com, huangtao@rock-chips.com,
        cf@rock-chips.com, zhangqing@rock-chips.com, xxx@rock-chips.com,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com,
        Chris Zhong <zyw@rock-chips.com>
Subject: [PATCH v9 0/3] Add rockchip RK808 pmic driver
Date: Thu,  4 Sep 2014 09:12:36 +0800
Message-Id: <1409793159-2573-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the initial version of the RK808 PMIC. This is a power management IC
for multimedia products.

It provides regulators that are able to supply power to processor cores
and other components. The chip provides other modules including RTC, Clockout

Changes in v9:
Adviced by Dmitry
- if(rk808_rtc->irq < 0), return rk808_rtc->irq
Adviced by Doug
- add reg_np

Changes in v8:
Adviced by Doug
- coding style
- fix regmap_update_bits()
- if(rk808_rtc->irq < 0) return err num
Adviced by Mike
-rename "control" to "enable"
-define RK808_NR_OUTPUT 2
Adviced by Doug
- remove rk808_regulator_dts() function
- remove the check about "client->dev.of_node"

Changes in v7:
Adviced by doug
- read rtc time from shadowed registers
Adviced by Dmitry
- use CONFIG_PM_SLEEP replace CONFIG_PM
- use SIMPLE_DEV_PM_OPS replace dev_pm_ops
- fix dev_warn
- coding style
Adviced by Heiko
- remove rtc_ctl
Adviced by doug
-fix coding style problems
- remove pdata struct from header file, add rk808_regulator struct

Changes in v6:
Adviced by doug
- move RTC_READSEL setting into probe
Adviced by doug
- use correct argument call of_clk_add_provider in probe
- remove the redundant code

Changes in v5:
- fixed a bug about set_time failed
Adviced by doug
- add some error checking in probe
- move "rockchip,rk808.h" into the patch about dt-bindings
- re-edit base on Mark's branch

Changes in v4:
- use &client->dev replace rk808->dev
Adviced by doug
- add "clock-output-names" propertiey
- add a header file "rockchip,rk808.h"
- use &client->dev replace rk808->dev

Changes in v3:
- fix compile err

Changes in v2:
Adviced by javier.martinez
- Add a separate clock driver, rather than in RTC driver
Adviced by javier.martinez
- separated from rtc-rk808.c
Adviced by Mark Browm:
- change of_find_node_by_name to find_child_by_name
- use RK808_NUM_REGULATORS as the name of the constant
- create a pdata when missing platform data
- use the rk808_reg name to supply_regulator name
- replace regulator_register with devm_regulator_register
- some other problem with coding style

Chris Zhong (3):
  RTC: RK808: add RTC driver for RK808
  clk: RK808: Add clkout driver for RK808
  regulator: RK808: Remove pdata from the regulator

 drivers/clk/Kconfig                 |    9 +
 drivers/clk/Makefile                |    1 +
 drivers/clk/clk-rk808.c             |  164 ++++++++++++++
 drivers/regulator/rk808-regulator.c |   91 ++------
 drivers/rtc/Kconfig                 |   10 +
 drivers/rtc/Makefile                |    1 +
 drivers/rtc/rtc-rk808.c             |  426 +++++++++++++++++++++++++++++++++++
 7 files changed, 629 insertions(+), 73 deletions(-)
 create mode 100644 drivers/clk/clk-rk808.c
 create mode 100644 drivers/rtc/rtc-rk808.c

-- 
1.7.9.5

