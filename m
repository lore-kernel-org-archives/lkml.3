Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaHTD1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 23:27:00 -0400
Received: from regular1.263xmail.com ([211.150.99.130]:47828 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaHTD06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 23:26:58 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <62a44450188caf95f8672b2defbe9fc9>
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
Subject: [PATCH v2 0/5] Add rockchip RK808 pmic driver
Date: Wed, 20 Aug 2014 11:24:47 +0800
Message-Id: <1408505087-23706-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the initial version of the RK808 PMIC. This is a power management IC
for multimedia products.

It provides regulators that are able to supply power to processor cores
and other components. The chip provides other modules including RTC, Clockout

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
  MFD: Add rk808 device tree bindings documentation
  MFD: RK808: Add new mfd driver for RK808
  RTC: RK808: add RTC driver for RK808
  Regulator: RK808: Add regulator driver for RK808
  Clk: RK808: Add clkout driver for RK808

 Documentation/devicetree/bindings/mfd/rk808.txt |  128 +++++++
 drivers/clk/Kconfig                             |    9 +
 drivers/clk/Makefile                            |    1 +
 drivers/clk/clk-rk808.c                         |  146 +++++++
 drivers/mfd/Kconfig                             |   13 +
 drivers/mfd/Makefile                            |    1 +
 drivers/mfd/rk808.c                             |  297 +++++++++++++++
 drivers/regulator/Kconfig                       |   10 +
 drivers/regulator/Makefile                      |    1 +
 drivers/regulator/rk808-regulator.c             |  410 ++++++++++++++++++++
 drivers/rtc/Kconfig                             |   11 +
 drivers/rtc/Makefile                            |    1 +
 drivers/rtc/rtc-rk808.c                         |  462 +++++++++++++++++++++++
 include/linux/mfd/rk808.h                       |  219 +++++++++++
 14 files changed, 1709 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rk808.txt
 create mode 100644 drivers/clk/clk-rk808.c
 create mode 100644 drivers/mfd/rk808.c
 create mode 100644 drivers/regulator/rk808-regulator.c
 create mode 100644 drivers/rtc/rtc-rk808.c
 create mode 100644 include/linux/mfd/rk808.h

-- 
1.7.9.5


