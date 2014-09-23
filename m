Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbaIWPx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:53:58 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44461 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaIWPx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:53:56 -0400
From: Chris Zhong <zyw@rock-chips.com>
To: dianders@chromium.org, heiko@sntech.de
Cc: linux-rockchip@lists.infradead.org, lee.jones@linaro.org,
        broonie@kernel.org, Chris Zhong <zyw@rock-chips.com>,
        devicetree@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v6 0/2] regulator: get voltage & duty table from dts for st-pwm
Date: Tue, 23 Sep 2014 23:53:40 +0800
Message-Id: <1411487622-10881-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get voltage & duty table from device tree might be better, other platforms can also use this
driver without any modify.
Tested on a rk3288 sdk board as logic voltage regulator.

Changes in v6:
Adviced by Mark Rutland
- fix a spelling error

Changes in v4:
Adviced by Doug Anderson
- improve kconfig
- add const for desc structure
Adviced by Doug Anderson
- remove regulator-always-on and regulator-boot-on from the Example

Changes in v3:
Adviced by Doug Anderson
- Make Kconfig & Makefile alphabetical
- remove pwm_reg_period from pwm_regulator_data
- modify the calculation in pwm_regulator_set_voltage_sel
- add length validity check
Adviced by Doug Anderson
- update the Example

Changes in v2:
Adviced by Lee Jones
- rename the file
- remove all the prefix st_
- add depend on PWM in Kconfig
Adviced by Lee Jones
- rename the documentation
Adviced by Doug Anderson
- update the example
Adviced by Mark Rutland
- remove pwm-reg-period

Chris Zhong (2):
  regulator: st-pwm: get voltage and duty table from dts
  dt-bindings: add devicetree bindings for st-pwm regulator

 .../bindings/regulator/pwm-regulator.txt           |   27 +++
 drivers/regulator/Kconfig                          |   13 +-
 drivers/regulator/Makefile                         |    2 +-
 drivers/regulator/pwm-regulator.c                  |  197 ++++++++++++++++++++
 drivers/regulator/st-pwm.c                         |  190 -------------------
 5 files changed, 232 insertions(+), 197 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/pwm-regulator.txt
 create mode 100644 drivers/regulator/pwm-regulator.c
 delete mode 100644 drivers/regulator/st-pwm.c

-- 
1.7.9.5

