Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaJ0MOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:14:45 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:18501 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaJ0MMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:12:03 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-7f-544e3690838d
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
Subject: [PATCH v5 0/4] regulator: max77686/trats2: Disable some regulators in
 suspend
Date: Mon, 27 Oct 2014 13:11:46 +0100
Message-id: <1414411911-5539-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xy7oTzPxCDNZOELfYOGM9q8WkdQeY
	LKY+fMJmcf3Lc1aL+UfOsVoc/V1g8fqFoUXvgqtsFmeb3rBbfLvSwWSx6fE1VovLu+awWcw4
	v4/J4vZlXou1R+6yO/B7tDT3sHn8fX6dxePvqhfMHjtn3WX32LSqk81j85J6j74tqxg9Pm+S
	C+CI4rJJSc3JLEst0rdL4Mq4fbObraBNrGJVy3/mBsYXgl2MnBwSAiYS575eY4awxSQu3FvP
	1sXIxSEksJRR4t/No1BOH5PE578HmUCq2ASMJTYvX8IGYosI7GeSeDzBBKSIWWA1k8TPK6fA
	RgkLREhMPr6QFcRmEVCVePB2K1gDr4CbxJbnh1kg1slJnDw2mXUCI/cCRoZVjKKppckFxUnp
	uUZ6xYm5xaV56XrJ+bmbGCHh+HUH49JjVocYBTgYlXh4JxT7hgixJpYVV+YeYpTgYFYS4XX8
	CRTiTUmsrEotyo8vKs1JLT7EyMTBKdXAeDWO9WbgwTdRXjn1SxjZCleI7zc76pbd0hLw+tjn
	soBrcRNfs1yKkPtY9lFU9JTdew2m251dDA9fMZ15bhCns1drcaX6tys+s64/zPiocXES0+eQ
	DQ+0rn2amrlsIYvexI3nP/5OnKeV+zO7bN4efvFUQ4EFx8ol+s4sfRuyWCJaeIfHJrlPZ5RY
	ijMSDbWYi4oTAbUfbbklAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


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


Krzysztof Kozlowski (4):
  regulator: max77686: Replace hard-coded opmode values with defines
  regulator: max77686: Store opmode non-shifted
  regulator: max77686: Implement suspend disable for some LDOs
  ARM: dts: exynos4412-trats: Add suspend configuration for max77686
    regulators

 arch/arm/boot/dts/exynos4412-trats2.dts | 72 +++++++++++++++++------------
 drivers/gpu/arm/mali400/ump/arch        |  1 +
 drivers/regulator/max77686.c            | 81 +++++++++++++++++++++++++--------
 3 files changed, 105 insertions(+), 49 deletions(-)
 create mode 120000 drivers/gpu/arm/mali400/ump/arch

-- 
1.9.1

