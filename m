Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab3KLTru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:47:50 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59021 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab3KLTrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:47:42 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>
CC: <wni@nvidia.com>, <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv5 00/20] device thermal limits represented in device tree nodes (v5)
Date: Tue, 12 Nov 2013 15:46:02 -0400
Message-ID: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Here is v5 of the work of representing hardware thermal properties
in device tree infrastructure. Previous versions can be
found here:
V4: https://lkml.org/lkml/2013/9/26/787
V3: https://lkml.org/lkml/2013/9/15/122
RFCv2: http://lkml.org/lkml/2013/8/23/594
RFCv1: http://lkml.org/lkml/2013/7/22/319

The differences from V4 of this series are pretty minor. Here is a shortlog:
1. Rephrased couple of sentences and improved description of a couple of properties.
2. Removed the macro constants for trip type from the binding header file.
3. Due to (3), patches 09/14/15 were adapted to use plain string constants
4. As per suggestion by Nishanth M. I also included in this series two
patches to move TI bandgap nodes to belong under OCP.
5. I volunteered to maintain the thermal binding, so added that to MAINTAINERS.

This specific series has been tested on OMAP4430, OMAP4460, OMAP5432 and DRA7.

All best,

Eduardo Valentin (20):
  thermal: allow registering without .get_temp
  thermal: introduce device tree parser
  thermal: core: introduce thermal_of_cooling_device_register
  thermal: cpu_cooling: introduce of_cpufreq_cooling_register
  cpufreq: cpufreq-cpu0: add dt node parsing for cooling device
    properties
  hwmon: lm75: expose to thermal fw via DT nodes
  hwmon: tmp102: expose to thermal fw via DT nodes
  thermal: ti-soc-thermal: use thermal DT infrastructure
  arm: dts: add omap4 CPU thermal data
  arm: dts: add omap4430 thermal data
  arm: dts: add omap4460 thermal data
  arm: dts: add cooling properties on omap4430 cpu node
  arm: dts: add cooling properties on omap4460 cpu node
  arm: dts: add omap5 GPU thermal data
  arm: dts: add omap5 CORE thermal data
  arm: dts: add omap5 thermal data
  arm: dts: add cooling properties on omap5 cpu node
  arm: dts: make OMAP443x bandgap node to belong to OCP
  arm: dts: make OMAP4460 bandgap node to belong to OCP
  MAINTAINERS: add maintainer entry for thermal bindings

 .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |   7 +
 .../devicetree/bindings/thermal/thermal.txt        | 586 ++++++++++++++
 MAINTAINERS                                        |   1 +
 arch/arm/boot/dts/omap4-cpu-thermal.dtsi           |  41 +
 arch/arm/boot/dts/omap443x.dtsi                    |  23 +-
 arch/arm/boot/dts/omap4460.dtsi                    |  29 +-
 arch/arm/boot/dts/omap5-core-thermal.dtsi          |  28 +
 arch/arm/boot/dts/omap5-gpu-thermal.dtsi           |  28 +
 arch/arm/boot/dts/omap5.dtsi                       |  15 +-
 drivers/cpufreq/Kconfig                            |   2 +-
 drivers/cpufreq/cpufreq-cpu0.c                     |  16 +
 drivers/hwmon/lm75.c                               |  35 +-
 drivers/hwmon/tmp102.c                             |  19 +
 drivers/thermal/Kconfig                            |  14 +
 drivers/thermal/Makefile                           |   1 +
 drivers/thermal/cpu_cooling.c                      |  56 +-
 drivers/thermal/of-thermal.c                       | 849 +++++++++++++++++++++
 drivers/thermal/thermal_core.c                     |  77 +-
 drivers/thermal/thermal_core.h                     |   9 +
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  77 +-
 include/dt-bindings/thermal/thermal.h              |  17 +
 include/linux/cpu_cooling.h                        |  25 +
 include/linux/thermal.h                            |  32 +-
 23 files changed, 1936 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/thermal/thermal.txt
 create mode 100644 arch/arm/boot/dts/omap4-cpu-thermal.dtsi
 create mode 100644 arch/arm/boot/dts/omap5-core-thermal.dtsi
 create mode 100644 arch/arm/boot/dts/omap5-gpu-thermal.dtsi
 create mode 100644 drivers/thermal/of-thermal.c
 create mode 100644 include/dt-bindings/thermal/thermal.h

-- 
1.8.2.1.342.gfa7285d

