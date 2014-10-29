Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627AbaJ2LPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:15:14 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17298 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbaJ2LPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:15:10 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-12-5450cc3b5c76
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
Subject: [PATCH v6 0/3] regulator: max77686/trats2: Disable some regulators in
 suspend
Date: Wed, 29 Oct 2014 12:14:51 +0100
Message-id: <1414581294-1315-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e/4NV3rMwEhBrseGVhsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gtvl3pYLLY9Pgaq8XlXXPYLGac
	38dkcfsyr8XaI3fZHfg9Wpp72Dz+Pr/O4vF31Qtmj52z7rJ7bFrVyeaxeUm9R9+WVYwenzfJ
	BXBEcdmkpOZklqUW6dslcGV8/XSJqeCpWMXLNTENjMuEuhg5OCQETCSajmt2MXICmWISF+6t
	Z+ti5OIQEljKKDFv9k9WkISQQB+TxP95aiA2m4CxxOblS9hAbBGB/UwSjyeYgDQwC6xmkvh5
	5RQzyFBhgQiJhtNVIDUsAqoSB96fZAGxeQXcJN5/O8kMsUxO4uSxyawTGLkXMDKsYhRNLU0u
	KE5KzzXSK07MLS7NS9dLzs/dxAgJw687GJceszrEKMDBqMTDG3EsIESINbGsuDL3EKMEB7OS
	CO+7vUAh3pTEyqrUovz4otKc1OJDjEwcnFINjOs2iFSnNvFNu/7SztpqbcxprXJ1DptZz8KP
	bE6aELZ87m7dyWyTq5j8Z/52btrzLWD9NCHx7GvtCVE5u3f7L8sITrPd49IZqcZdIGfsFh/E
	IZUUvC714cze6XK2p676XVxw2c3bTOnGrk1pwllPVv1R0LaI+//u1pr81aw3heR+8U51Ye6b
	psRSnJFoqMVcVJwIABHAH0EhAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Changes since v5
================
1. Remove patch 1 and 2 - applied.
2. Patch 1/3: remove suspend_enable functions (suggested by Mark Brown).
3. Patch 1/3: Add Javier's reviewed-by.
4. Add patch 2/3: remove suspend_enable for max77802 also.

Changes since v4
================
1. New patch: 2/4. Store the current value of opmode in
   non-shifted form. Along with changes in defines used for opmodes
   this simplifies everything a lot. Suggested by Javier.
2. Drop Javier's review-by from patch 1 because I changed the
   defines to cover both LDO and buck at the same time.
3. Patch 3/4: adding suspend disable is now simpler - just re-use
   the existing function.

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
  regulator: max77686: Add suspend disable for some LDOs
  regulator: max77802: Remove suspend_enable
  ARM: dts: exynos4412-trats: Add suspend configuration for max77686
    regulators

 arch/arm/boot/dts/exynos4412-trats2.dts | 72 +++++++++++++++++++--------------
 drivers/regulator/max77686.c            | 12 ++++--
 drivers/regulator/max77802.c            |  4 --
 3 files changed, 50 insertions(+), 38 deletions(-)

-- 
1.9.1

