Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab3HWXRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 19:17:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51161 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab3HWXRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 19:17:23 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <linux@roeck-us.net>, <rui.zhang@intel.com>,
        <wni@nvidia.com>
CC: <durgadoss.r@intel.com>, <linux-pm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [RFC PATCH 00/14] RFCv2: device thermal limits represented in device tree nodes
Date: Fri, 23 Aug 2013 19:15:41 -0400
Message-ID: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

First of all, apologize for the very late answer. But I am resuming this work.

This RFC is about describing hardware thermal limits using device tree.

Based on the discussion on the first RFC:
http://lkml.org/lkml/2013/7/22/319

I have changed the code and the device tree bindings as follows:
1. Now bindings may have several thermal zones per device (req. by Wei Ni)
2. The constants used are now using C preprocessor macros (as per Stephen suggestion)
3. Improved the bindings to have a better representation of links between
involved entities (thermal zone, cooling devices, sensors), as suggested
by Pawel and Mark.
4. Couple of changes in code, as per previous reviews.
5. Removed policies from DT bindings.

In summary, based on the discussion of the first RFC, now the idea is
to have thermal zones nodes describing the thermal zones
and the hardware limits. Then sensor devices nodes will point to
thermal zones via phandles and cooling device will also point to
thermal zone via phandles.

So, I am also posting the patch series to dt mailing list as requested.

Please refer to patch 02/14 to a documentation of what I am proposing.

This patch series includes:
a. Required changes in cpufreq-cpu0 driver so that it loads cooling device
when requested.
b. The thermal zone builder based on thermal bindings
c. Changes in sensor drivers (as examples)
d. Changes in device tree DTS files (as examples)

This patch series depends on the fixes I sent to linux-pm:
http://lkml.org/lkml/2013/8/23/572

In the above link you will find also the request to have a flag to
determine if virtual hwmon device will be created, based on thermal device.

All best,

Eduardo Valentin (14):
  cpufreq: cpufreq-cpu0: add dt node parsing for 'cooling-zones'
  drivers: thermal: introduce device tree parser
  hwmon: lm75: expose to thermal fw via DT nodes
  hwmon: tmp102: expose to thermal fw via DT nodes
  thermal: ti-soc-thermal: use thermal DT infrastructure
  arm: dts: add omap4 CPU thermal data
  arm: dts: add omap4430 thermal data
  arm: dts: add omap4460 thermal data
  arm: dts: point to cooling-zones on omap4430 cpu node
  arm: dts: point to cooling-zones on omap4460 cpu node
  arm: dts: add omap5 GPU thermal data
  arm: dts: add omap5 CORE thermal data
  arm: dts: add omap5 thermal data
  arm: dts: point to cooling-zones on omap5 cpu node

 .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |   4 +
 .../devicetree/bindings/thermal/thermal.txt        | 160 +++++++
 arch/arm/boot/dts/omap4-cpu-thermal.dtsi           |  40 ++
 arch/arm/boot/dts/omap443x.dtsi                    |   6 +
 arch/arm/boot/dts/omap4460.dtsi                    |   6 +
 arch/arm/boot/dts/omap5-core-thermal.dtsi          |  27 ++
 arch/arm/boot/dts/omap5-gpu-thermal.dtsi           |  27 ++
 arch/arm/boot/dts/omap5.dtsi                       |  10 +
 drivers/cpufreq/cpufreq-cpu0.c                     |  12 +
 drivers/hwmon/lm75.c                               |  31 ++
 drivers/hwmon/tmp102.c                             |  26 ++
 drivers/thermal/Kconfig                            |  13 +
 drivers/thermal/Makefile                           |   1 +
 drivers/thermal/thermal_dt.c                       | 473 +++++++++++++++++++++
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  52 ++-
 include/dt-bindings/thermal/thermal.h              |  27 ++
 include/linux/thermal.h                            |   3 +
 17 files changed, 907 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/thermal/thermal.txt
 create mode 100644 arch/arm/boot/dts/omap4-cpu-thermal.dtsi
 create mode 100644 arch/arm/boot/dts/omap5-core-thermal.dtsi
 create mode 100644 arch/arm/boot/dts/omap5-gpu-thermal.dtsi
 create mode 100644 drivers/thermal/thermal_dt.c
 create mode 100644 include/dt-bindings/thermal/thermal.h

-- 
1.8.2.1.342.gfa7285d

