Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaLWDSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 22:18:25 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41892 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbaLWDSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 22:18:21 -0500
X-AuditID: cbfee68e-f79b46d000002b74-4f-5498defb0ea4
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv5 0/9] devfreq: Add devfreq-event class to provide raw data for
 devfreq device
Date: Tue, 23 Dec 2014 12:18:08 +0900
Message-id: <1419304697-14789-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWyRsSkUPf3vRkhBrNaxC0er1nMZHH9y3NW
	i/lHzrFaTLo/gcXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bF5S79G3ZRWjx+dNcgFsUVw2Kak5
	mWWpRfp2CVwZnzbeZy+Y51Rxa9Z0lgbGd6ZdjJwcEgImEhv/P2eEsMUkLtxbz9bFyMUhJLCU
	UeL8/7OsMEVv511ggkgsYpTYO/8sC4TTxCTx99BXJpAqNgEtif0vbrCB2CICMhJXN24HK2IW
	aGSW+LLsP1iRsECCxIv5v8D2sQioSqzZdResgVfAVeLj2fVsEOsUJJYtn8kK0iwhsI9d4uLZ
	GSwQDQIS3yYfArI5gBKyEpsOMEPUS0ocXHGDZQKj4AJGhlWMoqkFyQXFSelFRnrFibnFpXnp
	esn5uZsYgRFx+t+zvh2MNw9YH2IU4GBU4uH9eW5GiBBrYllxZe4hRlOgDROZpUST84Fxl1cS
	b2hsZmRhamJqbGRuaaYkzpsg9TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6Pinw4Nnk9r
	v9esfBe6rt27d0qE4Y1+9j/bF6dFvQnZ//z8H62WhffK/trxa6htPHjsyEI/leNvDJ/MiIzZ
	JrzgH8uktiLpgLLXC7a3uz8VmxzI/7mhfdqjXOMvYs+39Qe85CpI+LtF4nXO2mchk1bN+XWe
	f20fo1HqmhNbf24uLrAoX7Q+o9pXiaU4I9FQi7moOBEAW8LaYYMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jAd3f92aEGJw4x23xeM1iJovrX56z
	Wsw/co7VYtL9CSwWr18YWvQuuMpmcbbpDbvFpsfXWC0u75rDZvG59wijxYzz+5gsll6/yGRx
	u3EFm8XjFW/ZLVbt+sPowO+xZt4aRo+ds+6yeyze85LJY/OSeo++LasYPT5vkgtgi2pgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOllJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmPFp4332gnlOFbdmTWdpYHxn2sXIySEh
	YCLxdt4FJghbTOLCvfVsXYxcHEICixgl9s4/ywLhNDFJ/D30FayKTUBLYv+LG2wgtoiAjMTV
	jdvBipgFGpklviz7D1YkLJAg8WL+L0YQm0VAVWLNrrtgDbwCrhIfz65ng1inILFs+UzWCYzc
	CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx9sz6R2MqxosDjEKcDAq8fAuODMjRIg1
	say4MvcQowQHs5IIr3orUIg3JbGyKrUoP76oNCe1+BCjKdD2icxSosn5wFSQVxJvaGxiZmRp
	ZG5oYWRsriTOq2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXAqJIcJHSk4+HRjQyB789pZ3aqerxf
	9l3qV02DaE3uSZY2m00b9C3nSt5u+XfNpfWhyN0d6ipTeJf5r/wkZ3r4oHPhuZ23NpbE++ZK
	snQ0flvT+ptb3p39u++6hudbFr9kPrd6PcsPPY9g0cR14fWnrZM+5vzUUG1LbZ1vLKuw7dcC
	j8vPJLYVK7EUZyQaajEXFScCADNuI+jNAgAA
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
  ARM: dts: exynos: Add PPMU node to Exynos3250-based Rinato board
  ARM: dts: exynos: Add PPMU_CPU/DMC0/DMC1 node for Exynos4412-based TRATS2 board

 .../bindings/devfreq/event/exynos-ppmu.txt         | 110 +++++
 arch/arm/boot/dts/exynos3250-rinato.dts            |  40 ++
 arch/arm/boot/dts/exynos3250.dtsi                  |  72 +++
 arch/arm/boot/dts/exynos4.dtsi                     | 108 +++++
 arch/arm/boot/dts/exynos4210.dtsi                  |   8 +
 arch/arm/boot/dts/exynos4412-trats2.dts            |  30 ++
 arch/arm/boot/dts/exynos5260.dtsi                  |  90 ++++
 drivers/devfreq/Kconfig                            |   2 +
 drivers/devfreq/Makefile                           |   6 +-
 drivers/devfreq/devfreq-event.c                    | 510 +++++++++++++++++++++
 drivers/devfreq/event/Kconfig                      |  25 +
 drivers/devfreq/event/Makefile                     |   2 +
 drivers/devfreq/event/exynos-ppmu.c                | 397 ++++++++++++++++
 include/linux/devfreq-event.h                      | 189 ++++++++
 14 files changed, 1588 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
 create mode 100644 drivers/devfreq/devfreq-event.c
 create mode 100644 drivers/devfreq/event/Kconfig
 create mode 100644 drivers/devfreq/event/Makefile
 create mode 100644 drivers/devfreq/event/exynos-ppmu.c
 create mode 100644 include/linux/devfreq-event.h

-- 
1.8.5.5

