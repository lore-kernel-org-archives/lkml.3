Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3JIGat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:30:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37377 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab3JIGan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:30:43 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-3d-5254f7eddd31
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, kgene.kim@samsung.com
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v2 0/5] thermal: exynos: Fixes for v3.12
Date: Wed, 09 Oct 2013 08:29:49 +0200
Message-id: <1381300194-13134-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t9jQd2330OCDC7/M7JouBpisXHGelaL
	+UfOsVqs2f+TyaLz7BNmi94FV9ks3jzitnjzcDOjxeVdc9gsPvceYbSYcX4fk8XtxhVsFmdO
	X2K1ePKwj81i/YzXLA78Hov3vGTyWDftLbPHlqvtLB59W1Yxehy/sZ3J4/MmuQC2KC6blNSc
	zLLUIn27BK6M7697WApOclVc/j2HpYFxCUcXIyeHhICJxOnHq9ggbDGJC/fWA9lcHEIC0xkl
	dj3uZQVJCAl0MUl0toM1sAnoSXy++5QJxBYRyJA4dWk2E0gDs8BfZonr046xgCSEBSwkpk16
	ADaVRUBVYub0xcwgNq+Am8Tj/T/YIbbJSzy93wdWwyngLtH+dAojxDI3ibePtrJMYORdwMiw
	ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4WJ9J7WBc2WBxiFGAg1GJh/cBf0iQEGtiWXFl
	7iFGCQ5mJRHevIVAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0DhQTSE0tSs1NTC1KLYLJM
	HJxSDYwuP/sqT5rlmsaEFaREvz0V79B8TPm46eZ7fO0vH96aH1sutUjvctS2QE8DQ9snez5+
	fZj2K+TQ5Tt7/4tYHFp2tPHDHJcVj8P0M7dH7N7/xf6i5/z2TTsrBSdk83fW/brfPGnPf8Yl
	awwmWLS02Txp53hSanr0pjXD+9W+19YsnLXhvs6FjPn7lFiKMxINtZiLihMBnxv84lICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is divided into two parts:
1. Device tree node definition and enabelement for TMU at Exynos4412 (Trats2)
2. Exynos thermal subsystem regressions for v3.12-rc4. Several commits were 
   necessary to properly fix regression for TMU test MUX address setting after
   reset.

Test HW:
- Exynos4412 - TRATS2 board (Linux v3.12-rc4)
SHA1: 8b5ede69d24db939f52b47effff2f6fe1e83e08b


Lukasz Majewski (5):
  thermal: exynos: Remove check for thermal device pointer at
    exynos_report_trigger()
  thermal: exynos: Provide separate TMU data for Exynos4412
  thermal: exynos: Provide initial setting for TMU's test MUX address
    at Exynos4412
  ARM: dts: exynos4x12: Device tree node definition for TMU on
    Exynos4x12
  ARM: dts: exynos4412-trats2: Enable TMU support at Trats2

 arch/arm/boot/dts/exynos4412-trats2.dts         |    5 ++++
 arch/arm/boot/dts/exynos4x12.dtsi               |   10 ++++++++
 drivers/thermal/samsung/exynos_thermal_common.c |    2 --
 drivers/thermal/samsung/exynos_tmu.c            |   12 ++++++---
 drivers/thermal/samsung/exynos_tmu.h            |    7 +++++-
 drivers/thermal/samsung/exynos_tmu_data.c       |   30 ++++++++++++++++++-----
 drivers/thermal/samsung/exynos_tmu_data.h       |   13 +++++++++-
 7 files changed, 65 insertions(+), 14 deletions(-)

-- 
1.7.10.4

