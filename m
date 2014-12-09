Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbaLIONT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:13:19 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26705 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbaLIONK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:13:10 -0500
X-AuditID: cbfee68d-f79296d000004278-05-54870373752a
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, kgene.kim@samsung.com,
        rafael.j.wysocki@intel.com, a.kesavan@samsung.com,
        tomasz.figa@gmail.com, b.zolnierkie@samsung.com,
        k.kozlowski@samsung.com, cw00.choi@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv2 0/7] devfreq: Add devfreq-event class to provide raw data
 for devfreq device
Date: Tue, 09 Dec 2014 23:12:59 +0900
Message-id: <1418134386-14681-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRsSkWLeYuT3E4MtXK4vHaxYzWWycsZ7V
	4vqX56wW84+cY7V4/cLQonfBVTaLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Rxu3EFm8Xj
	FW/ZLVbt+sPowOexc9Zddo/Fe14yeWxeUu/Rt2UVo8fnTXIBrFFcNimpOZllqUX6dglcGfce
	pBZc1qlY8esYcwPjPZUuRk4OCQETiQ9HbjFD2GISF+6tZ+ti5OIQEljKKHFw6n02mKLDE38z
	QSQWASVeLGeBcJqYJNbPb2UHqWIT0JLY/+IGWIeIgJXE6f8dzCBFzALnmSSWLNwPtkNYIEVi
	+oudYDaLgKrExQ3rmUBsXgFXiZlzr0LdoSCxbPlMVpBmCYF17BJXJm1ihGgQkPg2+RDQag6g
	hKzEpgNQ9ZISB1fcYJnAKLiAkWEVo2hqQXJBcVJ6kaFecWJucWleul5yfu4mRmDon/73rHcH
	4+0D1ocYBTgYlXh4NSzbQoRYE8uKK3MPMZoCbZjILCWanA+MsLySeENjMyMLUxNTYyNzSzMl
	cV5FqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgZDwSKW3AExDQ8YihbMJl1jctu3v6p
	tzaf3Lm0tuOA3VZWtm1FTPteeW0WrSuY69V+bavOB5uCeN7yw7ciJj4Qe/jmTcnbmG/eEZy7
	eL04GwreHvXfkqb+ss1nx5VSTpufNZemxFxbcrdXo+aqaNLJGYfPafsJRl48VyOQ2W+x6e2s
	Ro3oKx+VWIozEg21mIuKEwGKuwiZeAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t9jAd1i5vYQg+ZfBhaP1yxmstg4Yz2r
	xfUvz1kt5h85x2rx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8niduMKNovH
	K96yW6za9YfRgc9j56y77B6L97xk8ti8pN6jb8sqRo/Pm+QCWKMaGG0yUhNTUosUUvOS81My
	89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgA5VUihLzCkFCgUkFhcr6dthmhAa
	4qZrAdMYoesbEgTXY2SABhLWMGbce5BacFmnYsWvY8wNjPdUuhg5OSQETCQOT/zNBGGLSVy4
	t56ti5GLQ0hgEaPEwRfLWSCcJiaJ9fNb2UGq2AS0JPa/uMEGYosIWEmc/t/BDFLELHCeSWLJ
	wv3MIAlhgRSJ6S92gtksAqoSFzesB1vBK+AqMXPuVWaIdQoSy5bPZJ3AyL2AkWEVo2hqQXJB
	cVJ6rqFecWJucWleul5yfu4mRnBkPZPawbiyweIQowAHoxIPr6ZlW4gQa2JZcWXuIUYJDmYl
	Ed4pR4FCvCmJlVWpRfnxRaU5qcWHGE2Btk9klhJNzgdGfV5JvKGxiZmRpZG5oYWRsbmSOK+S
	PVCTQHpiSWp2ampBahFMHxMHp1QD48blTIskD3l/zZZZpbR5uXOuqbhI3PlJ5hWxx74mhZft
	32ss8at7lcPMSlmVMgm1oGTRY7eur1Vu+1xtfyiuesXRY62LA7h9zS5H73zRPO393pSOCZu9
	vXpLzp6tO26TFGnL0acncLLmoZbimyu9m/4sYvQycNzIl7H9yGtlBvMFBjuDu3N7lFiKMxIN
	tZiLihMBFzkmesICAAA=
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
If board dts includes PPMU_DMC0/DMC1/CPU event node,
would show following sysfs entry. Also devfreq driver(e.g., exynos4_bus.c)
can get the instance of devfreq-event device by using provided API and then
get raw data which reflect the current state of device.

-sh-3.2# pwd
/sys/class/devfreq_event
-sh-3.2# ls -al
total 0
drwxr-xr-x  2 root root 0 Jan  7 11:10 .
drwxr-xr-x 37 root root 0 Jan  7 11:10 ..
lrwxrwxrwx  1 root root 0 Jan  7 11:10 event.0 -> ../../devices/soc/106a0000.ppmu_dmc0/devfreq_event/event.0
lrwxrwxrwx  1 root root 0 Jan  7 11:10 event.1 -> ../../devices/soc/106a0000.ppmu_dmc0/devfreq_event/event.1
lrwxrwxrwx  1 root root 0 Jan  7 11:10 event.2 -> ../../devices/soc/106a0000.ppmu_dmc0/devfreq_event/event.2
lrwxrwxrwx  1 root root 0 Jan  7 11:10 event.3 -> ../../devices/soc/106a0000.ppmu_dmc0/devfreq_event/event.3
lrwxrwxrwx  1 root root 0 Jan  7 11:10 event.4 -> ../../devices/soc/106b0000.ppmu_dmc1/devfreq_event/event.4
lrwxrwxrwx  1 root root 0 Jan  7 11:10 event.5 -> ../../devices/soc/106c0000.ppmu_cpu/devfreq_event/event.5
lrwxrwxrwx  1 root root 0 Jan  7 11:10 event.6 -> ../../devices/soc/106c0000.ppmu_cpu/devfreq_event/event.6
lrwxrwxrwx  1 root root 0 Jan  7 11:10 event.7 -> ../../devices/soc/106c0000.ppmu_cpu/devfreq_event/event.7
lrwxrwxrwx  1 root root 0 Jan  7 11:10 event.8 -> ../../devices/soc/106c0000.ppmu_cpu/devfreq_event/event.8

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
  devfreq: event: Add the exclusive flag for devfreq-event device
  devfreq: event: Add exynos-ppmu devfreq event driver
  ARM: dts: Add PPMU dt node for Exynos3250
  ARM: dts: Add PPMU dt node for Exynos4 SoC
  ARM: dts: exynos: Add PPMU dt node to Exynos3250-based Rinato board

 arch/arm/boot/dts/exynos3250-rinato.dts |  55 +++++
 arch/arm/boot/dts/exynos3250.dtsi       |  66 ++++++
 arch/arm/boot/dts/exynos4.dtsi          |  96 ++++++++
 arch/arm/boot/dts/exynos4210.dtsi       |   8 +
 drivers/devfreq/Kconfig                 |  11 +
 drivers/devfreq/Makefile                |   5 +-
 drivers/devfreq/devfreq-event.c         | 363 ++++++++++++++++++++++++++++
 drivers/devfreq/event/Makefile          |   2 +
 drivers/devfreq/event/exynos-ppmu.c     | 409 ++++++++++++++++++++++++++++++++
 include/linux/devfreq.h                 | 178 ++++++++++++++
 10 files changed, 1192 insertions(+), 1 deletion(-)
 create mode 100644 drivers/devfreq/devfreq-event.c
 create mode 100644 drivers/devfreq/event/Makefile
 create mode 100644 drivers/devfreq/event/exynos-ppmu.c

-- 
1.8.5.5

