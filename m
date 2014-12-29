Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaL2AEv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 19:04:51 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:32506 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaL2AE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 19:04:26 -0500
X-AuditID: cbfee68e-f79b46d000002b74-91-54a09a86bee8
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv6 0/9] devfreq: Add devfreq-event class to provide raw data for
 devfreq device
Date: Mon, 29 Dec 2014 09:04:04 +0900
Message-id: <1419811453-16160-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWyRsSkRLd91oIQgyvzGS0er1nMZHH9y3NW
	i/lHzrFaTLo/gcXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bF5S79G3ZRWjx+dNcgFsUVw2Kak5
	mWWpRfp2CVwZqz53MhU8cK24824HYwPjVYsuRg4OCQETiZvvk7oYOYFMMYkL99azdTFycQgJ
	LGWU+PfnDgtEwkTi2Yf/7BCJ6YwSPy78ZoVwmpgkGs+/ZwSpYhPQktj/4gYbiC0iICNxdeN2
	FpAiZoFGZokvy/4zgSSEBRIkdq5YA2azCKhKXHz/mBnE5hVwlTgyexErxDoFiWXLZ4JtkBA4
	xC5x7P4BdogGAYlvkw+xQNwtK7HpADNEvaTEwRU3WCYwCi5gZFjFKJpakFxQnJReZKRXnJhb
	XJqXrpecn7uJERgPp/8969vBePOA9SFGAQ5GJR7eCcfmhwixJpYVV+YeYjQF2jCRWUo0OR8Y
	dXkl8YbGZkYWpiamxkbmlmZK4rwJUj+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAGnf1U
	ZrZcfIbGzq2mV+5cnv/rTe+zbVXcjK5bT96KnxVq89B1fWW3cOjBH/yi00y21W6RF128/9j+
	LfYXVQNmL9cOlvm4cm/UQtb9W25M//Ce59MDq4Q/yhZLktfYHpT+FZdUc9XnZb3v+iN1r0xM
	f22btNzvkYJCQ5vzViWJhyarPZqO9R+ZpcRSnJFoqMVcVJwIAGfwepaCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jQd22WQtCDLYvM7Z4vGYxk8X1L89Z
	LeYfOcdqMen+BBaL1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFqt2/WF04PdYM28No8fOWXfZPRbvecnksXlJvUffllWMHp83yQWwRTUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaykUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzFj1uZOp4IFrxZ13OxgbGK9adDFyckgI
	mEg8+/CfHcIWk7hwbz1bFyMXh5DAdEaJHxd+s0I4TUwSjeffM4JUsQloSex/cYMNxBYRkJG4
	unE7C0gRs0Ajs8SXZf+ZQBLCAgkSO1esAbNZBFQlLr5/zAxi8wq4ShyZvYgVYp2CxLLlM1kn
	MHIvYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcb8+kdzCuarA4xCjAwajEwzvh2PwQ
	IdbEsuLK3EOMEhzMSiK8RmULQoR4UxIrq1KL8uOLSnNSiw8xmgJtn8gsJZqcD0wFeSXxhsYm
	ZkaWRuaGFkbG5krivEr2bSFCAumJJanZqakFqUUwfUwcnFINjHHlM57oOicc3/L4Sn6LR4vt
	SoHohxHb0oIfB674mdy3rr4iOEGi3fvNzR1TU6+c5zaTd9YqCq9TdjFhqnaINrZxcZH7/KU1
	+U1T02RelgYBsz3hx1o9OmSf7/m5WNjzjFndv4yIt3N7Hu7VnzJbVXaHosKRtQHcr6vfWc09
	5zWtI7Usr9lJiaU4I9FQi7moOBEAdi8rq80CAAA=
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

Changes from v5:
- Rebase these patch-set on v3.19-rc1 and Test it.
1. exynos-ppmu.c
- Change the error value when of_iomap() fail to map the memory
- Remove owner setting of platform_driver
- Add exynos_ppmu_disable() function
2. exynos dts file
- Add PPMU node to Exynos3250-based Monk board
- Remove ppmu_cpu node on Exynos4412-based TRATS2 board and add ppmu_leftbus/rightbus node

Changes from v4:
1. devfreq-event class driver
- Add devfreq_event_get_edev_count() function
- Modify the simple description of devfreq-event framework in devfreq-event.c
- Minimize the usage range of global lock usage in devfreq_event_add_edev()
- Remove '_is_enabled()' function pointer in devfreq_event_ops structure
- Add separte CONFIG_PM_DEVFREQ_EVENT configuration
- Add new devfreq-event.h header file including devfreq-event helper functions
2. exynos dts file
- Add new patch to support PPMU with DEVFREQ-event on Exynos4412-based TRATS2

Changes from v3:
1. devfreq-event class driver
- Fix return value of devfreq_event_get_event()
- Add new structure devfreq_event_data for devfreq_event_get_event()
- Modify the prototype of devfreq_event_get_event() function
- Call of_node_put after calling of_parse_phandle() to decrement refcount
2. exynos-ppmu driver
- Modify usage of devfreq_event_get_event() function
  according to new prototype of this funciton
- Add the additional description to exynos-ppmu.txt how to add PPMU node
  in board dts file
- Use 'PPMU_EVENT' macro to remove duplicate codes
- Add the support of PPMU for Exynos5260
3. exynos dts file
- Add missing PPMU_FSYS node to exynos3250.dtsi
- Fix 'ppmu_mfc_l' node name as 'ppmu_mfc' because exynos3250 has only one MFC IP.
- Add missing PPMU_ACP/G3D to exynos4.dtsi
4. etc
- Fix wrong abbreviation of PPMU (PPMU :Platform Performance Monitoring Unit)
- Add new patch to support the PPMU of Exynos5260 SoC

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

Chanwoo Choi (9):
  devfreq: event: Add new devfreq_event class to provide basic data for devfreq governor
  devfreq: event: Add the list of supported devfreq-event type
  devfreq: event: Add exynos-ppmu devfreq-event driver
  devfreq: event: Add documentation for exynos-ppmu devfreq-event driver
  ARM: dts: Add PPMU dt node for Exynos3250 SoC
  ARM: dts: Add PPMU dt node for Exynos4 SoCs
  ARM: dts: Add PPMU dt node for Exynos5260 SoC
  ARM: dts: exynos: Add PPMU node to Exynos3250-based Rinato/Monk board
  ARM: dts: exynos: Add PPMU node for Exynos4412-based TRATS2 board

 .../bindings/devfreq/event/exynos-ppmu.txt         | 110 +++++
 arch/arm/boot/dts/exynos3250-monk.dts              |  40 ++
 arch/arm/boot/dts/exynos3250-rinato.dts            |  40 ++
 arch/arm/boot/dts/exynos3250.dtsi                  |  74 +++
 arch/arm/boot/dts/exynos4.dtsi                     | 108 +++++
 arch/arm/boot/dts/exynos4210.dtsi                  |   8 +
 arch/arm/boot/dts/exynos4412-trats2.dts            |  40 ++
 arch/arm/boot/dts/exynos5260.dtsi                  |  90 ++++
 drivers/devfreq/Kconfig                            |   2 +
 drivers/devfreq/Makefile                           |   6 +-
 drivers/devfreq/devfreq-event.c                    | 510 +++++++++++++++++++++
 drivers/devfreq/event/Kconfig                      |  25 +
 drivers/devfreq/event/Makefile                     |   2 +
 drivers/devfreq/event/exynos-ppmu.c                | 410 +++++++++++++++++
 include/linux/devfreq-event.h                      | 189 ++++++++
 15 files changed, 1653 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
 create mode 100644 drivers/devfreq/devfreq-event.c
 create mode 100644 drivers/devfreq/event/Kconfig
 create mode 100644 drivers/devfreq/event/Makefile
 create mode 100644 drivers/devfreq/event/exynos-ppmu.c
 create mode 100644 include/linux/devfreq-event.h

-- 
1.8.5.5

