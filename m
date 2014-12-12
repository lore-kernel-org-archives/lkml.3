Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845AbaLLI1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:27:39 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:55354 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785AbaLLI1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:27:36 -0500
X-AuditID: cbfee68d-f79296d000004278-e4-548aa6f543fc
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: kgene.kim@samsung.com, rafael.j.wysocki@intel.com, a.kesavan@samsung.com,
        tomasz.figa@gmail.com, b.zolnierkie@samsung.com,
        k.kozlowski@samsung.com, cw00.choi@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv3 0/7] devfreq: Add devfreq-event class to provide raw data
 for devfreq device
Date: Fri, 12 Dec 2014 17:27:25 +0900
Message-id: <1418372852-12454-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRsSkQPfrsq4Qg0crjSwer1nMZLFxxnpW
	i+tfnrNazD9yjtXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF7cYVbBaP
	V7xlt1i16w+jA5/Hzll32T0W73nJ5LF5Sb1H35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZbw9
	9oilYKJxxawP1g2MOzW7GDk5JARMJJbtvcYEYYtJXLi3nq2LkYtDSGApo8TD5e/ZYYoWrf/L
	DpFYxCix6PNnRginiUni3Kz9zCBVbAJaEvtf3GADsUUEzCV2Lf0JNopZ4BKTxPaZPWA7hAVS
	JKa/m8AKYrMIqEqs3dwO1swr4Cqx7dUkVoh1ChLLls9kBWmWENjELrFw+QtmiAYBiW+TD7F0
	MXIAJWQlNh1ghqiXlDi44gbLBEbBBYwMqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzECQ//0
	v2e9OxhvH7A+xCjAwajEw/sitStEiDWxrLgy9xCjKdCGicxSosn5wAjLK4k3NDYzsjA1MTU2
	Mrc0UxLnVZT6GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMcr2jXiCZYqZk9PriKU+H38m
	nvi++dbCc4tMv3Lu2bbr/sr30sFrC23OtjLrL5R1/li+Pll5x4nq3LfRE54cS+9cV1nft0Kx
	Wfjy3MU/p84Q5//3ZqlYcbu9rdLUBTbz8hcp/J/RUWu8g+89w18uu+NrphvHLykLOLt3849/
	amdf/Nx33fgBQ5gSS3FGoqEWc1FxIgD3ZvXUeAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t9jAd2vy7pCDG490bB4vGYxk8XGGetZ
	La5/ec5qMf/IOVaL1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWtxtXsFk8
	XvGW3WLVrj+MDnweO2fdZfdYvOclk8fmJfUefVtWMXp83iQXwBrVwGiTkZqYklqkkJqXnJ+S
	mZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SokkJZYk4pUCggsbhYSd8O04TQ
	EDddC5jGCF3fkCC4HiMDNJCwhjHj7bFHLAUTjStmfbBuYNyp2cXIySEhYCKxaP1fdghbTOLC
	vfVsXYxcHEICixglFn3+zAjhNDFJnJu1nxmkik1AS2L/ixtsILaIgLnErqU/wTqYBS4xSWyf
	2cMEkhAWSJGY/m4CK4jNIqAqsXZzO1gzr4CrxLZXk1gh1ilILFs+k3UCI/cCRoZVjKKpBckF
	xUnpuYZ6xYm5xaV56XrJ+bmbGMGR9UxqB+PKBotDjAIcjEo8vC9Su0KEWBPLiitzDzFKcDAr
	ifD+jQIK8aYkVlalFuXHF5XmpBYfYjQF2j6RWUo0OR8Y9Xkl8YbGJmZGlkbmhhZGxuZK4rxK
	9m0hQgLpiSWp2ampBalFMH1MHJxSDYzsJ27vnH9rheyeF1PqTxgw7567cN1h9c3n6juFNQKV
	ZV4cZbRxOs5+Z9mPGSvT1yYVRKm8f/j5UcUJlblP+hb/KJOyfr0wt/9vTOM7hsuOPkHP3c7o
	m587McHK+uOVjcF1dhV/OHtXp/TpnG23Oiv4r6LWccZfzsWfZ09eUL5N+v2kuHxhgx0hSizF
	GYmGWsxFxYkA59jLw8ICAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add new devfreq_event class to provide raw data to determine
current utilization of device  which is used for devfreq governor.

[Description of devfreq-event class]
This patchset add new devfreq_event class for devfreq_event device which provide
raw data (e.g., memory bus utilization/GPU utilization). This raw data from
devfreq_event data would be used for the governor of devfreq subsystem.
- devfreq_event device : Provide raw data for governor of existing devfreq device
- devfreq device       : Monitor device state and change frequency/voltage of device
                         using the raw data from devfreq_event device

The devfreq subsystem support generic DVFS(Dynamic Voltage/Frequency Scaling)
for Non-CPU Devices. The devfreq device would dertermine current device state
using various governor (e.g., ondemand, performance, powersave). After completed
determination of system state, devfreq device would change the frequency/voltage
of devfreq device according to the result of governor.

But, devfreq governor must need basic data which indicates current device state.
Existing devfreq subsystem only consider devfreq device which check current system
state and determine proper system state using basic data. There is no subsystem
for device providing basic data to devfreq device.

The devfreq subsystem must need devfreq_event device(data-provider device) for
existing devfreq device. So, this patch add new devfreq_event class for
devfreq_event device which read various basic data(e.g, memory bus utilization,
GPU utilization) and provide measured data to existing devfreq device through
standard APIs of devfreq_event class.

The following description explains the feature of two kind of devfreq class:
- devfreq class (existing)
 : devfreq consumer device use raw data from devfreq_event device for
   determining proper current system state and change voltage/frequency
   dynamically using various governors.
- devfreq_event class (new)
 : Provide measured raw data to devfreq device for governor

Also, the devfreq-event device would support various type event as following:
 : DEVFREQ_EVENT_TYPE_RAW_DATA
 : DEVFREQ_EVENT_TYPE_UTILIZATION
 : DEVFREQ_EVENT_TYPE_BANDWIDTH
 : DEVFREQ_EVENT_TYPE_LATENCY

[For example]
If board dts includes PPMU_DMC0/DMC1/LEFTBUS/RIGHTBUS event node,
would show following sysfs entry. Also devfreq driver(e.g., exynos4_bus.c)
can get the instance of devfreq-event device by using provided API and then
get raw data which reflect the current state of device.

-sh-3.2# cd /sys/class/devfreq-event/
-sh-3.2# ls -al
total 0
drwxr-xr-x  2 root root 0 Jan  9 16:47 .
drwxr-xr-x 37 root root 0 Jan  9 16:47 ..
lrwxrwxrwx  1 root root 0 Jan  9 16:47 event.0 -> ../../devices/soc/106a0000.ppmu_dmc0/devfreq-event/event.0
lrwxrwxrwx  1 root root 0 Jan  9 16:47 event.1 -> ../../devices/soc/106b0000.ppmu_dmc1/devfreq-event/event.1
lrwxrwxrwx  1 root root 0 Jan  9 16:47 event.2 -> ../../devices/soc/112a0000.ppmu_rightbus/devfreq-event/event.2
lrwxrwxrwx  1 root root 0 Jan  9 16:47 event.3 -> ../../devices/soc/116a0000.ppmu_leftbus0/devfreq-event/event.3
-sh-3.2# 

Changes from v2:
1. devfreq-event class driver
- Rename all the helper functions of devfreq-event device
- Add devfreq_event_remove_edev() instead of devfreq_put_event_dev()
- Add devfreq_event_release_edev() to initialize it before put device
- Add the detailed description of devfreq-event API
- Add the attributes of devfreq-event class (enable_count)
- Check the overflow about event/total_event data in devfreq_event_get_event()
- Remove the 'exclusive flag' feature
- Set set_event()/get_event() functions as mandary
- Add missing of_node_put() call
- Change variable type of 'get_event()' funciton from 'int' to 'u64'
2. exynos-ppmu driver
- Remove un-used field (struct devfreq)
- Use 'of_get_child_by_name()' instead of 'of_find_node_by_name()'
- Add missing of_node_put() call
- Fix wrong clock control
- Use devfreq_event_remove_edev() instead of devfreq_remove_device()
- Add the documentation for exynos-ppmu driver
- Remove 'enable/disable/is_enabled/reset' function of exynos-ppmu driver
3. exynos3250-rinato.dts
- Add ppmu_{leftbus|rightbus} dt node and remove ppmu_cpu dt node

Changes from v1:
- Code clean
- Add the description of devfreq-event structure
- Add 'is_enabled' function to devfreq_event_ops structure
- Add 'enable_count' field to devfreq_event_dev structure
- Check whether devfreq-event device is enabled or not
  during calling devfreq_event API
- Define the type of devfreq-event device as following
  : DEVFREQ_EVENT_TYPE_RAW_DATA
  : DEVFREQ_EVENT_TYPE_UTILIZATION
  : DEVFREQ_EVENT_TYPE_BANDWIDTH
  : DEVFREQ_EVENT_TYPE_LATENCY
- Add the exclusive feature of devfreq-event device.
  If devfreq-event device is used on only on devfreq driver,
  should used 'devfreq_enable_event_dev_exclusive()' function
- Add new patch6 for test on Exynos3250-based Rinato board

Chanwoo Choi (7):
  devfreq: event: Add new devfreq_event class to provide basic data for devfreq governor
  devfreq: event: Add the list of supported devfreq-event type
  devfreq: event: Add exynos-ppmu devfreq event driver
  devfreq: event: Add documentation for exynos-ppmu devfreq-event driver
  ARM: dts: Add PPMU dt node for Exynos3250
  ARM: dts: Add PPMU dt node for Exynos4 SoC
  ARM: dts: exynos: Add PPMU dt node to Exynos3250-based Rinato board

 .../bindings/devfreq/event/exynos-ppmu.txt         |  56 +++
 arch/arm/boot/dts/exynos3250-rinato.dts            |  40 ++
 arch/arm/boot/dts/exynos3250.dtsi                  |  66 +++
 arch/arm/boot/dts/exynos4.dtsi                     |  96 +++++
 arch/arm/boot/dts/exynos4210.dtsi                  |   8 +
 drivers/devfreq/Kconfig                            |  11 +
 drivers/devfreq/Makefile                           |   5 +-
 drivers/devfreq/devfreq-event.c                    | 476 +++++++++++++++++++++
 drivers/devfreq/event/Makefile                     |   2 +
 drivers/devfreq/event/exynos-ppmu.c                | 404 +++++++++++++++++
 include/linux/devfreq.h                            | 165 +++++++
 11 files changed, 1328 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
 create mode 100644 drivers/devfreq/devfreq-event.c
 create mode 100644 drivers/devfreq/event/Makefile
 create mode 100644 drivers/devfreq/event/exynos-ppmu.c

-- 
1.8.5.5

