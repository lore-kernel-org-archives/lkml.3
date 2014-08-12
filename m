Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaHLPMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 11:12:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35894 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaHLPMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 11:12:24 -0400
X-AuditID: cbfee61a-f79e46d00000134f-a9-53ea2ed5942c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v2 0/3] ARM: EXYNOS: Fix builds with PM_SLEEP=n
Date: Tue, 12 Aug 2014 17:11:54 +0200
Message-id: <1407856317-2457-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jAd2req+CDeZN0bbYOGM9q8W8z7IW
	r18YWvQuuMpmcbbpDbvFpsfXWC0u75rDZjHj/D4mi7VH7rJbnLr+mc1i84eXbBZXLp1is1g/
	4zWLA69HS3MPm8eda3vYPDYvqfe4cqKJ1aNvyypGj8+b5ALYorhsUlJzMstSi/TtErgytm+5
	y16wiati2qdFzA2Mxzm6GDk5JARMJM6+n8QKYYtJXLi3nq2LkYtDSGARo8TLxitQTheTxOmj
	P5lBqtgErCQmtq9iBLFFBNQkehZvZQQpYha4wyzxau9eli5GDg5hAXuJywt9QWpYBFQlDn96
	A1bPK+Au0bDrIzvENkWJ7mcT2CYwci9gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERxm
	z6R2MK5ssDjEKMDBqMTDW8H7KliINbGsuDL3EKMEB7OSCK/g7ZfBQrwpiZVVqUX58UWlOanF
	hxilOViUxHkPtFoHCgmkJ5akZqemFqQWwWSZODilGhg7L6xiKbTRNrvq7Nd+cu7kcnlep2mO
	fK5Snod+/75030ugot+899mbE69+iqTLsnC1prvt7/ybZ6DkYjV3zus1fTs/BtvvdRSrEZbq
	2r7L8VZ90cb3cibNTeHRJZcMP3AmeM59dHiqZlH6qj6JsuR3cdfPJ/64xKp1cX6js2fjs/sO
	4rfub1JiKc5INNRiLipOBAAleCm/LwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series fixes builds with CONFIG_PM_SLEEP config option
disabled.  It has been runtime tested on Exynos4210 based Origen
board.

Depends on:
- next-20140811 branch of linux-next kernel

Changes since v1:
(http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34079.html)
- rebased on top of next-20140811
- fixed OOPS on the first try to enter cpuidle AFTR mode
  (config with CONFIG_PM_SLEEP=n and CONFIG_ARM_EXYNOS_CPUIDLE=y)

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


Bartlomiej Zolnierkiewicz (3):
  ARM: EXYNOS: Fix build with PM_SLEEP=n and ARM_EXYNOS_CPUIDLE=n
  ARM: mm: Fix ifdef around cpu_*_do_[suspend,resume] ops
  ARM: EXYNOS: Fix build with PM_SLEEP=n and ARM_EXYNOS_CPUIDLE=y

 arch/arm/mach-exynos/Kconfig   |   5 +
 arch/arm/mach-exynos/Makefile  |   3 +-
 arch/arm/mach-exynos/common.h  |   4 +
 arch/arm/mach-exynos/exynos.c  |   2 +
 arch/arm/mach-exynos/pm.c      | 262 +-------------------------------------
 arch/arm/mach-exynos/suspend.c | 279 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/mm/proc-macros.S      |   2 +-
 arch/arm/plat-samsung/Makefile |   1 +
 8 files changed, 299 insertions(+), 259 deletions(-)
 create mode 100644 arch/arm/mach-exynos/suspend.c

-- 
1.8.2.3

