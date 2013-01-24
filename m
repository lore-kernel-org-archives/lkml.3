Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab3AXK4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:56:06 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58093 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631Ab3AXKyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:54:52 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <anilkumar@ti.com>, <tony@atomide.com>, <hs@denx.de>,
        <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        <sameo@linux.intel.com>, <khilman@ti.com>, <linux@arm.linux.org.uk>,
        <rob@landley.net>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <manishv.b@ti.com>
Subject: [PATCH 0/6] davinci: support for i2c0 and tps6507x 
Date: Thu, 24 Jan 2013 16:25:14 +0530
Message-ID: <1359024920-32190-1-git-send-email-manishv.b@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series enables device tree support for I2C0 and
for regulator via tps6507x mfd device on da850-evm.

Applies on top of v3.8-rc4 of linus tree.

Tested on da850-evm device.

Test procedure followed as below:
Once device boots up, issue command as:

$for reg in /sys/class/regulator/*; do echo $reg `cat $reg/name`
`cat $reg/state` `cat $reg/microvolts`; done

This command will print all available regulators with its name,
status (enabled/disabled) and voltages(in microvolts) like as below:
/sys/class/regulator/regulator.1 VDCDC1_3.3V enabled 3300000
/sys/class/regulator/regulator.2 VDCDC2_3.3V enabled 3300000
/sys/class/regulator/regulator.3 VDCDC3_1.2V enabled 1200000
/sys/class/regulator/regulator.4 LDO1_1.8V enabled 1800000
/sys/class/regulator/regulator.5 LDO2_1.2V enabled 1200000

Vishwanathrao Badarkhe, Manish (6):
  ARM: davinci: da850: add OF_DEV_AUXDATA entry for I2C0
  ARM: davinci: da850: add DT node for I2C0
  davinci: mfd: tps6507x: add device-tree support.
  davinci: regulator: tps6507x: add device tree support.
  ARM: regulator: add tps6507x device tree data
  ARM: davinci: da850: add tps6507x regulator DT data

 Documentation/devicetree/bindings/mfd/tps6507x.txt |   91 +++++++++++++++++++
 arch/arm/boot/dts/da850-evm.dts                    |   79 +++++++++++++++++
 arch/arm/boot/dts/da850.dtsi                       |   10 ++
 arch/arm/boot/dts/tps6507x.dtsi                    |   47 ++++++++++
 arch/arm/mach-davinci/da8xx-dt.c                   |    8 ++-
 drivers/mfd/tps6507x.c                             |    9 ++
 drivers/regulator/tps6507x-regulator.c             |   92 ++++++++++++++++++++
 7 files changed, 335 insertions(+), 1 deletions(-)
 create mode 100755 Documentation/devicetree/bindings/mfd/tps6507x.txt
 create mode 100644 arch/arm/boot/dts/tps6507x.dtsi

-- 
1.7.4.1

