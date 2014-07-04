Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775AbaGDKNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:13:05 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29856 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaGDKM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:12:57 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-bf-53b67e26261e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
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
Subject: [PATCH v3 0/6] charger/mfd: max14577: Add support for MAX77836
Date: Fri, 04 Jul 2014 12:12:39 +0200
Message-id: <1404468765-10818-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsVy+t/xK7pqdduCDU7NNLXYOGM9q8XUh0/Y
	LCY9ec9sMXHlZGaL/jcLWS3OvVrJaPH6haHF2aY37Bb3vx5ltPh2pYPJYvP3DjaLy7vmsFms
	PXKX3WLp9YtMFhOmr2WxaN17hN3idDerg6DHmnlrGD0u9/UyeeycdZfdY+XyL2wem1doeWxa
	1cnmcefaHjaPeScDPfq2rGL0+LxJLoArissmJTUnsyy1SN8ugStj2s+DzAVHRCq+L7/D1sB4
	k7+LkZ1DQsBEopWvi5ETyBKTuHBvPVsXIxeHkMBSRonul7+YIZw+JolbW/+xgFSxCRhLbF6+
	BKxKRGAao8TiDRMZQRxmgWksEv/udjCBVAkLuEt0XlnBDGKzCKhKPNr/kxXE5gWKN3x/zwqx
	T07i5LHJrBMYuRcwMqxiFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAnaLzsYFx+zOsQowMGo
	xMPbuGJDsBBrYllxZe4hRgkOZiUR3rfV24KFeFMSK6tSi/Lji0pzUosPMTJxcEo1MC4K2yX1
	8vqHxFdz5z+SkjM+t0dlctSdD/xV7jm5lWa7818+zmv/1R0or5iXf/DRlK2Tlz83ljh+2XaL
	6v0XR84vVn291Edx/run6/7+Wf530gWnRAlXg8cfZNcdCDRtLdqwtGXe7qja9dvuaZRnbRTT
	Voji+L34KtOZ049WPVq4z2XFOsUJPks+K7EUZyQaajEXFScCAKlA+FM4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is third version of patches adding support for MAX77836
device to the max14577 drivers. The first part of patches (main MFD,
extcon and regulator drivers) was merged already.

The patches 1, 2 and 3 depend on each other so they should be
pulled at once. Patches 4, 5 and 6 can be applied independently.

This patchset was already reviewed by some of the maintainers during
previous submissions.

I only need acks from power tree (patches: 1, 3, 4, 6).


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
on the lists since January. Changelog for the first part of drivers:
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

