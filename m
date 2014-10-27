Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaJ0Jov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:44:51 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8323 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaJ0Jos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:44:48 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-0a-544e140d7d6c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
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
Subject: [PATCH v4 0/3] regulator: max77686/trats2: Disable some regulators in
 suspend
Date: Mon, 27 Oct 2014 10:44:23 +0100
Message-id: <1414403066-7872-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xK7q8In4hBn2tUhYbZ6xntZi07gCT
	xdSHT9gsrn95zmox/8g5VoujvwssXr8wtOhdcJXN4mzTG3aLb1c6mCw2Pb7GanF51xw2ixnn
	9zFZ3L7Ma7H2yF12B36PluYeNo+/z6+zePxd9YLZY+esu+wem1Z1snlsXlLv0bdlFaPH501y
	ARxRXDYpqTmZZalF+nYJXBln+sUKNgtWTDm4lrmBsZevi5GTQ0LARGL6j02sELaYxIV769m6
	GLk4hASWMkpc7v7DAuH0MUn8mr2bGaSKTcBYYvPyJWwgtojAfiaJxxNMQIqYBVYzSfy8cgqs
	SFggQuJj/wp2EJtFQFXi3aUdYA28Am4S1+6eYoRYJydx8thk1gmM3AsYGVYxiqaWJhcUJ6Xn
	GukVJ+YWl+al6yXn525ihATj1x2MS49ZHWIU4GBU4uGdUOwbIsSaWFZcmXuIUYKDWUmE1/En
	UIg3JbGyKrUoP76oNCe1+BAjEwenVANj9uxXpYaeW6t8PrZpTHX3N+VQPps7sVP/dbCDapLG
	36pJXpfZt7FPO1Q8l2dG+7T3Jx8wG9xw0bt0PclRkil0Y1rOr6zWHaxHX2x/wCXAWbBScPlm
	ky1n6tVrje7EcG3v7rxSJeOuvUiVKeFgSJ7C43vnNx3JvanjN+OWg7BisJHUlSczWi4psRRn
	JBpqMRcVJwIAVZm37yQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Changes since v3
================
1. Dropped patch 3/4 ("mfd/regulator: dt-bindings: max77686: Document
   regulators off in suspend"), applied by Lee Jones.
2. Patch 2/3: Fix missing shift when checking if current opmode is
   equal to off in suspend. The shift is various so I added a simple
   function max77686_set_opmode_enable(). Dropped Javier's review-by.
3. Patch 1/3: Add Javier's review-by.
4. Patch 3/3: Add Chanwoo's review-by.

Changes since v2
================
1. Patch 1/4: Fully describe different values used for controlling
   the regulators (low power modes, enable, disable). Remove "opmode"
   from new defines. Suggested by Javier.
2. Patch 2/4: minor nits after changing patch 1.
3. Add Javier's reviewed-by to 2, 3 and 4 patch.
4. Patch 3/4 (changes in documentation) should be picked up by Lee
   Jones but I'm resending it anyway.

Changes since v1
================
1. Add patch 1/4 and 3/4.
2. Patch 2/4: Extend existing set_suspend_disable (for bucks) with
   LDO support. Implement set_suspend_enable. Suggested by Javier.
3. Patch 4/4: Add regulator suspend properties only to regulators
   actually supporting this. Other regulators, not implementing
   suspend enable/disable, will warn ("VCC_1.8V_IO: No configuration").
4. Patch 4/4: In suspend enable VHSIC_1.0V and VHSIC_1.8V regulators.
   Suggested by Chanwoo Choi.


Description
===========
This patchset makes use of Javier Martinez Cainllas changes [1].
It allows disabling some of the regulators during suspend to RAM.

Javier's patchset is necessary only to test it.

[1] [PATCH v3 0/2] ARM: EXYNOS: Call regulator suspend prepare/finish
    https://lkml.org/lkml/2014/10/20/545


Best regards,
Krzysztof


Krzysztof Kozlowski (3):
  regulator: max77686: Replace hard-coded opmode values with defines
  regulator: max77686: Implement suspend disable for some LDOs
  ARM: dts: exynos4412-trats: Add suspend configuration for max77686
    regulators

 arch/arm/boot/dts/exynos4412-trats2.dts |  72 +++++++++++++---------
 drivers/regulator/max77686.c            | 105 +++++++++++++++++++++++++++-----
 2 files changed, 133 insertions(+), 44 deletions(-)

-- 
1.9.1

