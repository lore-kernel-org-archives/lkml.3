Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaILGyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 02:54:19 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42967 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaILGyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 02:54:15 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-13-5412989401df
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
        devicetree@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v6 0/8] charger/mfd: max14577: Add support for MAX77836
Date: Fri, 12 Sep 2014 08:53:52 +0200
Message-id: <1410504840-23543-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xy7pTZgiFGEy+K2cxZ/0aNouNM9az
	Wkx9+ITNYtKT98wW84+cY7WYuHIys0X/m4WsFuderWS0eP3C0OJs0xt2i/tfjzJafLvSwWSx
	+XsHm8XlXXPYLD73HmG0WHvkLrvF0usXmSwmTF/LYtG69wi7xeluVovTu0scRD3WzFvD6HG5
	r5fJY+esu+weK5d/YfPYvELLY9OqTjaPO9f2sHmcmPGbxWPeyUCPvi2rGD0+b5IL4I7isklJ
	zcksSy3St0vgyvi55hVzwQyZisOn9rE3MD4T7WLk5JAQMJHYuekaG4QtJnHh3nowW0hgKaPE
	kz3CXYxcQHYfk8THo53sIAk2AWOJzcuXgBWJCCxgkri4LhekiFlgKovEpJUtYEXCAu4SOzY8
	YwKxWQRUJb48e8EKYvMCxX/+WMcIsU1O4uSxyawTGLkXMDKsYhRNLU0uKE5KzzXSK07MLS7N
	S9dLzs/dxAgJ8q87GJceszrEKMDBqMTD+yFXMESINbGsuDL3EKMEB7OSCG/qVKEQId6UxMqq
	1KL8+KLSnNTiQ4xMHJxSDYxHOjOSDyxQnvDlv3p7w/Y5H1SaUxoUj3nWnTvwNn7rmmNlv80C
	/20oaO46MXOB5fbiniOb7zw+15bPK7/9okjAppDyDZcmv2q9z7KEI133TOApjZe2yZzZgv1P
	ktu4vDY5p81r8dbX5s2ptzoz+2yw4WmdlikTOPeynyjZ/ZGZz/rslQUOjB+UWIozEg21mIuK
	EwEb8/VKUAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is a sixth version of patches adding support for
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

