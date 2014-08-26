Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbaHZBbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 21:31:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44204 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbaHZBbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 21:31:16 -0400
X-AuditID: cbfee68e-f79536d000000fd1-7e-53fbe362fc66
From: Chanwoo Choi <cw00.choi@samsung.com>
To: eduardo.valentin@ti.com, amit.daniel@samsung.com, rui.zhang@intel.com
Cc: kgene.kim@samsung.com, ch.naveen@samsung.com, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv5 0/4] thermal: exynos: Add support for TRIMINFO feature of
 Exynos3250
Date: Tue, 26 Aug 2014 10:31:01 +0900
Message-id: <1409016665-3824-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsWyRsSkRDfp8e9gg9MvuC0aroZYbJyxntXi
	7vPDjBbXvzxntViz/yeTRe+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8niycM+Ngce
	j8V7XjJ5bF5S79G3ZRWjx/Eb25k8Pm+SC2CN4rJJSc3JLEst0rdL4Mr43XiKpeAQX8WxvUvZ
	Gxj/cHcxcnJICJhI7Dh1kRnCFpO4cG89WxcjF4eQwFJGiea9axhhivq6FrNAJKYzSrzffJ0V
	wmlikpjc+4wNpIpNQEti/4sbYLaIgKfE3IUtTCBFzAKTmCQ+P/oMlhAWiJD4duAO0CgODhYB
	VYmeVewgYV4BF4l9SxrZILbJSXzY84gdpFdCYBG7xMJ1G8DOYBEQkPg2+RBYr4SArMSmA1Bn
	S0ocXHGDZQKj4AJGhlWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYgWF++t+zvh2MNw9YH2IU
	4GBU4uG9Ef87WIg1say4MvcQoynQhonMUqLJ+cBoyiuJNzQ2M7IwNTE1NjK3NFMS502Q+hks
	JJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgVGVdebpw77smmsSy0vDXpRMdGYOPheTqMP9/ejR
	kisdhnGOG+492/rd53GaXXfUbod3PP8jjqfsjVA480P3z1b5IveLjeZzLLi66mSfm/FP5/Cc
	cWe1/KZvRsuzFl9tL698YiK18q4j367Eue5KtlPOqsReUnpzgO3dr6Wfn3FNrVWct0b4jIgS
	S3FGoqEWc1FxIgDCr65abgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t9jQd2kx7+DDS5uZbZouBpisXHGelaL
	u88PM1pc//Kc1WLN/p9MFr0LrrJZnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLJw/72Bx4
	PBbvecnksXlJvUffllWMHsdvbGfy+LxJLoA1qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7U
	zMBQ19DSwlxJIS8xN9VWycUnQNctMwfoPCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFB
	cD1GBmggYQ1jxu/GUywFh/gqju1dyt7A+Ie7i5GTQ0LARKKvazELhC0mceHeerYuRi4OIYHp
	jBLvN19nhXCamCQm9z5jA6liE9CS2P/iBpgtIuApMXdhCxNIEbPAJCaJz48+gyWEBSIkvh24
	AzSWg4NFQFWiZxU7SJhXwEVi35JGNohtchIf9jxin8DIvYCRYRWjaGpBckFxUnquoV5xYm5x
	aV66XnJ+7iZGcBQ9k9rBuLLB4hCjAAejEg/vjfjfwUKsiWXFlbmHGCU4mJVEeBkeAoV4UxIr
	q1KL8uOLSnNSiw8xmgItn8gsJZqcD4zwvJJ4Q2MTMyNLI3NDCyNjcyVx3gOt1oFCAumJJanZ
	qakFqUUwfUwcnFINjBmJ4rKRtnsD3n77Y39zhvfTDKbnq2L+vm2RSfu/7Mjm/T0Ll3/f7MbJ
	Vfx0Q6Ts3frNhWp7fuZzP9yx5LyCtl6UL8eyQ5qa9aIVTJKSe4p13lcc07Zb7S3MNv1dy/md
	MZ9kE/MMEv0Cl0fILJ2hPGM+p6/5ZZ61+2pY42QbGUyWLNwvY/dKWImlOCPRUIu5qDgRAA2l
	hSW4AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add the support of TRIMINFO_RELOAD feature for Exynos3250.
But Exynos3250 has two TRIMINFO_CTRL register instead other Exynos has only one
TRIMINFO_CTRL register. So, this patchset support the some Exynos SoC which
has more than one TRIMINF_CTRL.

Also, this patchset fix wrong value of TRIMINFO_RELOAD_SHIFT and remove
duplicate code when reading triminfo register of Exynos5440.

Changes from v4:
- Remove un-necessary triminfo_ctrl_{shift, mask} field
- Includes Bartlomiej's patch[1] that Exynos5260 / Exynos5420 should not use
TRIM_RELOAD flag
[2] https://lkml.org/lkml/2014/8/20/481

Changes from v3:
- Add reviewed message of Amit Daniel Kachhap <amit.daniel@samsung.com>
- Split RELOAD patch as two patch
- Fix 'TRIMINFO_RELOAD_SHIFT' value
- This series includes separate patch[1]
[1] https://lkml.org/lkml/2014/8/20/5
- Drop ACTIME bit setting because TRM includes not enough information of ACTIME bit.

Changes from v2:
- Fix build break because of missing 'or' operation.

Changes from v1:
- Add missing 'TMU_SUPPORT_TRIM_RELOAD' features

Bartlomiej Zolnierkiewicz (1):
  thermal: samsung: Exynos5260 and Exynos5420 should not use TRIM_RELOAD flag

Chanwoo Choi (3):
  thermal: exynos: Add support for many TRIMINFO_CTRL registers
  thermal: exynos: Add support for TRIM_RELOAD feature at Exynos3250
  thermal: exynos: Remove duplicate code when reading triminfo register of Exynos5440

 drivers/thermal/samsung/exynos_thermal_common.h |  1 +
 drivers/thermal/samsung/exynos_tmu.c            | 19 +++++++++++------
 drivers/thermal/samsung/exynos_tmu.h            |  9 ++++----
 drivers/thermal/samsung/exynos_tmu_data.c       | 28 ++++++++++++++-----------
 drivers/thermal/samsung/exynos_tmu_data.h       |  9 +++++---
 5 files changed, 40 insertions(+), 26 deletions(-)

-- 
1.8.0

