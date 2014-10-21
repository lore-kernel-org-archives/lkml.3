Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675AbaJUNUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:20:12 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18140 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334AbaJUNUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:20:09 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-c7-54465d860e07
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 0/4] regulator: max77686/trats2: Disable some regulators in
 suspend
Date: Tue, 21 Oct 2014 15:19:51 +0200
Message-id: <1413897595-28752-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t/xy7ptsW4hBv8+CFlsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DKePvPt6CNv+L//LlsDYztPF2M
	nBwSAiYSq6+vZIOwxSQu3FsPZHNxCAksZZRoWvQCyuljkvi1aQYzSBWbgLHE5uVLwDpEBDqZ
	Jb58DwApYhZYzSTx88opsCJhgQiJhuVHWEFsFgFViRXXTzCC2LwC7hKPe5cyQayTkzh5bDLr
	BEbuBYwMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCAvbLDsbFx6wOMQpwMCrx8G5Y5hoi
	xJpYVlyZe4hRgoNZSYQ3V9gtRIg3JbGyKrUoP76oNCe1+BAjEwenVAPjLMt5cSzyB/cHOMqL
	PTK52nDuH0vhzt+KXWfWbC0O8uFXnfDd5chXMZ+GPcWvGjb/W5CzofFg5bFF5Rn3Tzd843C5
	tmld9DGJ1qd1a5+vnDexsPVJXN3KlqzN813efP+cI3gx7eqDSI2iJPtim4I5bNv+MMTetTXk
	X/lbd9XdVp1w8ysz2CYrKrEUZyQaajEXFScCAD11KEk2AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


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
  regulator: max77686: Implement suspend disable for some LDOs
  mfd/regulator: dt-bindings: max77686: Document regulators off in
    suspend
  ARM: dts: exynos4412-trats: Add suspend configuration for max77686
    regulators

 Documentation/devicetree/bindings/mfd/max77686.txt |  6 ++
 arch/arm/boot/dts/exynos4412-trats2.dts            | 72 ++++++++++++---------
 drivers/regulator/max77686.c                       | 73 ++++++++++++++++++----
 3 files changed, 108 insertions(+), 43 deletions(-)

-- 
1.9.1

