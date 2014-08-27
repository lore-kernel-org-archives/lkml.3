Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934491AbaH0Nbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:31:36 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36526 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933404AbaH0Nbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:31:33 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-22-53fdddb2a6c7
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RESEND PATCH v3 0/6] charger/mfd: max14577: Add support for MAX77836
Date: Wed, 27 Aug 2014 15:31:16 +0200
Message-id: <1409146282-25075-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t/xq7qb7v4NNrh6XcZi44z1rBZTHz5h
	s5j05D2zxcSVk5kt+t8sZLU492olo8XrF4YWZ5vesFvc/3qU0eLblQ4mi83fO9gsLu+aw2bx
	ufcIo8XaI3fZLZZev8hkMWH6WhaL1r1H2C1Od7NanN5d4iDssWbeGkaPy329TB47Z91l91i5
	/Aubx+YVWh6bVnWyedy5tofNY97JQI++LasYPT5vkgvgiuKySUnNySxLLdK3S+DKaJ52g7lg
	smjFzG/XWRsYJwt0MXJwSAiYSCxfod3FyAlkiklcuLeerYuRi0NIYCmjRMfZLhYIp49JYvXR
	GewgVWwCxhKbly8BqxIRuMYocaVhLpjDLDCNReLf3Q4mkLHCAn4Sf7+KgjSwCKhKbP44kQnE
	5hVwlzg1/wcbxDo5iZPHJrNOYORewMiwilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkjL/u
	YFx6zOoQowAHoxIPr8LpP8FCrIllxZW5hxglOJiVRHjLDvwNFuJNSaysSi3Kjy8qzUktPsTI
	xMEp1cBoHCjwWH6jGo9EH3fPs664hx/yFAx95Y45aSge2tgisGq7nq/PlKP3klQ8Fn8qOlCu
	xtvvM+PDv438VTcaFz/JfMv9X+HJkY+WnaXKCxf7uU28mhBapZZUceVvteLGmkiDWSI5W6wy
	Z/Bs7pjSujd56m4DsW8X3F61vEr1iksN09m0gvlE+nIlluKMREMt5qLiRACMGj2LQQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is a resend of third version of patches adding support for
MAX77836 device to the max14577 drivers.

This patchset has been on the lists for quite long time and was already
reviewed by some of the maintainers during previous submissions.
I only need acks from power tree (patches: 1, 3, 4, 6).

The patches 1, 2 and 3 depend on each other so they should be
pulled at once. Patches 4, 5 and 6 can be applied independently.
Lee Jones said he can take the set through his tree. Still I need acks
from power subsystem.


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


Krzysztof Kozlowski (6):
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

