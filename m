Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaLPX1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:27:12 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:19994 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaLPX1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:27:04 -0500
X-AuditID: cbfee68e-f79b46d000002b74-ae-5490bfc5e295
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv4 0/8] devfreq: Add devfreq-event class to provide raw data for
 devfreq device
Date: Wed, 17 Dec 2014 08:26:49 +0900
Message-id: <1418772417-5164-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWyRsSkQPfo/gkhBp2beCwer1nMZHH9y3NW
	i/lHzrFaTLo/gcXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bF5S79G3ZRWjx+dNcgFsUVw2Kak5
	mWWpRfp2CVwZ3+fPZCo4aV1x5/Ab1gbGlQZdjJwcEgImEvOPLmSBsMUkLtxbz9bFyMUhJLCU
	UaJ7/g4WmKJt+x5CJRYxSuxd9JQdwmlikujvncsMUsUmoCWx/8UNNhBbREBG4urG7SwgRcwC
	jcwSX5b9ZwJJCAskSDRu3g1WxCKgKvFj4kTGLkYODl4BF4m+XluIbQoSy5bPZAXplRA4xC6x
	a8luZoh6AYlvkw+xgNRLCMhKbDrADFEvKXFwxQ2WCYyCCxgZVjGKphYkFxQnpRcZ6RUn5haX
	5qXrJefnbmIExsPpf8/6djDePGB9iFGAg1GJhzewsD9EiDWxrLgy9xCjKdCGicxSosn5wKjL
	K4k3NDYzsjA1MTU2Mrc0UxLnTZD6GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBkeulxE21
	jynlDxWc7A4Wh1ycL+fYnfvhJ7+zf9Avr3PT2ZdFzHoYY/o3LrHqyqbFa79sdvymXSTrJ9Zv
	tuTq/1+xIe3clt+8V+1tiSq8u29RuJ3MtqK/zKLtl82spN7JHrn41WyLva/dsvfOnZkJi/qv
	vjY6uHFyfXDuhBUKxdZbuv5/DJv8XYmlOCPRUIu5qDgRAGjYkaKCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAd2j+yeEGPQWWzxes5jJ4vqX56wW
	84+cY7WYdH8Ci8XrF4YWvQuuslmcbXrDbrHp8TVWi8u75rBZfO49wmgx4/w+Joul1y8yWdxu
	XMFm8XjFW3aLVbv+MDrwe6yZt4bRY+esu+wei/e8ZPLYvKTeo2/LKkaPz5vkAtiiGhhtMlIT
	U1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AuVlIoS8wpBQoF
	JBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmfJ8/k6ngpHXFncNvWBsYVxp0MXJySAiY
	SGzb95ANwhaTuHBvPZDNxSEksIhRYu+ip+wQThOTRH/vXGaQKjYBLYn9L26AdYgIyEhc3bid
	BaSIWaCRWeLLsv9MIAlhgQSJxs27wYpYBFQlfkycyNjFyMHBK+Ai0ddrC7FNQWLZ8pmsExi5
	FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjrVn0jsYVzVYHGIU4GBU4uENLOwPEWJN
	LCuuzD3EKMHBrCTCa7FoQogQb0piZVVqUX58UWlOavEhRlOg5ROZpUST84FpIK8k3tDYxMzI
	0sjc0MLI2FxJnFfJvi1ESCA9sSQ1OzW1ILUIpo+Jg1OqgXFTL19azI63Wy8YP7xaJpTNodo3
	OaRFzeD4i6DbH24cLlXRP1i5/bBr7NKF/65fmn8owq3iU9dy21NzbzHXXXBYKtE4eev+gnDP
	p/9vH3CvStz48FJumIdrstGsVdYvuyZaWMqtWjgrSX7H19h+Vsatx7ae2Fn/OcLeQepQXvMN
	q9uqUXendogrsRRnJBpqMRcVJwIA3fpNV8sCAAA=
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

Chanwoo Choi (8):
  devfreq: event: Add new devfreq_event class to provide basic data for devfreq governor
  devfreq: event: Add the list of supported devfreq-event type
  devfreq: event: Add exynos-ppmu devfreq event driver
  devfreq: event: Add documentation for exynos-ppmu devfreq-event driver
  ARM: dts: Add PPMU dt node for Exynos3250 SoC
  ARM: dts: Add PPMU dt node for Exynos4 SoCs
  ARM: dts: Add PPMU dt node for Exynos5260 SoC
  ARM: dts: exynos: Add PPMU dt node to Exynos3250-based Rinato board

 .../bindings/devfreq/event/exynos-ppmu.txt         | 110 +++++
 arch/arm/boot/dts/exynos3250-rinato.dts            |  40 ++
 arch/arm/boot/dts/exynos3250.dtsi                  |  72 +++
 arch/arm/boot/dts/exynos4.dtsi                     | 108 +++++
 arch/arm/boot/dts/exynos4210.dtsi                  |   8 +
 arch/arm/boot/dts/exynos5260.dtsi                  |  90 ++++
 drivers/devfreq/Kconfig                            |  11 +
 drivers/devfreq/Makefile                           |   5 +-
 drivers/devfreq/devfreq-event.c                    | 493 +++++++++++++++++++++
 drivers/devfreq/event/Makefile                     |   2 +
 drivers/devfreq/event/exynos-ppmu.c                | 397 +++++++++++++++++
 include/linux/devfreq.h                            | 179 ++++++++
 12 files changed, 1514 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
 create mode 100644 drivers/devfreq/devfreq-event.c
 create mode 100644 drivers/devfreq/event/Makefile
 create mode 100644 drivers/devfreq/event/exynos-ppmu.c

-- 
1.8.5.5

