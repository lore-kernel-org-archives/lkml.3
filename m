Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbbATHK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:10:28 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:25907 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbbATHKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:10:17 -0500
X-AuditID: cbfee691-f79b86d000004a5a-de-54bdff5640aa
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v9 0/7] devfreq: Add devfreq-event class to provide raw data
 for devfreq device
Date: Tue, 20 Jan 2015 16:10:02 +0900
Message-id: <1421737809-4010-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWyRsSkRDfs/94Qg03nuS0er1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWq3b9YXQQ8Fgzbw2jx85Zd9k9Fu95yeSxaVUnm8fmJfUefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAldH8cCJTwU67iv/rkxoY3xt1MXJySAiYSFw/eIUNwhaTuHBv
	PZDNxSEksJRRYmbTHSaYotYPN1hAbCGBRYwS3W+4IYqamCR6frxlBEmwCWhJ7H9xA2ySiICe
	ROexPewgNrPAHyaJpk1gzcICiRJTJ00Cq2cRUJXoeHEdrIZXwEXi7+4NUFcoSCxbPpMVZIGE
	wDF2iecrdrJBNAhIfJt8CGgQB1BCVmLTAWaIekmJgytusExgFFzAyLCKUTS1ILmgOCm9yFSv
	ODG3uDQvXS85P3cTIzA+Tv97NnEH4/0D1ocYBTgYlXh4X6zaGyLEmlhWXJl7iNEUaMNEZinR
	5HxgFOaVxBsamxlZmJqYGhuZW5opifPqSP8MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAY
	0rzTNIb/UOO5TI1rs/5/XR6z/uPm6LZbv3/N2PCrZ57YatfYg1PUbLd4tz//87JrcfDV/8ri
	HHeUBQ85iq9ULFIrWjb944OvhyyPed3KqJ545z9jdurtiTtrXXy69rZ+vcWV9V7S4X71Ec57
	prPnO7jXWmywv9T+ZZuOg8CxaX/uxkUtV15WpsRSnJFoqMVcVJwIAAnhlRmKAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t9jAd3Q/3tDDFq/2lg8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtVu36w+gg4LFm3hpGj52z7rJ7LN7zkslj06pONo/NS+o9+rasYvT4
	vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+h4JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWNG88OJTAU77Sr+r09q
	YHxv1MXIySEhYCLR+uEGC4QtJnHh3no2EFtIYBGjRPcb7i5GLiC7iUmi58dbRpAEm4CWxP4X
	N8CKRAT0JDqP7WEHsZkF/jBJNG0CGyQskCgxddIksHoWAVWJjhfXwWp4BVwk/u7ewAaxTEFi
	2fKZrBMYuRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI6+Z1I7GFc2WBxiFOBgVOLh
	dVi7N0SINbGsuDL3EKMEB7OSCO+Ep0Ah3pTEyqrUovz4otKc1OJDjKZA2ycyS4km5wMTQ15J
	vKGxiZmRpZG5oYWRsbmSOK+SfVuIkEB6YklqdmpqQWoRTB8TB6dUA2NKzZUpQSfTNvVLBKWs
	cuepnmmlv63bwfOYvojs0aitB/eq+3c8nHK4cKvkF6UrvJk3Z6w5YH31qU/Kt/T2LvGG3ZeT
	xI5zBLywnbawICWoLVyc9Q6nX7+ZzBLZurufrnVlKjorlQQs/8/zht08kafw6O5nbYvjZzO/
	2MuzWU1D4lBfSswzVyWW4oxEQy3mouJEAAkE5ZbUAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add new devfreq_event class to provide raw data to determine
current utilization of device  which is used for devfreq governor.

The following description explains the feature of two kind of devfreq class:
- devfreq class (existing)
 : devfreq consumer device use raw data from devfreq_event device for
   determining proper current system state and change voltage/frequency
   dynamically using various governors.
- devfreq_event class (new)
 : Provide measured raw data to devfreq device for governor

Changelog:

Changes from v8:
(https://lkml.org/lkml/2015/1/12/299)
- Fix issue of devfreq-event.c driver by Myunjoo's comment
  : Merge patch2 (resource-managed function) with patch1
  : Fix bug in devfreq_event_{enable|disable}_edev() about enable_count operation
  : Simplify error checking code in devfreq_event_get_event()
  : Define devfreq_event_get_drvdata() as static inline function type
  : Reduce the time of critical section scope in devfreq_event_remove_edev()
  : Rename field name of devfreq_event_data structure
    (total_event / event -> total_count / load_count)
- Drop following patch[1] because Exynos5260 cannot be tested for exynos-ppmu.c driver
  [1] [PATCHv8 7/9] ARM: dts: Add PPMU dt node for Exynos5260 SoC
      - https://lkml.org/lkml/2015/1/12/301
- Clean-up exynos-ppmu.c without update

Changes from v7:
(https://lkml.org/lkml/2015/1/7/795)
- Use EXPORT_SYMBOL_GPL macro instead of EXPORT_SYMBOL
- Fix the binding document of exynos-ppmu.c driver
- Drop the devfreq-event type patch because it isnt' clear
- Fix bug of devfreq_event_add_edev() when fail to execute device_register()
- Modify resource free operation on following functions:
  : devfreq_event_remove_edev()
  : devfreq_event_release_edev()

Changes from v6:
(https://lkml.org/lkml/2014/12/28/139)
- This patchset is based on v3.19-rc3.
1. devfreq-event class driver
- Fix build break if devfreq-event framework is off
- Add resource-managed function for devfreq-event device
: devm_devfreq_event_add_edev()
: devm_devfreq_event_remove_edev()

Changes from v5:
(https://lkml.org/lkml/2014/12/22/527)
- Rebase these patch-set on v3.19-rc1 and Test it.
1. exynos-ppmu.c
- Change the error value when of_iomap() fail to map the memory
- Remove owner setting of platform_driver
- Add exynos_ppmu_disable() function
2. exynos dts file
- Add PPMU node to Exynos3250-based Monk board
- Remove ppmu_cpu node on Exynos4412-based TRATS2 board and add ppmu_leftbus/rightbus node

Changes from v4:
(https://lkml.org/lkml/2014/12/16/511)
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
(https://lkml.org/lkml/2014/12/12/219)
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
(https://lkml.org/lkml/2014/12/9/304)
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
(https://lkml.org/lkml/2014/9/5/11)
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
  devfreq: event: Add exynos-ppmu devfreq-event driver
  devfreq: event: Add documentation for exynos-ppmu devfreq-event driver
  ARM: dts: Add PPMU dt node for Exynos3250 SoC
  ARM: dts: Add PPMU dt node for Exynos4 SoCs
  ARM: dts: exynos: Add PPMU node for Exynos3250-based Rinato/Monk board
  ARM: dts: exynos: Add PPMU node for Exynos4412-based TRATS2 board

 .../bindings/devfreq/event/exynos-ppmu.txt         | 110 +++++
 arch/arm/boot/dts/exynos3250-monk.dts              |  40 ++
 arch/arm/boot/dts/exynos3250-rinato.dts            |  40 ++
 arch/arm/boot/dts/exynos3250.dtsi                  |  74 +++
 arch/arm/boot/dts/exynos4.dtsi                     | 108 +++++
 arch/arm/boot/dts/exynos4210.dtsi                  |   8 +
 arch/arm/boot/dts/exynos4412-trats2.dts            |  40 ++
 drivers/devfreq/Kconfig                            |   2 +
 drivers/devfreq/Makefile                           |   6 +-
 drivers/devfreq/devfreq-event.c                    | 498 +++++++++++++++++++++
 drivers/devfreq/event/Kconfig                      |  25 ++
 drivers/devfreq/event/Makefile                     |   2 +
 drivers/devfreq/event/exynos-ppmu.c                | 374 ++++++++++++++++
 drivers/devfreq/event/exynos-ppmu.h                |  93 ++++
 include/linux/devfreq-event.h                      | 196 ++++++++
 15 files changed, 1615 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
 create mode 100644 drivers/devfreq/devfreq-event.c
 create mode 100644 drivers/devfreq/event/Kconfig
 create mode 100644 drivers/devfreq/event/Makefile
 create mode 100644 drivers/devfreq/event/exynos-ppmu.c
 create mode 100644 drivers/devfreq/event/exynos-ppmu.h
 create mode 100644 include/linux/devfreq-event.h

-- 
1.8.5.5

