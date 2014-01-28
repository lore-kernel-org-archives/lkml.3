Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbaA1MTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:19:00 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20306 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbaA1MS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:18:58 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-48-52e7a030926d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 00/18] mfd: max14577: Add support for MAX77836
Date: Tue, 28 Jan 2014 13:18:24 +0100
Message-id: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsVy+t/xa7oGC54HGVx6Km8x9eETNovrX56z
	Wrx+YWhxtukNu8X9r0cZLb5d6WCy2PT4GqvF5V1z2CzWHrnLbnG7cQWbxeluVgduj52z7rJ7
	bFrVyeZx59oeNo95JwM9Ni+p9+jbsorR4/MmuQD2KC6blNSczLLUIn27BK6Mxt3PWAouSlas
	697P1MDYLNLFyMkhIWAiseb4byYIW0ziwr31bF2MXBxCAksZJTbu/Qbl9DFJPP1wlhmkik3A
	WGLz8iVgCRGB1UwSaxZMZQFJMAv0Mkrc3O0BYgsL2EncP3yWFcRmEVCV2L/vPBuIzSvgLrF3
	xkegOAfQOgWJOZNsJjByL2BkWMUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kRElpfdjAuPmZ1
	iFGAg1GJh7ej81mQEGtiWXFl7iFGCQ5mJRHexNnPg4R4UxIrq1KL8uOLSnNSiw8xMnFwSjUw
	Rpczul87f8Oh2lyK906azq6Zs//Zb11wcZtz49oD22o9ylIPHYhrV0wLneHTq18ky2t35ccX
	6/NbXz569lR+4Y/CB0LfFKMKw+7FHFymJHE1menVq/o5C7Lyak8/mSX4PkRSJtTj054js7qe
	7J/1SnXRvP33ebr0U6W3Fytf1w0JE2Syu8W0Q4mlOCPRUIu5qDgRAKiQMJYLAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This patchset adds support for MAX77836 device to the max14577 driver.

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
1. Patches from 1 to 6 clean up the max14577 drivers and add minor tweaks.
2. Patches from 7 to 12 prepare the driver for supporting MAX77836. They
   mostly rename symbols and add additional logic related to different
   deviec types.
3. Patches from 13 to 17 add support for MAX77836.
4. Patch 18 adds bindings documentation, which was not merged previously.
   Here I tried to address also Tomasz Figa's comments from review.

The patchset is based on current Linus' tree (v3.13-8789-g54c0a4b46150).
Testing was done on 3.10.

TODO: Merge max14577, max77686 and max77693 into one common driver. They are
very similar.


Best regards,
Krzysztof Kozlowski


Chanwoo Choi (1):
  extcon: max14577: Change extcon name instead of static name according
    to device type

Krzysztof Kozlowski (17):
  regulator: max14577: Remove unused state container definition
  mfd: max14577: Remove unused enum max14577_irq_source
  mfd: max14577: Remove not needed header inclusion
  mfd: max14577: Add of_compatible to extcon mfd_cell
  mfd: max14577: Use of_match_ptr() in i2c_driver
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
  mfd: max14577: Add device tree bindings document

 Documentation/devicetree/bindings/mfd/max14577.txt |  104 ++++
 drivers/extcon/extcon-max14577.c                   |  272 ++++++----
 drivers/mfd/max14577.c                             |  377 ++++++++++---
 drivers/power/max14577_charger.c                   |  170 +++---
 drivers/power/max17040_battery.c                   |    1 +
 drivers/regulator/max14577.c                       |  323 ++++++++---
 include/linux/mfd/max14577-private.h               |  565 ++++++++++++--------
 include/linux/mfd/max14577.h                       |   24 +-
 8 files changed, 1313 insertions(+), 523 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt

-- 
1.7.9.5

