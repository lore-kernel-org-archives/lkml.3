Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab3A2HiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 02:38:23 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38235 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab3A2HiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 02:38:21 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <anilkumar@ti.com>, <tony@atomide.com>, <hs@denx.de>,
        <broonie@opensource.wolfsonmicro.com>, <sameo@linux.intel.com>,
        <khilman@deeprootsystems.com>, <nsekhar@ti.com>,
        <linus.walleij@linaro.org>, <linux@arm.linux.org.uk>,
        <rob@landley.net>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <manishv.b@ti.com>
Subject: [PATCH V2 0/6] davinci: DT support for i2c0 and tps6507x
Date: Tue, 29 Jan 2013 13:08:48 +0530
Message-ID: <1359445134-13323-1-git-send-email-manishv.b@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series enables device tree support for I2C0
and for regulator via tps6507x mfd device on da850-evm.

Applies on top of v3.8-rc5 of linus tree.

Tested on da850-evm device.

Test procedure followed as below:
Once device boots up, issue command as:

$for reg in /sys/class/regulator/*; do echo $reg `cat $reg/name`
 `cat $reg/state` `cat $reg/microvolts`; done

Depends on:
 - ARM: davinci: da850: add interrupt-parent property in soc node
   https://patchwork.kernel.org/patch/2044101/
 - ARM: davinci: da850: add pinctrl support
   http://comments.gmane.org/gmane.linux.davinci/25993

Changes since V1:
 - Updated i2c0 node name in da850 dts and dtsi file.
 - Removed interrupt parent from i2c0 node.
 - Updated name for da850 auxdata lookup.
 - Added a patch in series to update pin control driver
   registration.

Vishwanathrao Badarkhe, Manish (6):
  pinctrl: pinctrl-single: use arch_initcall and module_exit
  ARM: davinci: da850: add OF_DEV_AUXDATA entry for I2C0
  ARM: davinci: da850: add DT node for I2C0
  mfd: tps6507x: add device-tree support.
  ARM: regulator: add tps6507x device tree data
  ARM: davinci: da850: add tps6507x regulator DT data

 arch/arm/boot/dts/da850-evm.dts  |   68 ++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/da850.dtsi     |   15 ++++++++
 arch/arm/boot/dts/tps6507x.dtsi  |   47 ++++++++++++++++++++++++++
 arch/arm/mach-davinci/da8xx-dt.c |    8 ++++-
 drivers/mfd/tps6507x.c           |    9 +++++
 drivers/pinctrl/pinctrl-single.c |   12 ++++++-
 6 files changed, 157 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/boot/dts/tps6507x.dtsi

-- 
1.7.4.1

