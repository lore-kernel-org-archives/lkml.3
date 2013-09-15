Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3IOWEA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 18:04:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38415 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab3IOWD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 18:03:58 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>
CC: <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 00/16] device thermal limits represented in device tree nodes (v3)
Date: Sun, 15 Sep 2013 18:02:27 -0400
Message-ID: <1379282563-14650-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Here is the continuation of work of representing hardware thermal properties
in device tree infrastructure. The present patch series is the third version
of this work. Previous versions were sent as RFCs and can be found here:
RFCv2: http://lkml.org/lkml/2013/8/23/594
RFCv1: http://lkml.org/lkml/2013/7/22/319

The major change between RFCv2 and this version is the fact that I am now
designing the binding accordingly to the common practice of creating links
from consumers to producers, as seen in regulators for instance. The change
make a thermal zone node point to used cooling devices and used sensor devices.
As direct need, cooling devices then need to be properly represented.
I am proposing to have cooling properties inside existing nodes, e.g. fan nodes,
cpu nodes. The change also required me to modify the existing thermal core
code to allow decoupling thermal zones from sensor code. Currently, the
binding proposal covers for the situation in which one thermal zone has
several sensor devices. Although this situation is not covered by the
current thermal framework code, and thus not supported by this series.
I believe this is not a stopper for this series, it can be done
in later patch sets.

The second patch includes a detailed documentation with examples
and the proposed code. In this patch series, a part from the dt parser,
there are changes in the cpufreq code to load the cpu cooling device,
also changes in the following sensor drivers: tmp102, lm75 and ti-soc-thermal.
Several changes in TI's SoC DT bindings are also included, as source
of tested examples.

The present patch series was tested on OMAP4430, OMAP4460, OMAP5430 and DRA7,
although the DRA7 changes were not sent as the core device tree support is
currently in the process to find its way to upstream.

All best,

Eduardo Valentin (16):
  drivers: thermal: allow registering without .get_temp
  drivers: thermal: introduce device tree parser
  drivers: thermal: cpu_cooling: introduce of_cpufreq_cooling_register
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

 .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |   7 +
 .../devicetree/bindings/thermal/thermal.txt        | 498 ++++++++++++++
 arch/arm/boot/dts/omap4-cpu-thermal.dtsi           |  41 ++
 arch/arm/boot/dts/omap443x.dtsi                    |  15 +-
 arch/arm/boot/dts/omap4460.dtsi                    |  15 +-
 arch/arm/boot/dts/omap5-core-thermal.dtsi          |  28 +
 arch/arm/boot/dts/omap5-gpu-thermal.dtsi           |  28 +
 arch/arm/boot/dts/omap5.dtsi                       |  15 +-
 drivers/cpufreq/Kconfig                            |   2 +-
 drivers/cpufreq/cpufreq-cpu0.c                     |  16 +
 drivers/hwmon/lm75.c                               |  46 +-
 drivers/hwmon/tmp102.c                             |  28 +
 drivers/thermal/Kconfig                            |  14 +
 drivers/thermal/Makefile                           |   1 +
 drivers/thermal/cpu_cooling.c                      |  31 +
 drivers/thermal/of-thermal.c                       | 763 +++++++++++++++++++++
 drivers/thermal/thermal_core.c                     |  19 +-
 drivers/thermal/thermal_core.h                     |   9 +
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  77 ++-
 include/dt-bindings/thermal/thermal.h              |  27 +
 include/linux/cpu_cooling.h                        |  25 +
 include/linux/thermal.h                            |  28 +-
 22 files changed, 1701 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/thermal/thermal.txt
 create mode 100644 arch/arm/boot/dts/omap4-cpu-thermal.dtsi
 create mode 100644 arch/arm/boot/dts/omap5-core-thermal.dtsi
 create mode 100644 arch/arm/boot/dts/omap5-gpu-thermal.dtsi
 create mode 100644 drivers/thermal/of-thermal.c
 create mode 100644 include/dt-bindings/thermal/thermal.h

-- 
1.8.2.1.342.gfa7285d

