Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaBMJOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:14:35 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59567 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaBMJOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:14:23 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-b8-52fc8cedfba7
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 00/14] mfd/regulator/rtc: sec: Add support for S2MPS14
Date: Thu, 13 Feb 2014 10:13:53 +0100
Message-id: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t/xy7pve/4EGex+pGmxccZ6VovXLwwt
	zja9Ybe4//Uoo8XlXXPYLGac38dksfbIXXaL092sFhdXfGFy4PS4c20Pm8e8k4EefVtWMXp8
	3iQXwBLFZZOSmpNZllqkb5fAlfHw+TO2gq1SFTOub2RsYFwh0sXIySEhYCLx7t5MZghbTOLC
	vfVsXYxcHEICSxklfn27zA7h9DFJ7Fk4iRGkik3AWGLz8iVgVSICmxklFn+/ygriMAscZZSY
	3vuWCaRKWMBT4vuBu6wgNouAqsTh1uNg3bwC7hIXlq5k6WLkANqnIDFnks0ERu4FjAyrGEVT
	S5MLipPSc430ihNzi0vz0vWS83M3MUKC5esOxqXHrA4xCnAwKvHwPlj8O0iINbGsuDL3EKME
	B7OSCK+MxJ8gId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYwKR943HTQX7Pygpbdxu2H+H6vORT8W
	VIVbaDLX3/L9pXAsKUc5N1+7ac+hi/18TOVqTjY62vX22kYCIpJyFYrhvOo3byXJsqw+GsuS
	cKJcOKP86Jt+1ZN5QvzrDij+P1S3+Lm59vt838st6zI0+8o895r1/e1Jfqh0+l8a77xrQhn7
	r7REK7EUZyQaajEXFScCAGsGsS30AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is second version of patchset adding support for S2MPS14 device to the
Samsung MFD driver family.


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


The patchset is based on linux-next: next-20140211 *with* patch:
mfd: sec-core: Fix possible NULL pointer dereference when i2c_new_dummy error


TODO
====
Add support for S2MPS14 to the S2MPS11 clock driver. The patch
is actually ready but it is based on the "Add support for clocks in S5M8767"
   http://thread.gmane.org/gmane.linux.kernel/1587881/focus=1587882
which didn't get their way into clk-next. I will wait for them.


Krzysztof Kozlowski (15):
  mfd: sec: Add maximum RTC register for regmap config
  mfd: sec: Select different RTC regmaps for devices
  mfd/rtc: sec/sec: Rename SEC* symbols to S5M
  rtc: s5m: Remove undocumented time init on first boot
  mfd: sec: Use consistent S2MPS11 RTC alarm interrupt indexes
  regulator: s2mps11: Constify regulator_desc array
  regulator: s2mps11: Copy supported regulators from initconst
  mfd: sec: Add support for S2MPS14
  regulator: s2mps11: Add support for S2MPS14 regulators
  Documentation: mfd: s2mps11: Document support for S2MPS14
  regulator: s2mps11: Add opmode for S2MPS14 regulators
  Documentation: mfd/regulator: s2mps11: Document the "op_mode"
    bindings
  rtc: s5m: Support different register layout
  rtc: s5m: Add support for S2MPS14 RTC
  Documentation: mfd: s2mps11: Describe S5M8767 and S2MPS14 clocks

 Documentation/devicetree/bindings/mfd/s2mps11.txt |   82 +++-
 drivers/mfd/sec-core.c                            |   57 ++-
 drivers/mfd/sec-irq.c                             |   97 ++++-
 drivers/regulator/s2mps11.c                       |  421 +++++++++++++++++----
 drivers/rtc/rtc-s5m.c                             |  284 +++++++++-----
 include/linux/mfd/samsung/core.h                  |    1 +
 include/linux/mfd/samsung/irq.h                   |   31 +-
 include/linux/mfd/samsung/rtc.h                   |  132 ++++---
 include/linux/mfd/samsung/s2mps14.h               |  171 +++++++++
 9 files changed, 1045 insertions(+), 231 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mps14.h

-- 
1.7.9.5

