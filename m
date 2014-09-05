Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaIEEa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 00:30:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:35504 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaIEEaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 00:30:24 -0400
X-AuditID: cbfee68d-f79c46d000000b84-43-54093c5ec02e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, linux-pm@vger.kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        a.kesavan@samsung.com, kgene.kim@samsung.com, tomasz.figa@gmail.com,
        b.zolnierkie@samsung.com, nm@ti.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RFC PATCH 0/5] devfreq: Add devfreq-event class to provide raw data
 for devfreq device
Date: Fri, 05 Sep 2014 13:30:14 +0900
Message-id: <1409891419-28560-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWyRsSkWDfOhjPEoHkBu8XjNYuZLDbOWM9q
	cf3Lc1aL3gVX2SzONr1ht9j0+BqrxeVdc9gsPvceYbSYcX4fk8XtxhVsFm9+nGWyeLziLbvF
	ql1/GB14PXbOusvusXjPSyaPzUvqPfq2rGL0OH5jO5PH501yAWxRXDYpqTmZZalF+nYJXBl9
	x46wF0xWrHh24yNbA+MnqS5GTg4JAROJ/kuvWSBsMYkL99azgdhCAksZJV49zoap+bepiamL
	kQsoPp1R4vG+rSwQThOTRMvk04wgVWwCWhL7X9wA6xYRMJPYt+MvK0gRs8AOJolrB36AFQkL
	JEk0vOllBrFZBFQlPk4+xwRi8wq4SnRtXcMMsU5O4sOeR+wgzRICm9glJty4xw7RICDxbfIh
	oNUcQAlZiU0HoOolJQ6uuMEygVFwASPDKkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYzA4D/9
	71nvDsbbB6wPMQpwMCrx8C74zBEixJpYVlyZe4jRFGjDRGYp0eR8YIzllcQbGpsZWZiamBob
	mVuaKYnzKkr9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAeMi4xM1E4knOu//VxwynXQll
	tLEOeJiavetu2uv7/Y47+3Y2rLz1w+V16qfwfykWyYZuXhsnioh4Kuhel+PYxRUiVrNg2+Yb
	RU0Ci4+sKwu4vuGLuZjEztNzIyZFSW/gODDXX2d9mFyacnuj9Hku09Ybf5qXn/dbpjHLY5tz
	3avYo3Ym+89HKrEUZyQaajEXFScCAJX+GV15AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t9jQd1YG84QgysN1haP1yxmstg4Yz2r
	xfUvz1ktehdcZbM42/SG3WLT42usFpd3zWGz+Nx7hNFixvl9TBa3G1ewWbz5cZbJ4vGKt+wW
	q3b9YXTg9dg56y67x+I9L5k8Ni+p9+jbsorR4/iN7UwenzfJBbBFNTDaZKQmpqQWKaTmJeen
	ZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBdqqRQlphTChQKSCwuVtK3wzQh
	NMRN1wKmMULXNyQIrsfIAA0krGHM6Dt2hL1gsmLFsxsf2RoYP0l1MXJySAiYSPzb1MQEYYtJ
	XLi3nq2LkYtDSGA6o8TjfVtZIJwmJomWyacZQarYBLQk9r+4wQZiiwiYSezb8ZcVpIhZYAeT
	xLUDP8CKhAWSJBre9DKD2CwCqhIfJ58DW8Er4CrRtXUNM8Q6OYkPex6xT2DkXsDIsIpRNLUg
	uaA4KT3XSK84Mbe4NC9dLzk/dxMjOLqeSe9gXNVgcYhRgINRiYd3wWeOECHWxLLiytxDjBIc
	zEoivF5vgEK8KYmVValF+fFFpTmpxYcYTYG2T2SWEk3OB0Z+Xkm8obGJmZGlkbmhhZGxuZI4
	78FW60AhgfTEktTs1NSC1CKYPiYOTqkGRtUgA5bU48IGFb/q9It7ZyrOX5/ZqiRsPNXq/7HV
	GnIO3b/b31vEB/KzbLxw6sCkX4t4H626/k3UfYn5oraFTTzcPuktM9L0DsUseiE9p81GU7SG
	b0O7i1nGQuPfycF6x3MnlHskvSxvyrXWuene0XBe5J1Z/+XNQnyy7y3nd3Vr2qZbVlxVYinO
	SDTUYi4qTgQAA8BNtMQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add new devfreq_event class to provide raw data to determine
current utilization of device  which is used for devfreq governor.
But, This patchset is just initial version and must need more implementaion
and updates.

Although this patchset has not enough feature to support devfreq-event class,
I send this RFC patchset to share current implementation. Please feel free to
give comment and advice.

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

[For example]
If board dts includes PPMU_DMC0/DMC1/CPU event node,
would show following sysfs entry. Also devfreq driver(e.g., exynos4_bus.c)
can get the instance of devfreq-event device by using provided API and then
get raw data which reflect the current utilization of device.

-sh-3.2# pwd
/sys/class/devfreq_event
-sh-3.2# ls -al
total 0
drwxr-xr-x  2 root root 0 Jan  1 21:06 .
drwxr-xr-x 45 root root 0 Jan  1 21:06 ..
lrwxrwxrwx  1 root root 0 Jan  1 21:06 event.0 -> ../../devices/soc/106a0000.ppmu_dmc0/devfreq_event/event.0
lrwxrwxrwx  1 root root 0 Jan  1 21:06 event.1 -> ../../devices/soc/106b0000.ppmu_dmc1/devfreq_event/event.1
lrwxrwxrwx  1 root root 0 Jan  1 21:06 event.2 -> ../../devices/soc/106c0000.ppmu_cpu/devfreq_event/event.2

Chanwoo Choi (5):
  devfreq: Add new devfreq_event class to provide basic data for devfreq governor
  devfreq: event: Add exynos-ppmu devfreq evnet driver
  ARM: dts: Add PPMU dt node for Exynos3250
  ARM: dts: Add PPMU dt node for Exynos4 SoC
  ARM: dts: Add dt node fo PPMU_CPU/DMC0/DMC1 for exynos4412-trats2

 arch/arm/boot/dts/exynos3250.dtsi       |  66 +++++
 arch/arm/boot/dts/exynos4.dtsi          |  96 ++++++++
 arch/arm/boot/dts/exynos4210.dtsi       |   8 +
 arch/arm/boot/dts/exynos4412-trats2.dts |  29 +++
 drivers/devfreq/Kconfig                 |  12 +
 drivers/devfreq/Makefile                |   5 +-
 drivers/devfreq/devfreq-event.c         | 251 +++++++++++++++++++
 drivers/devfreq/event/Makefile          |   2 +
 drivers/devfreq/event/exynos-ppmu.c     | 410 ++++++++++++++++++++++++++++++++
 include/linux/devfreq.h                 |  97 ++++++++
 10 files changed, 975 insertions(+), 1 deletion(-)
 create mode 100644 drivers/devfreq/devfreq-event.c
 create mode 100644 drivers/devfreq/event/Makefile
 create mode 100644 drivers/devfreq/event/exynos-ppmu.c

-- 
1.8.0

