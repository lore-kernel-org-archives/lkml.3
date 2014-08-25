Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbaHYN2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:28:38 -0400
Received: from regular1.263xmail.com ([211.150.99.139]:44073 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091AbaHYN2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:28:35 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <50ee685fd43bd19bb0331015324e5441>
X-ATTACHMENT-NUM: 0
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
Subject: [PATCH v5 0/5] Add rockchip RK808 pmic driver
Date: Mon, 25 Aug 2014 21:26:24 +0800
Message-Id: <1408973184-21146-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the initial version of the RK808 PMIC. This is a power management IC
for multimedia products.

It provides regulators that are able to supply power to processor cores
and other components. The chip provides other modules including RTC, Clockout

Changes in v5:
Adviced by doug
- add some error checking in probe
- move "rockchip,rk808.h" into the patch about dt-bindings
- re-edit base on Mark's branch
- fixed a bug about set_time failed
Advices by Mark Brown
- add description about regulator valid name.
- add a header file "rockchip,rk808".

Changes in v4:
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
Adviced by javier.martinez
- separated from rtc-rk808.c
Adviced by Mark Browm:
- change of_find_node_by_name to find_child_by_name
- use RK808_NUM_REGULATORS as the name of the constant
- create a pdata when missing platform data
- use the rk808_reg name to supply_regulator name
- replace regulator_register with devm_regulator_register
- some other problem with coding style
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
  Regulator: RK808: modify for struct rk808 change
  clk: RK808: Add clkout driver for RK808

 Documentation/devicetree/bindings/mfd/rk808.txt |  142 ++++++++
 drivers/clk/Kconfig                             |    9 +
 drivers/clk/Makefile                            |    1 +
 drivers/clk/clk-rk808.c                         |  164 +++++++++
 drivers/mfd/Kconfig                             |   13 +
 drivers/mfd/Makefile                            |    1 +
 drivers/mfd/rk808.c                             |  265 ++++++++++++++
 drivers/regulator/rk808-regulator.c             |   34 +-
 drivers/rtc/Kconfig                             |   11 +
 drivers/rtc/Makefile                            |    1 +
 drivers/rtc/rtc-rk808.c                         |  442 +++++++++++++++++++++++
 include/dt-bindings/clock/rockchip,rk808.h      |   11 +
 include/linux/mfd/rk808.h                       |  211 +++++++++++
 13 files changed, 1285 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/rk808.txt
 create mode 100644 drivers/clk/clk-rk808.c
 create mode 100644 drivers/mfd/rk808.c
 create mode 100644 drivers/rtc/rtc-rk808.c
 create mode 100644 include/dt-bindings/clock/rockchip,rk808.h
 create mode 100644 include/linux/mfd/rk808.h

-- 
1.7.9.5


