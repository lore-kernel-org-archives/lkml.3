Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935116AbaH0PUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:20:32 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:24383 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934943AbaH0PU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:20:26 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-d7-53fdf736fc50
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 0/8] charger/mfd: max14577: Add support for MAX77836
Date: Wed, 27 Aug 2014 17:20:06 +0200
Message-id: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t/xy7pm3/8GGxxdYWSxccZ6VoupD5+w
	WUx68p7ZYuLKycwW/W8Wslqce7WS0eL1C0OLs01v2C3ufz3KaPHtSgeTxebvHWwWl3fNYbP4
	3HuE0WLtkbvsFkuvX2SymDB9LYtF694j7Banu1ktTu8ucRD2WDNvDaPH5b5eJo+ds+6ye6xc
	/oXNY/MKLY9NqzrZPO5c28PmMe9koEffllWMHp83yQVwRXHZpKTmZJalFunbJXBl7NnVy1Rw
	SrLi+b61bA2M14W7GDk5JARMJI6eOcYEYYtJXLi3nq2LkYtDSGApo8TtT7tYIJw+Jol7166x
	g1SxCRhLbF6+hA3EFhFYwCRxcV0uiM0scIZZYupqDhBbWMBd4sjpuWD1LAKqEqv+vgCzeYHi
	K653sENsk5M4eWwy6wRG7gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQsL46w7Gpces
	DjEKcDAq8fAqnP4TLMSaWFZcmXuIUYKDWUmEt+zA32Ah3pTEyqrUovz4otKc1OJDjEwcnFIN
	jM0cmdc2rr/JeSKo5B1DrZBkfkX9yYAzb+b0b/7/7dPPvdJiex+WzdWN5Dzl2fv66vSVX19a
	/gk2Pla2rP99kKPntVtV21M3pSpL1Ev/11pmZvG0eIp+u0nV0pnl8QwJrUkfTOUmpbx/83zJ
	Y1HrE3P+82/Padlr19woJvj4idiLg1HfdG3YHyuxFGckGmoxFxUnAgCyYCB2QQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is a fourth version of patches adding support for
MAX77836 device to the max14577 drivers.

This patchset has been on the lists for quite long time and was already
reviewed by some of the maintainers during previous submissions.
I am in a need of acks from power tree (patches: 3, 5-8).

Generally this should be pulled at once but some parts may be split
and pulled separately in following batches:
 - Patches 1 and 2: as MFD prerequisites,
 - Patches 3-5: adding actual charger code, depends on 1 and 2,
 - Patch 6: fuel-gauge, independent,
 - Patches 7 and 8: only documentation.

Lee Jones said he can take the set through his tree. Still I need acks
from power subsystem.

Everything rebased on current Linus' tree (v3.17-rc2-9-g68e370289c29).


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
 drivers/power/max17040_battery.c                   |   1 +
 drivers/regulator/max14577.c                       |  80 +----
 include/linux/mfd/max14577-private.h               |  95 ++++--
 include/linux/mfd/max14577.h                       |  30 ++
 9 files changed, 703 insertions(+), 138 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt

-- 
1.9.1

