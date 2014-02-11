Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaBKNER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:04:17 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32478 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaBKNEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:04:14 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-18-52fa1fcb6f99
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 00/14] mfd/regulator/rtc: sec: Add support for S2MPS14
Date: Tue, 11 Feb 2014 14:03:43 +0100
Message-id: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJMWRmVeSWpSXmKPExsVy+t/xK7qn5X8FGXzabGyxccZ6VovXLwwt
	zja9Ybe4//Uoo8XlXXPYLGac38dksfbIXXaL092sFhdXfGFy4PS4c20Pm8e8k4EefVtWMXp8
	3iQXwBLFZZOSmpNZllqkb5fAlTFn4zqmggtiFW+++TUwzhHsYuTkkBAwkbi38hsjhC0mceHe
	erYuRi4OIYGljBJvWraxQDh9TBLzVkxnBqliEzCW2Lx8CViViMBmRonF36+ygjjMAkcZJab3
	vmUCqRIWcJM4/3MiK4jNIqAqsfL2ITCbFyj+fOk7oLEcQPsUJOZMspnAyL2AkWEVo2hqaXJB
	cVJ6rpFecWJucWleul5yfu4mRkiofN3BuPSY1SFGAQ5GJR5eja8/goRYE8uKK3MPMUpwMCuJ
	8H4R/hUkxJuSWFmVWpQfX1Sak1p8iJGJg1OqgVFNPTFbLLz5Z/UHnlWM//ukzf/yqRbclNz0
	yPlj2XYRm2fOf1bIrv2+Jrvc8GuX8ufLsSozfi2XPpI6RWLu/J+fth5ctCA+0VtG8vjJBdY5
	MytWny9oTpDcUvbdlF1oc88E9Yb0eRWLKhsOeKXYPdVr+CX78dLVZXoB9X88F5fH/J5TJ3+g
	gVeJpTgj0VCLuag4EQD88KIJ8wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This patchset adds support for S2MPS14 device to the Samsung MFD driver family.

The S2MPS14 is similar to S2MPS11 but it has fewer regulators, two
clocks instead of three and a little different registers layout.

The patchset is organized in following way:
1. Patches from 1 to 7 clean up the S2MPS1X/S5M876X drivers and prepare
   for adding S2MPS14 support (some symbol renaming is needed).
2. Patches from 8 to 10 add support for S2MPS14 to the MFD and regulator
   drivers. They depend on previous patches.
3. Patches 11 and 12 add opmode support for S2MPS14 regulator driver.
4. Patches 13 and 14 add support for S2MPS14 RTC and they depend on previous
   MFD and RTC patches.

Probably the best way to get everything working and merged into the linux-next
would be to obtain ACK-s from all maintainers and to put all the patches into
the mfd-next tree.


The patchset is based on linux-next: next-20140211 *with* today's patch:
mfd: sec-core: Fix possible NULL pointer dereference when i2c_new_dummy error


TODO
====
Add support for S2MPS14 to the S2MPS11 clock driver. The patch
is actually ready but it is based on the "Add support for clocks in S5M8767"
   http://thread.gmane.org/gmane.linux.kernel/1587881/focus=1587882
which didn't get their way into clk-next. I will wait for them.


Krzysztof Kozlowski (14):
  mfd: sec: Add maximum RTC register for regmap config
  mfd: sec: Select different RTC regmaps for devices
  mfd/rtc: sec/sec: Rename SEC* symbols to S5M
  rtc: s5m: Remove undocumented time init on first boot
  mfd: sec: Use consistent S2MPS11 RTC alarm interrupt indexes
  regulator: s2mps11: Constify regulator_desc array
  regulator: s2mps11: Choose number of supported regulators during
    probe
  mfd: sec: Add support for S2MPS14
  regulator: s2mps11: Add support for S2MPS14 regulators
  Documentation: mfd: s2mps11: Document support for S2MPS14
  regulator: s2mps11: Add opmode for S2MPS14 regulators
  Documentation: mfd/regulator: s2mps11: Document the "op_mode"
    bindings
  rtc: s5m: Support different register layout
  rtc: s5m: Add support for S2MPS14 RTC

 Documentation/devicetree/bindings/mfd/s2mps11.txt |   58 ++-
 drivers/mfd/sec-core.c                            |   57 ++-
 drivers/mfd/sec-irq.c                             |   97 ++++-
 drivers/regulator/s2mps11.c                       |  393 +++++++++++++++++----
 drivers/rtc/rtc-s5m.c                             |  284 ++++++++++-----
 include/linux/mfd/samsung/core.h                  |    1 +
 include/linux/mfd/samsung/irq.h                   |   31 +-
 include/linux/mfd/samsung/rtc.h                   |  132 ++++---
 include/linux/mfd/samsung/s2mps14.h               |  169 +++++++++
 9 files changed, 1000 insertions(+), 222 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mps14.h

-- 
1.7.9.5

