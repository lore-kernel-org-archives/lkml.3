Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaIWLni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:43:38 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32295 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaIWLnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:43:35 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-85-54215ce45b7e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        devicetree@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v7 0/8] charger/mfd: max14577: Add support for MAX77836
Date: Tue, 23 Sep 2014 13:43:15 +0200
Message-id: <1411472603-11821-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xy7pPYhRDDBZ8F7KYs34Nm8XGGetZ
	LaY+fMJmMenJe2aL+UfOsVpMXDmZ2aL/zUJWi3OvVjJavH5haHG26Q27xf2vRxktvl3pYLLY
	/L2DzeLyrjlsFp97jzBarD1yl91i6fWLTBYTpq9lsWjde4Td4nQ3q8Xp3SUOoh5r5q1h9Ljc
	18vksXPWXXaPlcu/sHlsXqHlsWlVJ5vHnWt72DxOzPjN4jHvZKBH35ZVjB6fN8kFcEdx2aSk
	5mSWpRbp2yVwZTxe+42p4I90xazXS9kaGM+KdjFyckgImEgcnryXBcIWk7hwbz1bFyMXh5DA
	UkaJX+0vmCGcPiaJDxeOM4FUsQkYS2xevgSsSkRgIaPEzCUr2UEcZoEprBKPf7eyglQJC7hL
	rLryHayDRUBV4u705YxdjBwcvEDxjmlsEOvkJE4em8w6gZF7ASPDKkbR1NLkguKk9FwjveLE
	3OLSvHS95PzcTYyQMP+6g3HpMatDjAIcjEo8vB5rFEKEWBPLiitzDzFKcDArifC+C1MMEeJN
	SaysSi3Kjy8qzUktPsTIxMEp1cDYaR+7ROmmI6eNiWumMGuH069ZUo4/19Xe/nroVlfzY87p
	c/b/Py97SCNWgeVhV1bb7c7l90Q2Lmf69Fdm0yW9rVezwlnYHtr2vSrZ93pOws/ZMbM+K/qe
	PvHsKwfPx7ZVd9X3/nnzdk9z5jr5xsl++X92XsuaVvMoaoWBRld1qtWsm98z+5VVlFiKMxIN
	tZiLihMB6/q0slECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Lee,

I got all necessary acks. Could you apply the patchset to MFD tree
for next merge window?


Changes since v6
================
1. Add Sebastian Reichel's acks (power supply).

Changes since v5
================
1. 5/8: Remove 'inline' from functions (suggested by Andrew Morton).
2. Add Andrew Morton's acks.

Changes since v4
================
1. Add Lee Jones' acks to patch 1 and 2 (mfd).
2. power max17040 6/8: Remove duplicated (and not used) value of id
   in array of i2c_device_id. (suggested by Lee Jones)

Changes since v3
================
1. Split MFD changes into separate new patches:
   1/8: mfd: max14577: Add defines for MAX77836 charger
   2/8: Map charger device to its own of_node
   Suggested by Lee Jones.

Changes since v2
================
1. charger: Use sysfs instead of DTS for setting the fast charge timer.
   The charger driver now selects the CONFIG_SYSFS and exports
   a DEVICE_ATTR. (suggested by Mark Rutland)
2. Add patch 6 with documentation of exported sysfs entry for fast
   charge timer.
3. charger 3/6: Add missing 'break' in switch parsing valid values
   for fast charge timer.

Changes since v1
================
1. charger 3/5: Add an error message for each unsuccessful parse of DT
   property (suggested by Mark Rutland).
2. charger 3/5: Use 'u32' type for storing values from DT (suggested
   by Mark Rutland).
3. charger 3/5: Remove an error message for memory allocation failure.


Description
===========
This is a seventh version of patches adding support for
MAX77836 device to the max14577 drivers.

This patchset has been on the lists for quite long time and was already
reviewed by all necessary maintainers.

Generally this should be pulled at once but some parts may be split
and pulled separately in following batches:
 - Patches 1 and 2: as MFD prerequisites,
 - Patches 3-5: adding actual charger code, depends on 1 and 2,
 - Patch 6: fuel-gauge, independent,
 - Patches 7 and 8: only documentation.


The patchset (first and second part of the MAX77836 drivers) has been
on the lists since January. Changelog for the first part of the drivers
(merged):
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg628696.html


Best regards,
Krzysztof Kozlowski

Krzysztof Kozlowski (8):
  mfd: max14577: Add defines for MAX77836 charger
  mfd: max14577: Map charger device to its own of_node
  charger: max14577: Add support for MAX77836 charger
  regulator/mfd: max14577: Export symbols for calculating charger
    current
  charger: max14577: Configure battery-dependent settings from DTS and
    sysfs
  power: max17040: Add ID for MAX77836 Fuel Gauge block
  devicetree: mfd: max14577: Add device tree bindings document
  Documentation: charger: max14577: Document exported sysfs entry

 Documentation/ABI/testing/sysfs-class-power        |  14 +
 Documentation/devicetree/bindings/mfd/max14577.txt | 146 ++++++++
 drivers/mfd/max14577.c                             | 100 +++++-
 drivers/power/Kconfig                              |   5 +-
 drivers/power/max14577_charger.c                   | 370 +++++++++++++++++++--
 drivers/power/max17040_battery.c                   |   3 +-
 drivers/regulator/max14577.c                       |  80 +----
 include/linux/mfd/max14577-private.h               |  95 ++++--
 include/linux/mfd/max14577.h                       |  30 ++
 9 files changed, 704 insertions(+), 139 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt

-- 
1.9.1

