Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbaDNJWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:22:36 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54678 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaDNJRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:17:37 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-aa-534ba7adf8ae
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 0/9] mfd: max14577: Add support for MAX77836
Date: Mon, 14 Apr 2014 11:17:11 +0200
Message-id: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xK7prl3sHG7S36lhsnLGe1WLqwyds
	Fte/PGe1eP3C0OJs0xt2i/tfjzJafLvSwWRxedccNou1R+6yW9xuXMFmcbqb1YHbY+esu+we
	m1Z1snncubaHzWPeyUCPvi2rGD0+b5ILYIvisklJzcksSy3St0vgyni1aQ1TwR+5ihuT/zA2
	ML6X6GLk5JAQMJFYt/UpI4QtJnHh3nq2LkYuDiGBpYwS3yd0s0M4fUwS/458ZAapYhMwlti8
	fAlYlYhAM5NES99ZRhCHWeAoo8T03rdMIFXCAvYS+042gs1lEVCVWDVzMQuIzSvgLtEz/SEr
	xD4FiWVf1jJPYORewMiwilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkrL7uYFx6zOoQowAH
	oxIPb8cc72Ah1sSy4srcQ4wSHMxKIrzbMryChXhTEiurUovy44tKc1KLDzEycXBKNTAeZ/53
	qrC3VtlWvUNVo+J6bqb43wfPdt64JBa1zKrkB0+L4E8Xz1lZi74ZvW9YbPL5EqfNv63MTfe8
	jvYovHL4PFW9xM/kxqJVk18I6x7eHv8o84Ra/z+BvaYay446PoifuIzvz42tub4HbB23OBi5
	3JFPnZykOvnuhZ9T8js7/C6YC/dyHo1SYinOSDTUYi4qTgQAi1ZvWgkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is first part of fifth version of patchset adding support for
MAX77836 device to the max14577 driver.

I decided to split the patchset into smaller parts. I hope this would
help in getting necessary review/acks from maintainers.

The first part introduces changes in max14577 driver and adds support
for MAX77836 in MFD, extcon and regulator drivers. Most of these
patches already have required acks from maintainers.
Full v4 patchset can be found here:
http://thread.gmane.org/gmane.linux.kernel/1654267


Changes since v4
================
1. Updated Kconfig entries mentioning MAX77836.
2. Removed rename-like patches:
   [PATCH v4 02/16] mfd: max14577: Rename and add MAX14577 symbols
   [PATCH v4 03/16] mfd: max14577: Rename state container to maxim_core
3. Added new patches (not yet reviewed):
   [PATCH v5 2/9] mfd: max14577: Add muic prefix to regmap config
   [PATCH v5 6/9] mfd: max14577: Add MAX14577 prefix to IRQ defines
4. Rebased on 3.15-rc1.

Changes since v3
================
1. Applied minor fixes (pointed by Lee Jones).
2. Added one ACK (Lee Jones) and Review-by (Tomasz Figa).
3. Patch 14/charger: Minor change in parsing EOC value from DTS.
4. Rebased on next-20140224.

Changes since v2
================
1. Added ACK-s.
2. Applied minor checkpatch fixes (pointed by Lee Jones).
3. Rebased on next-20140217.

Changes since v1
================
1. Added ACK-s, reviews and tested-by tags.
2. Removed applied patches (they were merged to the linux-next tree).
3. Applied comments from review (Lee Jones) to 5/15 (detection of device type)
   and 8/15 (add max77836 support to max14577).
4. Rebased on next tree.
5. Added patch 13 and 14 (pointed by Jenny Tc):
   - regulator/mfd: max14577: Export symbols for calculating charger current
   - charger: max14577: Configure battery-dependent settings from DTS
6. Updated bindings documentation with new charger bindings.
Previous thread:
 - [PATCH 00/18] mfd: max14577: Add support for MAX77836
   http://thread.gmane.org/gmane.linux.kernel/1636654/focus=1636674


Description
===========
The MAX77836 is almost the same as MAX14577. Basically it is an extended
version of MAX14577. The chipsets have same MUIC component so the extcon,
charger and regulators require only little adjustments. More changes were
needed in the charger (because it uses lower charging current) and regulator
drivers (because mentioned different charing current and additional
regulators). The MAX77836 has also PMIC and Fuel Gauge (which is the same
as MAX17040/17048 Fuel Gauge).

The MAX77836 uses three I2C slave addresses and has additional interrupts
(related to PMIC and Fuel Gauge). It has also Interrupt Source register,
just like MAX77686 and MAX77693.


Best regards,
Krzysztof Kozlowski


Chanwoo Choi (1):
  extcon: max14577: Change extcon name instead of static name according
    to device type

Krzysztof Kozlowski (8):
  mfd: max14577: Add muic prefix to regmap config
  mfd: max14577: Add detection of device type
  extcon: max14577: Add max14577 prefix to muic_irqs
  extcon: max14577: Choose muic_irqs according to device type
  mfd: max14577: Add MAX14577 prefix to IRQ defines
  mfd: max77836: Add MAX77836 support to max14577 driver
  extcon: max14577: Add support for MAX77836
  regulator: max14577: Add support for MAX77836 regulators

 drivers/extcon/Kconfig               |   4 +-
 drivers/extcon/extcon-max14577.c     | 174 +++++++++++++------
 drivers/mfd/Kconfig                  |   6 +-
 drivers/mfd/max14577.c               | 315 ++++++++++++++++++++++++++++++-----
 drivers/regulator/Kconfig            |   7 +-
 drivers/regulator/max14577.c         | 277 ++++++++++++++++++++++++++----
 include/linux/mfd/max14577-private.h | 222 ++++++++++++++++++------
 include/linux/mfd/max14577.h         |  19 ++-
 8 files changed, 836 insertions(+), 188 deletions(-)

-- 
1.8.3.2

