Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813AbaJ2PLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:11:11 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31462 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933420AbaJ2PLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:11:03 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-df-54510383fa67
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
Subject: [PATCH v2 0/8] regulator: max77686: Add GPIO control
Date: Wed, 29 Oct 2014 16:06:38 +0100
Message-id: <1414595206-1437-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t/xy7rNzIEhBgdmqFpsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DKOHvoGkvBH5GK6WuusjcwNgh0
	MXJySAiYSPS1f2WFsMUkLtxbzwZiCwksZZRYfcaji5ELyO5jkjj0ZA87SIJNwFhi8/IlbCAJ
	EYFOZomeg73MIA6zwGomiZ9XTgE5HBzCArYScya7gDSwCKhKfJ5yFWwDr4CbxPpnM5kgtslJ
	nDw2mXUCI/cCRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCEB+3UH49JjVocYBTgYlXh4
	I44FhAixJpYVV+YeYpTgYFYS4f38CyjEm5JYWZValB9fVJqTWnyIkYmDU6qBUbPv5rcn6vN2
	m//e9LG1+fmddHPOgv9ripM7X1XpLw2eYyd2K0FlSay0c4h0rqd7zz4bf3PnQHWutRMVbKO/
	Oboo34y5NZXDtlrR40eGwluFdVpls2+xCf36HcB69eR9tqjA7N7dz38zzWpUNj3y6svypfd9
	l+72yT9ps/io8dmy0oy74scPKLEUZyQaajEXFScCAHu618c2AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Patch 2/8: not tested on hardware. I am kindly asking for testing it
because I don't have the board with Maxim 77802.

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

Krzysztof Kozlowski (8):
  regulator: max77686: Consistently index opmode array by rdev id
  regulator: max77802: Remove support for board files
  regulator: max77686: Remove support for board files
  mfd: max77686/802: Remove support for board files
  regulator: max77686: Initialize opmode explicitly to normal mode
  regulator: max77686: Add GPIO control
  mfd/regulator: dt-bindings: max77686: Document gpio property
  ARM: dts: exynos4412-trats: Switch max77686 regulators to GPIO control

 Documentation/devicetree/bindings/mfd/max77686.txt |   3 +
 arch/arm/boot/dts/exynos4412-trats2.dts            |  25 +--
 drivers/mfd/Kconfig                                |   1 +
 drivers/mfd/max77686.c                             |  23 ---
 drivers/regulator/Kconfig                          |   1 +
 drivers/regulator/max77686.c                       | 179 ++++++++++++++-------
 drivers/regulator/max77802.c                       |  87 ++++------
 include/linux/mfd/max77686-private.h               |   1 -
 include/linux/mfd/max77686.h                       |  28 ----
 9 files changed, 166 insertions(+), 182 deletions(-)

-- 
1.9.1

