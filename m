Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaFBMf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:35:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44533 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaFBMfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:35:55 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-1e-538c6fa8a20d
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
Subject: [PATCH v2 0/7] ARM: EXYNOS: cpuidle: fix AFTR mode on boards with
 secure firmware enabled
Date: Mon, 02 Jun 2014 14:35:36 +0200
Message-id: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQd0V+T3BBnvuiVhsnLGe1WLeZ1mL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLM6cvsRqcfJPL6PF+hmvWSw2
	fvVw4PW4c20Pm8fmJfUet/89ZvbYcrWdxaNvyypGj8+b5ALYorhsUlJzMstSi/TtErgyDpxf
	w15wjKvi+f9TzA2Mezm6GDk4JARMJNp3uXUxcgKZYhIX7q1nA7GFBKYzSiydmtXFyAVkdzFJ
	tHTOZwZJsAlYSUxsX8UIYosIqEn0LN7KCFLELLCXWWJp9yZ2kISwQIrElx+7WUAWsAioSqy8
	aQdi8gp4SBxdJwqxS1Gi+9kEtgmM3AsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBAfY
	M6kdjCsbLA4xCnAwKvHw/lTvCRZiTSwrrsw9xCjBwawkwrvUAijEm5JYWZValB9fVJqTWnyI
	UZqDRUmc90CrdaCQQHpiSWp2ampBahFMlomDU6qBcdX277Lbz2i3fDnrWH6ieFvNvuOLDTSE
	PrzT+LVKu733ZMxxf5sdEidOnM3PClnWxr/p28W4pecV7h3bbVO40P0oz4afScW7XxY4aqiu
	OSdwrnjr7sZit8OOVc+FT3Z2hvs2XrLU+pq/vbz6mU7wnQAp/6M/tBXWm828dNnpuzLbp+33
	u3MSNyixFGckGmoxFxUnAgC+jacQLAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series fixes support for AFTR idle mode on boards with
secure firmware enabled (it also includes fix for register setup on
EXYNOS4x12 SoCs).  It has been tested on Trats2 target but should
also work on (EXYNOS4412 based) Insignal Origen board.

v2:
- synced against next-20140602
- added missing Acked-by-s

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


Bartlomiej Zolnierkiewicz (5):
  ARM: EXYNOS: add AFTR mode support to firmware do_idle method
  ARM: EXYNOS: PM: replace EXYNOS_BOOT_VECTOR_* macros by static inlines
  ARM: EXYNOS: PM: use c15resume firmware method if secure firmware is
    enabled
  ARM: EXYNOS: PM: fix register setup on EXYNOS4x12 for AFTR mode code
  ARM: EXYNOS: cpuidle: add secure firmware support to AFTR mode code

Kyungmin Park (1):
  arm: firmware: Check firmware is running or not

Tomasz Figa (1):
  ARM: EXYNOS: add support for firmware-assisted c15resume

 arch/arm/common/firmware.c       |  5 +++++
 arch/arm/include/asm/firmware.h  | 14 +++++++++++++-
 arch/arm/mach-exynos/firmware.c  | 18 ++++++++++++++++--
 arch/arm/mach-exynos/pm.c        | 40 ++++++++++++++++++++++++++++++++--------
 drivers/cpuidle/cpuidle-exynos.c |  7 ++++++-
 5 files changed, 72 insertions(+), 12 deletions(-)

-- 
1.8.2.3

