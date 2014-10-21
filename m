Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbaJULYC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:24:02 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48872 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065AbaJULYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:24:00 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-90-5446424d641f
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
Subject: [PATCH v2 0/4] regulator: max77686/trats2: Disable some regulators in
 suspend
Date: Tue, 21 Oct 2014 13:23:13 +0200
Message-id: <1413890597-31037-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xK7q+Tm4hBn8/8VpsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gtvl3pYLLY9Pgaq8XlXXPYLGac
	38dkcfsyr8XaI3fZHfg9Wpp72Dz+Pr/O4vF31Qtmj52z7rJ7bFrVyeaxeUm9R9+WVYwenzfJ
	BXBEcdmkpOZklqUW6dslcGVcuzGDueAad8XipaeYGhjXcnYxcnJICJhIfJ+6hxHCFpO4cG89
	WxcjF4eQwFJGif+XtzJBOH1MEr3broNVsQkYS2xevoQNxBYR2M8k8XiCCUgRs8BqJomfV04x
	gySEBSIkvuzuAytiEVCV+PR6IlicV8BdYseHzWwQ6+QkTh6bzDqBkXsBI8MqRtHU0uSC4qT0
	XCO94sTc4tK8dL3k/NxNjJBw/LqDcekxq0OMAhyMSjy8EUtcQ4RYE8uKK3MPMUpwMCuJ8OYK
	u4UI8aYkVlalFuXHF5XmpBYfYmTi4JRqYHTadvkjj/ls//0vHa8kHDzjzceVertt7+4eC5bo
	9P+cgluT9s1Y//P5tbqXZo+OfMtbclz/k//fvY8u7WJkKm7yXmHJoFp579OC7Ytqz3K0OblI
	v/xy4yOrw7LUnca/kvQt95916uW5tnJXaDZf6/RrzjsOVS1clWr6wMvNcatwvmSv9KO3uslK
	LMUZiYZazEXFiQDSdJGdJQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


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
 arch/arm/boot/dts/exynos4412-trats2.dts            | 72 +++++++++++++---------
 drivers/regulator/max77686.c                       | 58 +++++++++++++----
 3 files changed, 94 insertions(+), 42 deletions(-)

-- 
1.9.1

