Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab3KVPvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:51:23 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34135 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab3KVPvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:51:20 -0500
X-AuditID: cbfec7f4-b7fee6d000004b2d-10-528f7d76a34b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 0/5] mfd: max14577: Add max14577 MFD drivers
Date: Fri, 22 Nov 2013 16:51:04 +0100
Message-id: <1385135469-27044-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xy7pltf1BBo+/CVoc3KppsXHGelaL
	qQ+fsFlc//Kc1WL+kXOsFhNXTma2OPBnB6PFuVcrGS1evzC0ONv0ht3i/tejjBbfrnQwWWx6
	fI3VYmHbEhaLy7vmsFmsPXKX3eJ24wo2iwnT17JYHF5xgMli3cvpLBanu1ktXh1sY3EQ81gz
	bw2jx4LPV9g9JvR/YvTYOesuu8fK5V/YPDav0PLYtKqTzePV6pmsHneu7WHzmHcy0GPzknqP
	vi2rGD0+b5Lz2Dg3NIAvissmJTUnsyy1SN8ugSvjyCnZgtvyFTduXGBtYPwu3sXIySEhYCLx
	7ttjFghbTOLCvfVsXYxcHEICSxklvk99yAzh9DFJ9B78zQ5SxSZgLLF5+RKwKhGBOawSu888
	YwFxmAWOMkq87dzFBFIlLGAv0fDpG1gHi4CqxISuHWBxXgF3iZvT1zF2MXIA7VOQmDPJZgIj
	9wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIZHwZQfj4mNWhxgFOBiVeHh3WPYFCbEm
	lhVX5h5ilOBgVhLh5QDGkRBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGLvcH5907vlZM5bt704HV
	TK2D/9OjS16SH81iDqxsaS033Tc1Tz5D+e+mmRON/p4SfnA03Y2pWKnk5Cm5Y5/Sn+WaT2J5
	n9wf8tFm8/eiL7p/NnAvk/jjJxEV7S9yOMh96SOTjoR/e17aai4XnPcj7yLPDdYc9c5NrZU8
	AZ26v41sz8+rY7FUYinOSDTUYi4qTgQACqOnS2ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is fourth version of patchset adding drivers for MAXIM 14577 chip.

Description
-----------
The chip contains Micro-USB Interface Circuit and Li+ Battery Charger.
It contains accessory and USB charger detection logic. It supports USB 2.0
Hi-Speed, UART and stereo audio signals over Micro-USB connector.

The battery charger is compliant with the USB Battery Charging Specification
Revision 1.1. It has also SFOUT LDO output for powering USB devices.

The patchset consists of following drivers:
1. MFD core driver.
2. Extcon driver for the MUIC (Micro USB Interface Controller).
3. Charger driver using power supply class.
4. Regulator driver for SFOUT and charger.
5. Documentation of device tree bindings.

The patchset is rebased on latest Linus' tree (v3.12-11097-ga5d6e63) however
testing was mostly done on 3.10.


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

Chanwoo Choi (2):
  mfd: max14577: Add max14577 MFD driver core
  extcon: max14577: Add extcon-max14577 driver to support MUIC device

Krzysztof Kozlowski (3):
  charger: max14577: Add charger support for Maxim 14577
  regulator: max14577: Add regulator driver for Maxim 14577
  mfd: max14577: Add device tree bindings document

 Documentation/devicetree/bindings/mfd/max14577.txt |   48 ++
 drivers/extcon/Kconfig                             |   10 +
 drivers/extcon/Makefile                            |    1 +
 drivers/extcon/extcon-max14577.c                   |  752 ++++++++++++++++++++
 drivers/mfd/Kconfig                                |   13 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/max14577.c                             |  244 +++++++
 drivers/power/Kconfig                              |    7 +
 drivers/power/Makefile                             |    1 +
 drivers/power/max14577_charger.c                   |  311 ++++++++
 drivers/regulator/Kconfig                          |    7 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/max14577.c                       |  268 +++++++
 include/linux/mfd/max14577-private.h               |  330 +++++++++
 include/linux/mfd/max14577.h                       |   69 ++
 15 files changed, 2063 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt
 create mode 100644 drivers/extcon/extcon-max14577.c
 create mode 100644 drivers/mfd/max14577.c
 create mode 100644 drivers/power/max14577_charger.c
 create mode 100644 drivers/regulator/max14577.c
 create mode 100644 include/linux/mfd/max14577-private.h
 create mode 100644 include/linux/mfd/max14577.h

-- 
1.7.9.5

