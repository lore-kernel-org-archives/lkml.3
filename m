Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaJ0P3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:29:31 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31569 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaJ0P33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:29:29 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-8a-544e64d7ee7e
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
Subject: [PATCH 0/8] regulator: max77686: Add GPIO control
Date: Mon, 27 Oct 2014 16:03:38 +0100
Message-id: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsVy+t/xa7rXU/xCDB581LPYOGM9q8WkdQeY
	LKY+fMJmcf3Lc1aL+UfOsVoc/V1g8fqFoUXvgqtsFmeb3rBb3P96lNHi25UOJotNj6+xWlze
	NYfNYsb5fUwWty/zWqw9cpfd4nQ3q4OgR0tzD5vH3+fXWTz+rnrB7LFz1l12j02rOtk87lzb
	w+Yx72Sgx+Yl9R59W1YxenzeJBfAFcVlk5Kak1mWWqRvl8CVcaHjK1vBB56KNwdusjcwvufs
	YuTkkBAwkWjsPsQOYYtJXLi3nq2LkYtDSGApo8T12a8YIZw+JomTz1axgFSxCRhLbF6+BKxK
	RKCTWaLnYC8ziMMssJpJ4ueVU8wgVcICVhJ/dhxjBbFZBFQlfr5oYAOxeQXcJQ7duswEsU9O
	4uSxyawTGLkXMDKsYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAgJ2q87GJceszrEKMDBqMTD
	O6HYN0SINbGsuDL3EKMEB7OSCO+pAL8QId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYxB36zTF0pc
	+7ZZavVEe/+LKWF8Dt+l5pokPemWEF1XeJrb9QZj/zrrvjY+vbcv7+86INq6vbiE0TGft8l/
	C9PFvbut3LlNvJ/c//tQa9k9fuHsbdKe8qWLJpYp1zSeynNoO9Q2aVpthefEfStLDh04fM1k
	VmnMdwXFmlXblhsJTN/wmWUWk4ISS3FGoqEWc1FxIgDsTqZWOAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


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
  regulator: max77802: Remove support for board files
  regulator: max77686: Remove support for board files
  mfd: max77686/802: Remove support for board files
  regulator: max77686: Make regulator_desc array const
  regulator: max77686: Initialize opmode explicitly to normal mode
  regulator: max77686: Add external GPIO control
  mfd/regulator: dt-bindings: max77686: Document gpio property
  ARM: dts: exynos4412-trats: Switch max77686 regulators to GPIO control

 Documentation/devicetree/bindings/mfd/max77686.txt |   3 +
 arch/arm/boot/dts/exynos4412-trats2.dts            |  25 +---
 drivers/mfd/max77686.c                             |  23 ---
 drivers/regulator/max77686.c                       | 158 +++++++++++++++------
 drivers/regulator/max77802.c                       |  44 ++----
 include/linux/mfd/max77686-private.h               |   1 -
 include/linux/mfd/max77686.h                       |  22 ---
 7 files changed, 141 insertions(+), 135 deletions(-)

-- 
1.9.1

