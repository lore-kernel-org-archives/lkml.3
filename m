Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaBGKFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:05:08 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22480 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaBGKFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:05:04 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-77-52f4afccc9dd
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 00/15] mfd: max14577: Add support for MAX77836
Date: Fri, 07 Feb 2014 11:04:32 +0100
Message-id: <1391767487-10017-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAJMWRmVeSWpSXmKPExsVy+t/xq7pn1n8JMvi9w8hi44z1rBZTHz5h
	s7j+5TmrxesXhhZnm96wW9z/epTRYtPja6wWl3fNYbNYe+Quu8XtxhVsFqe7WR24PTat6mTz
	uHNtD5vHvJOBHpuX1Hv0bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXxqwutoId8hUdjfNYGxgf
	SHQxcnJICJhILP/6mw3CFpO4cG89kM3FISSwlFFi/v5NLBBOH5PE+9MTmUGq2ASMJTYvXwJW
	JSLQApRYv58RJMEscJRR4skywy5Gdg5hAUeJp5wgURYBVYk792+CtfIKuEu0Xv7E2sXIAbRM
	QWLOJJsJjNwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoSE0pcdjIuPWR1iFOBgVOLh
	PbH0c5AQa2JZcWXuIUYJDmYlEV6NtV+ChHhTEiurUovy44tKc1KLDzEycXBKNTA2eR9/+1FI
	07bCJ2MpkxzPiQczRZZcZVd83ZstWnD/iNyMI49fmQd9/rPRjqHv0KRZc09vYGHbzr6vbdGS
	gBd7hcyENlkU8wffNee6t1XSIPXgXePPRyfm6j4PkitJC2RzMD6pxXFFmp3l62GROVcZ//Rz
	CCmsu2Jo1XJl04zItV4Fb554pRgpsRRnJBpqMRcVJwIAyvQulQMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is second version of patchset adding support for MAX77836 device
to the max14577 driver.


Changes since v1
----------------
1. Added ACK-s, reviews and tested-by tags.
2. Removed applied patches (they were merged to the lunux-next tree).
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
-----------
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

The patchset is organized in following way:
1. Patches from 1 to 7 prepare the driver for supporting MAX77836. They
   mostly rename symbols and add additional logic related to different
   device types.
2. Patches from 8 to 12 add support for MAX77836.
3. Patches 13 and 14 remove hard-coded charger configuration with DTS. They
   were added after review on mailing lists.
4. Patch 15 adds bindings documentation, which was not merged previously.
   Here I tried to address also Tomasz Figa's comments from review.


The patchset is based on linux-next tree and depends on patches from previous
release which are already merged into next.
Testing was done on 3.10.


TODO: Merge max14577, max77686 and max77693 into one common driver. They are
very similar.


Best regards,
Krzysztof Kozlowski


Chanwoo Choi (1):
  extcon: max14577: Change extcon name instead of static name according
    to device type

Krzysztof Kozlowski (14):
  mfd: max14577: Rename and add MAX14577 symbols to prepare for
    max77836
  mfd: max14577: Rename state container to maxim_core
  mfd: max14577: Add "muic" suffix to regmap and irq_chip
  mfd: max14577: Add detection of device type
  extcon: max14577: Add max14577 prefix to muic_irqs
  extcon: max14577: Choose muic_irqs according to device type
  mfd: max77836: Add max77836 support to max14577 driver
  extcon: max14577: Add support for max77836
  regulator: max14577: Add support for max77836 regulators
  charger: max14577: Add support for MAX77836 charger
  power: max17040: Add ID for max77836 Fuel Gauge block
  regulator/mfd: max14577: Export symbols for calculating charger
    current
  charger: max14577: Configure battery-dependent settings from DTS
  mfd: max14577: Add device tree bindings document

 Documentation/devicetree/bindings/mfd/max14577.txt |  149 +++++
 drivers/extcon/extcon-max14577.c                   |  274 ++++++----
 drivers/mfd/max14577.c                             |  475 +++++++++++++---
 drivers/power/max14577_charger.c                   |  360 +++++++++---
 drivers/power/max17040_battery.c                   |    1 +
 drivers/regulator/max14577.c                       |  279 +++++++---
 include/linux/mfd/max14577-private.h               |  578 ++++++++++++--------
 include/linux/mfd/max14577.h                       |   50 +-
 8 files changed, 1632 insertions(+), 534 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt

-- 
1.7.9.5

