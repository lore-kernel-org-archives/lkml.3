Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbbAZERE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 23:17:04 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35520 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbbAZEQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 23:16:40 -0500
X-AuditID: cbfee68f-f791c6d000004834-42-54c5bfa4cf50
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        sangbae90.lee@samsung.com, inki.dae@samsung.com, cw00.choi@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v10 0/7] devfreq: Add devfreq-event class to provide raw data
 for devfreq device
Date: Mon, 26 Jan 2015 13:16:26 +0900
Message-id: <1422245793-8552-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkQHfp/qMhBgf+M1s8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtjn86yGKxatcfRgdBjzXz1jB67Jx1l91j8Z6XTB6bVnWyeWxeUu/R
	t2UVo8fnTXIB7FFcNimpOZllqUX6dglcGes7TjAVHLKvWPhJrIHxuXEXIyeHhICJxLxXx5kh
	bDGJC/fWs3UxcnEICSxllHi89hArTNGEjTtYIBLTGSV6n85lgnCamCReP5zDCFLFJqAlsf/F
	DTYQW0RAT6Lz2B52kCJmgenMEpMXTAQbJSyQJHGx8RRYA4uAqsTKX4vAGngFXCS2Tl7DDrFO
	QWLZ8pmsIM0SAtfYJf62N7BCNAhIfJt8COgODqCErMSmA1B3S0ocXHGDZQKj4AJGhlWMoqkF
	yQXFSelFxnrFibnFpXnpesn5uZsYgdFy+t+z/h2Mdw9YH2IU4GBU4uFtaD4aIsSaWFZcmXuI
	0RRow0RmKdHkfGBM5pXEGxqbGVmYmpgaG5lbmimJ8y6U+hksJJCeWJKanZpakFoUX1Sak1p8
	iJGJg1OqgZHnjsav/4JnNwf6N6+099r+0sbny52p+THRd9dUrnHfYq0leJvdWjdXbsPaomzr
	gMKLlWtTfmpJ732+SEecWXZD1R3bmUcuKtT0SWbvamxYre2ZO1uYb/OnWZFO3yKuTtq8ad2/
	WP6JnuoRaz+r3/+WmrVS/JWbzvwi+Y7Nfxv562wF59Uq5CmxFGckGmoxFxUnAgDL7Vi0kQIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t9jQd0l+4+GGExqMrN4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbHP90kMVi1a4/jA6CHmvmrWH02DnrLrvH4j0vmTw2repk89i8pN6j
	b8sqRo/Pm+QC2KMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVc
	fAJ03TJzgD5QUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGas7zjBVHDI
	vmLhJ7EGxufGXYycHBICJhITNu5ggbDFJC7cW8/WxcjFISQwnVGi9+lcJginiUni9cM5jCBV
	bAJaEvtf3GADsUUE9CQ6j+1hByliFpjOLDF5wURWkISwQJLExcZTYA0sAqoSK38tAmvgFXCR
	2Dp5DTvEOgWJZctnsk5g5F7AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgWn0nvYFzV
	YHGIUYCDUYmHV6PxaIgQa2JZcWXuIUYJDmYlEd7yKUAh3pTEyqrUovz4otKc1OJDjKZA2ycy
	S4km5wPTRF5JvKGxiZmRpZG5oYWRsbmSOK+SfVuIkEB6YklqdmpqQWoRTB8TB6dUA+PcI/1l
	b9msa1seOV27FTkt52bPhINRxa+uX1PVySv9k/772zUmw1kSYnsnBdetVVoX4KtzYY85wwmr
	wtNNVvz8D7SCyx04Vyx10Xv++MhD3lQN1sNz5MUiWeW69+/ZWiK64vtfntts/gc+rDnzgdv6
	gaSN8dSvFi11+n/W3Mj4d6aAI3j9qSVKLMUZiYZazEXFiQCRsR+82wIAAA==
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

Changes from v9:
(https://lkml.org/lkml/2015/1/20/68)
- Fix the operation of enable_count in devfreq_event_{enable|disable}_edev().

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
 drivers/devfreq/devfreq-event.c                    | 494 +++++++++++++++++++++
 drivers/devfreq/event/Kconfig                      |  25 ++
 drivers/devfreq/event/Makefile                     |   2 +
 drivers/devfreq/event/exynos-ppmu.c                | 374 ++++++++++++++++
 drivers/devfreq/event/exynos-ppmu.h                |  93 ++++
 include/linux/devfreq-event.h                      | 196 ++++++++
 15 files changed, 1611 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
 create mode 100644 drivers/devfreq/devfreq-event.c
 create mode 100644 drivers/devfreq/event/Kconfig
 create mode 100644 drivers/devfreq/event/Makefile
 create mode 100644 drivers/devfreq/event/exynos-ppmu.c
 create mode 100644 drivers/devfreq/event/exynos-ppmu.h
 create mode 100644 include/linux/devfreq-event.h

-- 
1.8.5.5

