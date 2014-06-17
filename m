Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964874AbaFQR2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:28:15 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25684 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974AbaFQR2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:28:13 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-5d-53a07aaa46cf
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 0/9] thermal: exynos: various cleanups
Date: Tue, 17 Jun 2014 19:27:16 +0200
Message-id: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e+xoO6qqgXBBjfvmFo0XA2x2DhjPavF
	mv0/mSzONr1ht7i8aw6bxefeI4wWM87vY7I4c/oSq8WTh31sFutnvGZx4PJYvOclk8eWq+0s
	Hn1bVjF6HL+xncnj8ya5ANYoLpuU1JzMstQifbsEroztE7YyF9zkq9j+ZyZ7A+Mv7i5GTg4J
	AROJ9tVTGCFsMYkL99azdTFycQgJTGeUmPfkEDuE08UkcfvvaRaQKjYBK4mJ7avAOkQE9CRu
	vHjCBFLELHCcSeLn7/NA7RwcwgKWEq/uiIDUsAioSszY8Z0dxOYV8JD48fkGO8Q2RYnuZxPY
	JjByL2BkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHELPpHYwrmywOMQowMGoxMPLkbsg
	WIg1say4MvcQowQHs5II77ksoBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6Yklqdmp
	qQWpRTBZJg5OqQbGUEv1TyVqEzL1X7jrvdRo/F9qV6m9PWLZthurbX9ObHF4bxo313J6Qq9T
	UEb4jhBl44PT6r1Vc8494H4QWaF7Satl93GzLvb01KV/fQt2S/QoPdXb8MJnvdz6SyGheW7b
	lX61PJPl0D6pscVsto6dLcvTaxe7ZSKYOYSnrs15tJLh1ly1XG4lluKMREMt5qLiRADBiivb
	HQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series contains various cleanups for EXYNOS thermal
driver.  Overall it decreases driver's LOC by 12%.  It is based
on next-20140617 kernel.  It should not cause any functionality
changes.

Changes since v1:
- synced patches against next-20140617
- merged patch "thermal: exynos: remove unused defines" into
  "thermal: exynos: remove unused struct exynos_tmu_registers
  entries" one (per request from Eduardo)
- improved patch descriptions for patches #1-5
- fixed documentation for pdata->gain and pdata->reference_voltage
- added Reviewed-by from Amit to patches #6, #7 and #10
- added missing Acked-by from Kyungmin Park

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


Bartlomiej Zolnierkiewicz (9):
  thermal: exynos: remove unused struct exynos_tmu_registers entries
  thermal: exynos: remove dead code for HW_MODE calibration
  thermal: exynos: remove dead code for TYPE_TWO_POINT_TRIMMING
    calibration
  thermal: exynos: remove redundant pdata checks from
    exynos_tmu_initialize()
  thermal: exynos: remove redundant threshold_code checks from
    exynos_tmu_initialize()
  thermal: exynos: simplify temp_to_code() and code_to_temp()
  thermal: exynos: cache non_hw_trigger_levels in pdata
  thermal: exynos: remove redundant pdata checks from
    exynos_tmu_control()
  thermal: exynos: remove identical values from exynos*_tmu_registers
    structures

 drivers/thermal/samsung/exynos_thermal_common.h |   1 -
 drivers/thermal/samsung/exynos_tmu.c            | 181 ++++--------------------
 drivers/thermal/samsung/exynos_tmu.h            |  90 +-----------
 drivers/thermal/samsung/exynos_tmu_data.c       |  64 +--------
 drivers/thermal/samsung/exynos_tmu_data.h       |  33 +----
 5 files changed, 41 insertions(+), 328 deletions(-)

-- 
1.8.2.3

