Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223AbaJ3LVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:21:25 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59728 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758794AbaJ3LVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:21:22 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-2a-54521f2e6aa1
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 00/14] regulator: max77686: Add GPIO control
Date: Thu, 30 Oct 2014 12:20:39 +0100
Message-id: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsVy+t/xq7p68kEhBocWKFpsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DK2PfLouCyXMWv5uVMDYzfxbsY
	OTkkBEwk7v5bwAxhi0lcuLeerYuRi0NIYCmjxMFnb6CcPiaJO9/+soFUsQkYS2xevgQsISLQ
	ySzRc7CXGcRhFljNJPHzyimwWcIC9hLnt5xnBLFZBFQlLj5rZAKxeQXcJX6v38UCsU9O4uSx
	yawTGLkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJ2S87GBcfszrEKMDBqMTD67Ax
	IESINbGsuDL3EKMEB7OSCO9qsaAQId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYyr5IuZI//cD95X
	+8T+UBTvw2dHUx1jlNYnKX+aOl3kkfP3iYxKO59rhKlM4T2/6vtyoTuxbh6OeyS1p1e+jbgx
	PSBKqT665JFmJZP75F2vbUQPz++NMog0evpK/OdEQ8mZnE7pXJMF+X9uWtDxNX7OisdLGqtO
	f7IOEVuvvf0vs1i3YPFmtWAlluKMREMt5qLiRADqQnOJNwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Patches touching max77802 were not tested on hardware.
I am kindly asking for testing it because I don't have the board
with Maxim 77802.

Changes since v2
================
Re-work the board file support removal after Javier's comments: use
new DT style parsing. This imposes a lot of changes.
1. Add "of_compatible" for regulator drivers.
2. Provide backward compatibility if such "of_compatible" is not present.
   The driver will search for regulators node and use it as dev->of_node.
   Everything should be bisect-friendly.
3. New patches: 1, 2, 3, 5, 13 and 14.
4. Because of new style DT parsing it is much easier to put "gpio"
   properties in regulators top node (not in each regulator).
   This will be also new-gpio-lib friendly.

Changes since v1
================
1. Add patch: 1/8 "regulator: max77686: Consistently index opmode
   array by rdev id".
2. Remove patch "regulator: max77686: Make regulator_desc array
   const" (applied).
3. Re-work patches removing from regulators board file support (2/8
   and 3/8). Parse regulators with of_regulator_match() at once, remove
   num_regulators.
4. Patch 4/8: Add depends on OF to mfd/Kconfig. Add Javier's
   reviewed-by.
5. Patch 5/8: Add Javier's reviewed-by.
6. Patch 6/8: Add depends on GPIOLIB to regulator/Kconfig. Rename
   "external control" to "GPIO control" and "ext_control_gpios" to
   simpler "gpios".
   I tried to use new GPIO API but it ended with more problems
   https://lkml.org/lkml/2014/10/29/239


Description
===========
This patch helps in proper description of max77686 regulators in DTS by
allowing to control them over GPIO. This allows removal of
fixed regulators from DTS which duplicate the description of hardware.

The first five patches are cleanups, including board support removal.

The whole patchset should be taken at once.

Patchset is rebased on next-20141023 AND:
1. ARM: EXYNOS: Call regulator suspend prepare/finish
   https://lkml.org/lkml/2014/10/20/545
2. regulator: max77686/trats2: Disable some regulators in suspend
   https://lkml.org/lkml/2014/10/27/280


Best regards,
Krzysztof

*** BLURB HERE ***

Krzysztof Kozlowski (14):
  mfd: max77686/802: Map regulator driver to its own of_node
  mfd/regulator: dt-bindings: max77686: Document of_compatible for
    regulator
  regulator: dt-bindings: max77802: Document of_compatible for regulator
  regulator: max77686: Consistently index opmode array by rdev id
  regulator: max77802: Don't ignore return value of current opmode
  regulator: max77802: Remove support for board files
  regulator: max77686: Remove support for board files
  mfd: max77686/802: Remove support for board files
  regulator: max77686: Initialize opmode explicitly to normal mode
  regulator: max77686: Add GPIO control
  mfd/regulator: dt-bindings: max77686: Document gpio properties
  ARM: dts: exynos4412-trats: Switch max77686 regulators to GPIO control
  ARM: dts: exynos5420-peach: Update to new max77802 regulator
    compatible
  ARM: dts: exynos5800-peach: Update to new max77802 regulator
    compatible

 Documentation/devicetree/bindings/mfd/max77686.txt |  16 +-
 .../devicetree/bindings/regulator/max77802.txt     |   8 +-
 arch/arm/boot/dts/exynos4412-trats2.dts            |  28 +---
 arch/arm/boot/dts/exynos5420-peach-pit.dts         |   2 +
 arch/arm/boot/dts/exynos5800-peach-pi.dts          |   2 +
 drivers/mfd/Kconfig                                |   1 +
 drivers/mfd/max77686.c                             |  33 +---
 drivers/regulator/max77686.c                       | 186 +++++++++++++--------
 drivers/regulator/max77802.c                       | 116 +++++--------
 include/linux/mfd/max77686-private.h               |   1 -
 include/linux/mfd/max77686.h                       |  28 ----
 11 files changed, 200 insertions(+), 221 deletions(-)

-- 
1.9.1

