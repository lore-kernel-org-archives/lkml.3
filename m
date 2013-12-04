Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab3LDKkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:40:35 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63284 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab3LDKkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:40:31 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-25-529f069cde86
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v6 0/3] mfd: max14577: Add max14577 MFD drivers
Date: Wed, 04 Dec 2013 11:40:12 +0100
Message-id: <1386153615-25456-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t/xy7pz2OYHGcyfpWlxcKumxcYZ61kt
	pj58wmZx/ctzVov5R86xWkxcOZnZ4tyrlYwWr18YWpxtesNucf/rUUaLb1c6mCw2Pb7GarGw
	bQmLxeVdc9gs1h65y26x9PpFJosJ09eyWBxecYDJYt3L6SwWrw62sTiIeKyZt4bRY8HnK+we
	E/o/MXrsnHWX3WPl8i9sHptXaHlsWtXJ5vFq9UxWjzvX9gCFltR79G1ZxejxeZOcx8a5oQG8
	UVw2Kak5mWWpRfp2CVwZy09/ZizYpFAx6dFF5gbG55JdjJwcEgImEovajzBC2GISF+6tZ+ti
	5OIQEljKKPHk+A0mCKePSeJkx282kCo2AWOJzcuXgFWJCNxikZjwch07iMMssJFR4v3RjUwg
	VcIC9hJzd50Am8sioCox//gxIJuDg1fAXWLujmIQU0JAQWLOJJsJjNwLGBlWMYqmliYXFCel
	5xrpFSfmFpfmpesl5+duYoSE+9cdjEuPWR1iFOBgVOLhTeCcFyTEmlhWXJl7iFGCg1lJhPcQ
	6/wgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYx5C/hUkq5pd3Ad8o0KXxK6dOWbVA2BpPe21pa3
	nu+Q4lFg3tV7POadUm/svkKTsJXCu4oZIj67BPs71D5eKWV2kjlu68HGraxMi16msGrJfph6
	xM1HZOHtHcyd26reJSg8NmaN6331ivvsjs+RtyYnmzBm3Zd0UlZZEnw/xWFGl5fu3RzP/0os
	xRmJhlrMRcWJALb70WxVAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is sixth version of patchset adding drivers for MAXIM 14577 chip.
Some parts (MFD, extcon) were already merged by maintainers so I removed them
from the patchset.

This version of patchset depends on the max14577 MFD core driver:
 - mfd: max14577: Add max14577 MFD driver core
   Merged in: git://git.linaro.org/people/ljones/mfd.git
   https://git.linaro.org/gitweb?p=people/ljones/mfd.git;a=commit;h=47ae80d7c147caa07165fcac078c26fbe87bfc28


Description
-----------
The chip contains Micro-USB Interface Circuit and Li+ Battery Charger.
It contains accessory and USB charger detection logic. It supports USB 2.0
Hi-Speed, UART and stereo audio signals over Micro-USB connector.

The battery charger is compliant with the USB Battery Charging Specification
Revision 1.1. It has also SFOUT LDO output for powering USB devices.

The patchset consists of following drivers:
1. MFD core driver. (applied by Lee Jones)
2. Extcon driver for the MUIC (Micro USB Interface Controller). (applied
   by Chanwoo Choi)
3. Charger driver using power supply class.
4. Regulator driver for SFOUT and charger.
5. Documentation of device tree bindings.

The patchset is rebased on latest Linus' tree (v3.13-rc2-122-gdea4f48a0a30)
however testing was mostly done on 3.10.

Changes since v5:
-----------------
1. Patches "mfd: max14577: Add max14577 MFD driver core" and "mfd: max14577:
   Match regulator by of_compatible string" were applied by Lee Jones to his
   tree.
2. Patch "extcon: max14577: Add extcon-max14577 driver to support MUIC device"
   were applied by Chanwoo Choi to his tree.
3. Regulator (2/3): Use of_get_child_by_name() to match regulators node from DT.

Changes since v4:
-----------------
1. Split MFD changes from regulator patch.

Changes since v3:
-----------------
1. Applied suggestions from Lee Jones and Alexander Shiyan.
2. Extcon (2/5): Use system_power_efficient_wq for delayed cable detection
   (pointed by Mark Brown).
3. Regulator (4/5): Add compatible string to regulators node so MFD core will
   match it to the driver. Simplify and fix DT parsing. (Lee Jones)
4. Regulator (4/5): Get rid of regulators variable. (Bartlomiej Zolnierkiewicz).

Changes since v2:
-----------------
1. Replaced max14577-irq.c with regmap_irq_chip, as suggested by Mark Brown.
2. Applied suggestions from review (Mark Brown, Lee Jones).
3. Regulator: Added registering unconditionally of all regulators (Mark Brown).
4. Regulator: Removed the "struct max14577_regulator *info" (Bartlomiej
   Zolnierkiewicz).
5. Extcon: Removed work-around for hardware reboot (USB cable attached with
   factory button set to D/L mode) as it is not needed.

Changes since v1:
-----------------
1. Applied comments from review (Mark Brown, Mark Rutland).
2. Removed any DT bindings which are not needed.
3. Removed "wakeup" node from bindings.
4. Fixed interrupt handling during resume. This lead to removal of the weird
   IRQ/GPIO code discussed during review.
5. Minor fixes pointed by checkpatch, added authors.
6. Use of_get_child_by_name() for accessing regulators bindings.
7. Added documentation of bindings (fifth patch).

Best regards,
Krzysztof Kozlowski


Krzysztof Kozlowski (3):
  charger: max14577: Add charger support for Maxim 14577
  regulator: max14577: Add regulator driver for Maxim 14577
  mfd: max14577: Add device tree bindings document

 Documentation/devicetree/bindings/mfd/max14577.txt |   48 +++
 drivers/power/Kconfig                              |    7 +
 drivers/power/Makefile                             |    1 +
 drivers/power/max14577_charger.c                   |  311 ++++++++++++++++++++
 drivers/regulator/Kconfig                          |    7 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/max14577.c                       |  272 +++++++++++++++++
 7 files changed, 647 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt
 create mode 100644 drivers/power/max14577_charger.c
 create mode 100644 drivers/regulator/max14577.c

-- 
1.7.9.5

