Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab3K1IJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:09:59 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21097 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab3K1IJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:09:57 -0500
X-AuditID: cbfec7f4-b7fea6d0000026ac-5b-5296fa5352d4
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 0/5] rtc: s5m: Bug fixes of the driver after tests
Date: Thu, 28 Nov 2013 09:09:38 +0100
Message-id: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgluLIzCtJLcpLzFFi42I5/e/4Fd3gX9OCDP42mVosuXiV3WLqwyds
	Fs9u7WWyeP3C0OJs0xt2i/tfjzJafLvSwWRxedccNou1R+6yW+zv7GC0ON3NanFxxRcmBx6P
	nbPusnvsmXiSzWPTqk42jzvX9rB5HDrcwegx72SgR9+WVYwe0+f9ZPL4vEkugDOKyyYlNSez
	LLVI3y6BK6OrcxZ7wS2uiuNLzRsY13B0MXJySAiYSHz9s4YVwhaTuHBvPVsXIxeHkMBSRomJ
	01cxQzh9TBINi66yg1SxCRhLbF6+BKxKRGAuk8T0t2cZQRxmgV2MEm9/7mIEqRIWcJX4PvMt
	E4jNIqAqsb+pGczmFXCXmH3/HlANB9A+BYk5k2wmMHIvYGRYxSiaWppcUJyUnmuoV5yYW1ya
	l66XnJ+7iRESel92MC4+ZnWIUYCDUYmH94DmtCAh1sSy4srcQ4wSHMxKIrwKxUAh3pTEyqrU
	ovz4otKc1OJDjEwcnFINjKVtaRlMLpfN5ghZFM0V0Mj54+yfl5TX3Df354U1dtHf+PI5P/mc
	i171KGCDR41cwY2FQdUlX7j3+Qb/Ofza9ztbalSXtHV2LvutLiWFZ32/rxbG8strfn17pX66
	Q/G34yk7ivM2lZn5zWtK8lRl+FTScuf00dVHjwj9PHx0U1fH9YYboj66SizFGYmGWsxFxYkA
	mjgzPRsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is a second version of patchset of small but important fixes for rtc-s5m
driver. Last patches also add waking up on RTC alarm interrupts.

The patchset is based on v3.13-rc1-229-ge7c0d3d and depends on patch from 
Geert Uytterhoeven:
 - rtc: s5m-rtc: Fix info->rtc assignment
   http://article.gmane.org/gmane.linux.kernel/1595905


Changes since v2:
-----------------
1. Applied suggestions from Geert Uytterhoeven (add const, regmap member
   rename).
2. Added patch "mfd: sec: Constify regmap configs and regmap irqs".
3. Removed "mfd: sec: Add PM ops and make it a wake up source" from patchset
   as this was applied by Lee Jones.


Best regards,
Krzysztof Kozlowski

Krzysztof Kozlowski (5):
  mfd/rtc: s5m: Fix register updating by adding regmap for RTC
  rtc: s5m: Fix unsuccesful IRQ request during probe
  rtc: s5m: Limit endless loop waiting for register update
  rtc: s5m: Enable IRQ wake during suspend
  mfd: sec: Constify regmap configs and regmap irqs

 drivers/mfd/sec-core.c           |   38 ++++++++++++++-------
 drivers/mfd/sec-irq.c            |   18 +++++-----
 drivers/regulator/s5m8767.c      |    2 +-
 drivers/rtc/rtc-s5m.c            |   70 +++++++++++++++++++++++++++++++++-----
 include/linux/mfd/samsung/core.h |    3 +-
 5 files changed, 99 insertions(+), 32 deletions(-)

-- 
1.7.9.5

