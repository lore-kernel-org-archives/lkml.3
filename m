Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab3KYOpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:45:51 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38722 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593Ab3KYOps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:45:48 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>, <linux@roeck-us.net>, <mark.rutland@arm.com>,
        <khali@linux-fr.org>
CC: <wni@nvidia.com>, <durgadoss.r@intel.com>, <linux-pm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Thermal and Device tree
Date: Mon, 25 Nov 2013 10:44:29 -0400
Message-ID: <1385390669-7613-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rui,

Please consider the following changes for 3.14. It contains the work of
representing hardware thermal using device tree. It also contains
three examples on how to use the new representation on sensor devices,
using three different drivers to accomplish it. One driver is on thermal
subsystem, the TI SoC thermal, and the other two drivers are in hwmon
subsystem. I also included a change on cpu cooling device, which required
also a change on cpufreq-cpu0 driver. The change on this cooling device
still keeps in one piece its usage on different platforms.

Because it is a controversial topic due to the lack of standards, and
because it touches different subsystems, it took way longer than I expected.
However, I've been discussing in different channels, and I believe I got
enough entropy now to go forward. We have acks from cpufreq folks (on ARM side)
and from hwmon folks too. Raphael W., Jean D. and Mark R. have also
reviewed this series. They agree with the core idea of the work.

It has been agreed that this is not the end of it. As I said I started
with only three examples, but there are other potential drivers to use
this API. So, I have agreed with Jean D., for instance, that this
series would be first step of the complete work. Next would be to check
other potential drivers to be converted and then validate the proposed
API. Currently the thermal framework would be polling for device
temperature, but we could implement a couple of call backs to setup
update rate, thresholds and hysteresis too, for instance.

On the other hand, I don't think the principle and concept would break
after converting the remaining drivers. That is why I am sending this pull
request.

Another point is, as you can see, there are several points in this pull
request that do not belong to thermal subsystem. It has been suggested
by Guenter R. that in such cases, it is recommended to send the complete
series via one single subsystem. Thus, I am sending via your queue.

Lastly, I've also volunteered to maintain the upcoming thermal bindings.
Then, you can see I am adding thermal bindings to our MAINTAINERS entry too.


All best,

The following changes since commit 86e0a0bdf81c2dfa2a5a258dbb52f49c40ebc197:

  Merge branches 'intel_powerclamp', 'tmon' and 'misc' of .git into next (2013-11-07 08:45:54 +0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git next

for you to fetch changes up to 14d653c8ffc85c4aea7e50baa9a3c198b4fcf9c5:

  MAINTAINERS: add thermal bindings entry in thermal domain (2013-11-25 10:19:12 -0400)

----------------------------------------------------------------
Eduardo Valentin (20):
      thermal: allow registering without .get_temp
      thermal: introduce device tree parser
      thermal: core: introduce thermal_of_cooling_device_register
      thermal: cpu_cooling: introduce of_cpufreq_cooling_register
      cpufreq: cpufreq-cpu0: add dt node parsing for cooling device properties
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
      MAINTAINERS: add thermal bindings entry in thermal domain

 .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |   7 +
 .../devicetree/bindings/thermal/thermal.txt        | 589 ++++++++++++++
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
 23 files changed, 1939 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/thermal/thermal.txt
 create mode 100644 arch/arm/boot/dts/omap4-cpu-thermal.dtsi
 create mode 100644 arch/arm/boot/dts/omap5-core-thermal.dtsi
 create mode 100644 arch/arm/boot/dts/omap5-gpu-thermal.dtsi
 create mode 100644 drivers/thermal/of-thermal.c
 create mode 100644 include/dt-bindings/thermal/thermal.h
