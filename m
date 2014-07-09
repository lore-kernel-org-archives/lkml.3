Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbaGIRTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:19:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59957 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbaGIRTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:19:09 -0400
X-AuditID: cbfee61a-f79e46d00000134f-e6-53bd7962628d
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v3 0/4] ARM: EXYNOS: cpuidle: fix AFTR mode on boards with
 secure firmware enabled
Date: Wed, 09 Jul 2014 19:17:50 +0200
Message-id: <1404926274-18411-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jAd2kyr3BBsfe8VpsnLGe1WLeZ1mL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLM6cvsRqcfJPL6PF+hmvWSw2
	fvVw4PW4c20Pm8fmJfUet/89ZvbYcrWdxaNvyypGj8+b5ALYorhsUlJzMstSi/TtErgyLs1b
	yFzwlafiya5p7A2Md7i6GDk5JARMJJ492cMOYYtJXLi3nq2LkYtDSGARo8TRvkZ2CKeLSWLm
	lD9gVWwCVhIT21cxgtgiAmoSPYu3MoIUMQvsZZZY2r0JrEhYIEViy6OTTCA2i4CqRMvCM8xd
	jBwcvAIeEleWZkJsU5TofjaBbQIj9wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwWH2
	TGoH48oGi0OMAhyMSjy8Cjx7goVYE8uKK3MPMUpwMCuJ8N4q2RssxJuSWFmVWpQfX1Sak1p8
	iFGag0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJg1OqgfHIpplfHQ1MvjOkTzrIumv6X577U85K
	KgnV3jBZHLCod8Py78cdD/bw2n2IXZLpvqfC36uk9tHKbdtX1kvyrjjs4/D1veas/VO8Tm1i
	vxB7JnipBEOy/VXZlnuXpjYZn2zOl9f53XGu7UXr+qLaFyJnwjp333U1bP4o4MjHyL0j7Naa
	A3sSTyxXYinOSDTUYi4qTgQAH/vHji8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series adds support for AFTR idle mode on boards with
secure firmware enabled and allows EXYNOS cpuidle driver usage on
Exynos4x12 SoCs.

It has been tested on Trats2 board (using Exynos4412 SoC with secure
firmware enabled) on which AFTR mode reduces power consumption by ~12%
when EXYNOS cpuidle driver is enabled (in both cases the default
exynos_defconfig config is used and CPU1-3 are offlined).

v3:
- rebased on top of next-20140708 +
  http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32809.html
  (with rejects fixed)
  http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32808.html
  http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32991.html
  (with rejects fixed in patch #2)
- addressed review comments from Tomasz Figa and Daniel Lezcano

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


Bartlomiej Zolnierkiewicz (4):
  ARM: EXYNOS: PM: replace EXYNOS_BOOT_VECTOR_* macros by static inlines
  ARM: EXYNOS: add AFTR mode support to firmware do_idle method
  ARM: EXYNOS: cpuidle: add secure firmware support to AFTR mode code
  ARM: EXYNOS: cpuidle: allow driver usage on Exynos4x12 SoCs

 arch/arm/include/asm/firmware.h  |  2 +-
 arch/arm/mach-exynos/common.h    |  7 ++++++-
 arch/arm/mach-exynos/exynos.c    |  3 ++-
 arch/arm/mach-exynos/firmware.c  | 36 ++++++++++++++++++++++++++----------
 arch/arm/mach-exynos/pm.c        | 39 +++++++++++++++++++++++++++++----------
 drivers/cpuidle/cpuidle-exynos.c |  6 +++---
 6 files changed, 67 insertions(+), 26 deletions(-)

-- 
1.8.2.3

