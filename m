Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbbALMfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:35:08 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12725 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbbALMfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:35:03 -0500
X-AuditID: cbfee691-f79b86d000004a5a-7b-54b3bf743a47
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv8 0/9] devfreq: Add devfreq-event class to provide raw data for
 devfreq device
Date: Mon, 12 Jan 2015 21:34:48 +0900
Message-id: <1421066097-26237-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWyRsSkSLdk/+YQg0efDSwer1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWq3b9YXQQ8Fgzbw2jx85Zd9k9Fu95yeSxaVUnm8fmJfUefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAlXFt42SmgrMWFfO+fmZrYPyh28XIySEhYCLx5tJTZghbTOLC
	vfVsXYxcHEICSxklHr6+yAhTNGPrE1YQW0hgEaNE61VTiKImJombvReZQBJsAloS+1/cYAOx
	RQT0JDqP7WEHsZkF/jBJNG1iAbGFBRIkPm3rBNvGIqAqcergYbAaXgFXiWmbX7FBLFOQWLZ8
	JivIAgmBU+wSXUs/skI0CEh8m3wIaBAHUEJWYtMBqKslJQ6uuMEygVFwASPDKkbR1ILkguKk
	9CJTveLE3OLSvHS95PzcTYzACDn979nEHYz3D1gfYhTgYFTi4bWQ2hwixJpYVlyZe4jRFGjD
	RGYp0eR8YBzmlcQbGpsZWZiamBobmVuaKYnz6kj/DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTB
	KdXAuFhNxHWawmdG/eLrU9t0TxnxBd30KBLX3x+lGf/Jce/L432ex2Q1uRcH8ti/NNkcpbh1
	lluHWoz5iT2v3slavz1+ufiVQFlfhHfOl4jJrhN1W7b2fX50buUH77lvtgmUWgvOi1puN+te
	7SmrP05Sj6zufGaoU5q7KzJORrLi0IYcxT6RRcLdSizFGYmGWsxFxYkAmqtxKosCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t9jAd2S/ZtDDDrXqlk8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtVu36w+gg4LFm3hpGj52z7rJ7LN7zkslj06pONo/NS+o9+rasYvT4
	vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+h4JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGtY2TmQrOWlTM+/qZ
	rYHxh24XIyeHhICJxIytT1ghbDGJC/fWs4HYQgKLGCVar5p2MXIB2U1MEjd7LzKBJNgEtCT2
	v7gBViQioCfReWwPO4jNLPCHSaJpEwuILSyQIPFpWycziM0ioCpx6uBhsBpeAVeJaZtfsUEs
	U5BYtnwm6wRG7gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxguPvmdQOxpUNFocYBTgY
	lXh4LaQ2hwixJpYVV+YeYpTgYFYS4XUtAwrxpiRWVqUW5ccXleakFh9iNAXaPpFZSjQ5H5ga
	8kriDY1NzIwsjcwNLYyMzZXEeZXs20KEBNITS1KzU1MLUotg+pg4OKUaGFPnPr49aVPt7KXX
	TbZyZ7z92iV67F9nlueUkr61NdrSHJ8ZM3jvnPi2Ki72XbplMTezx23mLg+PhWfs9bmu2V9M
	3+gWaNO09vgTZakMp3s+P84yqH8OaChIEZoSaaCcUp9y6mJy184Twfe9q1K+yfOGasYvNkxr
	Ktb5V9Blzn1U+/t/G5btSizFGYmGWsxFxYkA9aGZ6NUCAAA=
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

---------
Changelog:

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

Chanwoo Choi (9):
  devfreq: event: Add new devfreq_event class to provide basic data for devfreq governor
  devfreq: event: Add resource-managed function for devfreq-event device
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
 drivers/devfreq/devfreq-event.c                    | 511 +++++++++++++++++++++
 drivers/devfreq/event/Kconfig                      |  25 +
 drivers/devfreq/event/Makefile                     |   2 +
 drivers/devfreq/event/exynos-ppmu.c                | 398 ++++++++++++++++
 include/linux/devfreq-event.h                      | 186 ++++++++
 15 files changed, 1639 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
 create mode 100644 drivers/devfreq/devfreq-event.c
 create mode 100644 drivers/devfreq/event/Kconfig
 create mode 100644 drivers/devfreq/event/Makefile
 create mode 100644 drivers/devfreq/event/exynos-ppmu.c
 create mode 100644 include/linux/devfreq-event.h

-- 
1.8.5.5

