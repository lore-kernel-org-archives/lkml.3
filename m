Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab3IXIIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:08:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44855 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3IXIIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:08:41 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-0e-52414882e89b
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 0/6] thermal: exynos: Fixes for v3.12
Date: Tue, 24 Sep 2013 10:08:16 +0200
Message-id: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsVy+t9jAd0mD8cggzkTbSwaroZYbJyxntVi
	/pFzrBZr9v9ksug8+4TZ4s0jbos3DzczWlzeNYfN4nPvEUaLGef3MVncblzBZtG/sJfJ4snD
	PjaL9TNeszjweSze85LJY920t8wefVtWMXo8WtzC6HH8xnYmj8+b5ALYorhsUlJzMstSi/Tt
	Ergy5qxOKLjDVTF7O2cD42aOLkZODgkBE4nzWw8yQdhiEhfurWfrYuTiEBJYxCjxs/cRK4TT
	xSTR2/mdBaSKTUBP4vPdp0wgCRGBJkaJH0e+MYMkmAWOMUt8WSUCYgsLmEqcWHaTHcRmEVCV
	+N1wkw3E5hVwk9hxoI0NYp28xNP7fWwTGLkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/d
	xAgOuGdSOxhXNlgcYhTgYFTi4d3h7RAkxJpYVlyZe4hRgoNZSYT3hq1jkBBvSmJlVWpRfnxR
	aU5q8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWpRTBZJg5OqQZG+ZuuFypzQ7bEM78P3XnFcf2x
	qetVdrDEfA+W1N/+decsgW2aT8/ONOI+G+p4f5b1orWs4i/966b5/NqZLNzCxPEjvIdD4jXz
	zAlJeq8OyntWdTVMUW7f58TJ/ZTx3/ulspyrVbKdFVXTnrzO3lubFHkjzPflZb704x41V6Z/
	e8Ht6HhkWUq/EktxRqKhFnNRcSIATgDgADQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is divided into two parts:
1. Device tree node definition and enabelement for TMU at Exynos4412 (Trats2)
2. Exynos thermal subsystem regressions for v3.12-rc1. Several commits were 
   necessary to properly fix regression for TMU test MUX address setting after
   reset.

Test HW:
- Exynos4412 - TRATS2 board (Linux v3.12-rc1)

Lukasz Majewski (6):
  thermal: exynos: fix: Return from exynos_report_trigger() when
    therm_dev is NULL
  thermal: exynos: Provide separate TMU data for Exynos4412
  thermal: exynos: Provide initial setting for TMU's test MUX address
    at Exynos4412
  thermal: exynos: Replace SOC_ARCH_EXYNOS with SOC_ARCH_EXYNOS5250
  ARM: dts: exynos4x12: Device tree node definition for TMU on
    Exynos4x12
  ARM: dts: exynos4412-trats2: Enable TMU support at Trats2

 arch/arm/boot/dts/exynos4412-trats2.dts         |    5 +++++
 arch/arm/boot/dts/exynos4x12.dtsi               |   10 +++++++++
 drivers/thermal/samsung/exynos_thermal_common.c |    2 +-
 drivers/thermal/samsung/exynos_tmu.c            |   12 +++++++----
 drivers/thermal/samsung/exynos_tmu.h            |    3 ++-
 drivers/thermal/samsung/exynos_tmu_data.c       |   26 +++++++++++++++++------
 drivers/thermal/samsung/exynos_tmu_data.h       |   13 +++++++++++-
 7 files changed, 58 insertions(+), 13 deletions(-)

-- 
1.7.10.4

