Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab3LFLcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 06:32:54 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:63938 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757569Ab3LFLc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 06:32:28 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-af-52a1b5c91862
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
Subject: [PATCH v7 0/3] mfd: max14577: Add max14577 MFD drivers
Date: Fri, 06 Dec 2013 12:32:11 +0100
Message-id: <1386329534-14186-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xK7onty4MMph/z8Ti4FZNi40z1rNa
	TH34hM3i+pfnrBbzj5xjtZi4cjKzxblXKxktXr8wtDjb9Ibd4v7Xo4wW3650MFlsenyN1WJh
	2xIWi8u75rBZrD1yl91i6fWLTBYTpq9lsTi84gCTxbqX01ksXh1sY3EQ8Vgzbw2jx4LPV9g9
	JvR/YvTYOesuu8fK5V/YPDav0PLYtKqTzePV6pmsHneu7QEKLan36NuyitHj8yY5j41zQwN4
	o7hsUlJzMstSi/TtErgyTsxKKNipWLHk7gvmBsZLUl2MHBwSAiYS874xdTFyApliEhfurWcD
	sYUEljJK3Lwl1sXIBWT3MUk8WjmPGSTBJmAssXn5EjaQhIjALRaJCS/XsYM4zAIbGSXeH93I
	BDJVWMBeovOpGEgDi4CqxOVp2xlBbF4Bd4k5fVOZIBYrSMyZZDOBkXsBI8MqRtHU0uSC4qT0
	XEO94sTc4tK8dL3k/NxNjJBA/7KDcfExq0OMAhyMSjy8CWsWBAmxJpYVV+YeYpTgYFYS4bVZ
	vjBIiDclsbIqtSg/vqg0J7X4ECMTB6dUA+OWdxkfN3HqzBBcs0SbYVn10XOJzsHbEvdOkez7
	wVJ14YVSBJuiz9yqy2mWK28Em3BeymLxefMvh+vzIs2e58tW3LaUejyNyWfNyiOvTRm33/oc
	EbgyxemJZBlDTvIrf8kXgtVtoQwzma1yQ+8fj163J2t+31f/4NmTtnvOSWfwOmMavPbjpGlK
	LMUZiYZazEXFiQBKi2ljUgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is seventh version of patchset adding drivers for MAXIM 14577 chip.
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


Changes since v6:
-----------------
1. Documentation of bindings: Applied changes pointed by Chanwoo Choi
   and Lee Jones.

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

 Documentation/devicetree/bindings/mfd/max14577.txt |   65 ++++
 drivers/power/Kconfig                              |    7 +
 drivers/power/Makefile                             |    1 +
 drivers/power/max14577_charger.c                   |  311 ++++++++++++++++++++
 drivers/regulator/Kconfig                          |    7 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/max14577.c                       |  272 +++++++++++++++++
 7 files changed, 664 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt
 create mode 100644 drivers/power/max14577_charger.c
 create mode 100644 drivers/regulator/max14577.c

-- 
1.7.9.5

