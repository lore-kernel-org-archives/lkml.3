Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbaHZOKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:10:46 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:38905 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbaHZOKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:10:44 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <267f3da2ea522898b94e7d490c574340>
X-DNS-TYPE: 1
From: Chris Zhong <zyw@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, a.zummo@towertech.it, mturquette@linaro.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com,
        Chris Zhong <zyw@rock-chips.com>
Subject: [PATCH v6 0/5] Add rockchip RK808 pmic driver
Date: Tue, 26 Aug 2014 22:10:18 +0800
Message-Id: <1409062218-11844-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the initial version of the RK808 PMIC. This is a power management IC
for multimedia products.

It provides regulators that are able to supply power to processor cores
and other components. The chip provides other modules including RTC, Clockout

Changes in v6:
- remove the redundant code
Adviced by doug
- use correct argument call of_clk_add_provider in probe
Adviced by doug
- move RTC_READSEL setting into probe
Adviced by Lee Jones in v2
- rk808_i2c_client instead of g_rk808
- remove pdata form struct rk808
Advices by Mark Rutland
- add description about clock-cells
Advices by Doug
- modify description about regulator
- remove pinctrl description

Changes in v5:
- re-edit base on Mark's branch
Adviced by doug
- add some error checking in probe
- move "rockchip,rk808.h" into the patch about dt-bindings
- fixed a bug about set_time failed
Advices by Mark Brown
- add description about regulator valid name.
- add a header file "rockchip,rk808".

Changes in v4:
- use &client->dev replace rk808->dev
Adviced by doug
- add "clock-output-names" propertiey
- add a header file "rockchip,rk808.h"
- use &client->dev replace rk808->dev
Adviced by Lee Jones in v2
- modify the description in Kconfig
- remove some unnecessary header files
- remove dev from struct rk808
- use enum for define RK808_ID...
Advices by Doug
- add a "#clock-cells" propertiy
- update the example

Changes in v3:
- fix compile err
- fix compile err

Changes in v2:
Adviced by Mark Browm:
- change of_find_node_by_name to find_child_by_name
- use RK808_NUM_REGULATORS as the name of the constant
- create a pdata when missing platform data
- use the rk808_reg name to supply_regulator name
- replace regulator_register with devm_regulator_register
- some other problem with coding style
Adviced by javier.martinez
- separated from rtc-rk808.c
Adviced by javier.martinez
- Add a separate clock driver, rather than in RTC driver
Adviced by Mark Browm:
- use defines for register setting value
- remove rtc alarm disable in shutdown
- remove while(1) in shutdown
- remove read 0x2f in probe

Chris Zhong (5):
  dt-bindings: Add RK808 device tree bindings document
  MFD: RK808: Add new mfd driver for RK808
  RTC: RK808: add RTC driver for RK808
  clk: RK808: Add clkout driver for RK808
  regulator: RK808: remove redundant code

 Documentation/devicetree/bindings/mfd/rk808.txt |  150 +++++++++
 drivers/clk/Kconfig                             |    9 +
 drivers/clk/Makefile                            |    1 +
 drivers/clk/clk-rk808.c                         |  163 +++++++++
 drivers/mfd/Kconfig                             |   13 +
 drivers/mfd/Makefile                            |    1 +
 drivers/mfd/rk808.c                             |  257 ++++++++++++++
 drivers/regulator/rk808-regulator.c             |   17 +-
 drivers/rtc/Kconfig                             |   10 +
 drivers/rtc/Makefile                            |    1 +
 drivers/rtc/rtc-rk808.c                         |  412 +++++++++++++++++++++++
 include/dt-bindings/clock/rockchip,rk808.h      |   11 +
 include/linux/mfd/rk808.h                       |  202 +++++++++++
 13 files changed, 1234 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/rk808.txt
 create mode 100644 drivers/clk/clk-rk808.c
 create mode 100644 drivers/mfd/rk808.c
 create mode 100644 drivers/rtc/rtc-rk808.c
 create mode 100644 include/dt-bindings/clock/rockchip,rk808.h
 create mode 100644 include/linux/mfd/rk808.h

-- 
1.7.9.5


