Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaH1NGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:06:13 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11671 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaH1NGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:06:10 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-26-53ff293f4057
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
Subject: [PATCH v5 0/8] charger/mfd: max14577: Add support for MAX77836
Date: Thu, 28 Aug 2014 15:05:42 +0200
Message-id: <1409231150-2701-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVy+t/xy7r2mv+DDVpXCllsnLGe1WLqwyds
	FpOevGe2mLhyMrNF/5uFrBbnXq1ktHj9wtDibNMbdov7X48yWny70sFksfl7B5vF5V1z2Cw+
	9x5htFh75C67xdLrF5ksJkxfy2LRuvcIu8XpblaL07tLHIQ91sxbw+hxua+XyWPnrLvsHiuX
	f2Hz2LxCy2PTqk42jzvX9rB5zDsZ6NG3ZRWjx+dNcgFcUVw2Kak5mWWpRfp2CVwZ589/ZS2Y
	IF2x5PRntgbGryJdjJwcEgImEu+mHGOCsMUkLtxbzwZiCwksZZT4v6O4i5ELyO5jkmjc284C
	kmATMJbYvHwJWJGIwAImiYvrckFsZoEzzBJTV3OA2MIC7hIf9/8FG8oioCox59MJsHpeATeJ
	/t3HWSCWyUmcPDaZdQIj9wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIUH8ZQfj4mNW
	hxgFOBiVeHg3lP4LFmJNLCuuzD3EKMHBrCTCu0nyf7AQb0piZVVqUX58UWlOavEhRiYOTqkG
	xsWOYtY9VysMb0QkC89/2Jd982RuzBEGe32li62r1yqfeu/68VuWaucW5WWtWV8eB7RI3Njg
	sfD8Kjd1Dtc8jzeXn7NtXZ/K/i16wfmUu43NLo8O/21cqTzvX+4indeRPnP3rX7j/JjjSqHx
	K+Zf/FJ/k/Xv3fxcL/qf9eulM1brw7a9//iprUKJpTgj0VCLuag4EQDltDQwQAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is a fifth version of patches adding support for
MAX77836 device to the max14577 drivers.

This patchset has been on the lists for quite long time and was already
reviewed by all necessary maintainers except power supply.
I need acks from power supply subsystem (patches: 3, 5-8).

Generally this should be pulled at once but some parts may be split
and pulled separately in following batches:
 - Patches 1 and 2: as MFD prerequisites,
 - Patches 3-5: adding actual charger code, depends on 1 and 2,
 - Patch 6: fuel-gauge, independent,
 - Patches 7 and 8: only documentation.

Lee Jones said he can take the set through his tree. Still I need acks
from power subsystem.

Everything rebased on Linus' tree (v3.17-rc2-9-g68e370289c29).


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

