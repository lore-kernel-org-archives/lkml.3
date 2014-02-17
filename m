Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaBQIkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:40:43 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44828 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaBQIkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:40:39 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-26-5301cb057824
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 00/13] mfd/regulator/rtc: sec: Add support for S2MPS14
Date: Mon, 17 Feb 2014 09:40:14 +0100
Message-id: <1392626427-4518-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJJMWRmVeSWpSXmKPExsVy+t/xK7qspxmDDea+FbfYOGM9q8XrF4YW
	Z5vesFvc/3qU0eLyrjlsFjPO72OyWHvkLrvF6W5Wi4srvjBZrJ/xmsVizvR3TA7cHneu7WHz
	mHcy0KNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy3nwwKrgpU3Hr1WSWBsY+sS5GTg4JAROJ
	xk2bGSFsMYkL99azdTFycQgJLGWUeLHyEDuE08ckcefqAWaQKjYBY4nNy5eAVYkIbGaUWPz9
	KiuIwywwk0niz80HTF2MHBzCAp4S09tCQRpYBFQlJpz8CbaCV8BN4tXzXnaQEgkBBYk5k2wm
	MHIvYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESPF92MC4+ZnWIUYCDUYmH16CaMViI
	NbGsuDL3EKMEB7OSCK/tOqAQb0piZVVqUX58UWlOavEhRiYOTqkGxjb5psQgDqG9OS7N7yWl
	uLbPupuye2Kt0Bu+qK8HmYPFrj/3d1vI90M9pMvvToLT4+KrAfxNQZ9zmeeclKuctb/7uKXf
	tk2Smziz5t4ykqmufzw1/m7+WnfGFY8/r92ZyLFnvc/5dke31/Ncu94/1Fecl7ic1/Hbrsfp
	chvtCkUmc36d/3/VZyWW4oxEQy3mouJEAJ6xIQz8AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is third version of patchset adding support for S2MPS14 device to the
Samsung MFD driver family.


Changes since v2
================
1. Added ack-s and reviews (Lee Jones, Tomasz Figa, Yadwinder Singh Brar).
2. Applied suggestions from review (Mark Brown).
3. Added patch 6/13:
   regulator: s2mps11: Don't store registered regulators in state container
4. Dropped two patches adding opmode (regulator: s2mps11: Add opmode for
   S2MPS14 regulators).
5. Rebased on current next (next-20140217).


Changes since v1
================
1. Added Lee Jones' ACK-s.
2. Applied suggestions from review (Lee Jones).
3. Regulator: added __initconst to regulator_desc array (Yadwinder Singh Brar).
   This replaces the patch 7/15:
   "regulator: s2mps11: Choose number of supported regulators during probe"
   with:
   "regulator: s2mps11: Copy supported regulators from initconst"


Description
===========

The S2MPS14 is similar to S2MPS11 but it has fewer regulators, two
clocks instead of three and a little different registers layout.

The patchset is organized in following way:
1. Patches from 1 to 8 clean up the S2MPS1X/S5M876X drivers and prepare
   for adding S2MPS14 support (some symbol renaming is needed).
2. Patches from 9 to 11 add support for S2MPS14 to the MFD and regulator
   drivers. They depend on previous patches.
4. Patches 12 and 13 add support for S2MPS14 RTC and they depend on previous
   MFD and RTC patches.

Probably the best way to get everything working and merged into the linux-next
would be to obtain ACK-s from all maintainers and to put all the patches into
the mfd-next tree.


The patchset is based on linux-next: next-20140217 *with* patch:
mfd: sec-core: Fix possible NULL pointer dereference when i2c_new_dummy error


TODO
====
1. Add support for S2MPS14 to the S2MPS11 clock driver. The patch is actually
   ready but it is based on the "Add support for clocks in S5M8767"
      http://thread.gmane.org/gmane.linux.kernel/1587881/focus=1587882
   which didn't get their way into clk-next. I will wait for them.
2. Add external GPIO control (ena_gpio) to regulator driver.


Krzysztof Kozlowski (13):
  mfd: sec: Add maximum RTC register for regmap config
  mfd: sec: Select different RTC regmaps for devices
  mfd/rtc: sec/s5m: Rename SEC* symbols to S5M
  rtc: s5m: Remove undocumented time init on first boot
  mfd: sec: Use consistent S2MPS11 RTC alarm interrupt indexes
  regulator: s2mps11: Don't store registered regulators in state
    container
  regulator: s2mps11: Constify regulator_desc array
  regulator: s2mps11: Copy supported regulators from initconst
  mfd: sec: Add support for S2MPS14
  regulator: s2mps11: Add support for S2MPS14 regulators
  Documentation: mfd: s2mps11: Document support for S2MPS14
  rtc: s5m: Support different register layout
  rtc: s5m: Add support for S2MPS14 RTC

 Documentation/devicetree/bindings/mfd/s2mps11.txt |   12 +-
 drivers/mfd/sec-core.c                            |   57 +++-
 drivers/mfd/sec-irq.c                             |   97 +++++-
 drivers/regulator/s2mps11.c                       |  337 ++++++++++++++++-----
 drivers/rtc/rtc-s5m.c                             |  284 +++++++++++------
 include/linux/mfd/samsung/core.h                  |    1 +
 include/linux/mfd/samsung/irq.h                   |   31 +-
 include/linux/mfd/samsung/rtc.h                   |  132 +++++---
 include/linux/mfd/samsung/s2mps14.h               |  152 ++++++++++
 9 files changed, 873 insertions(+), 230 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mps14.h

-- 
1.7.9.5

