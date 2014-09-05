Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbaIENxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:53:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55121 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323AbaIENwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:52:16 -0400
X-AuditID: cbfee61b-f79f86d00000144c-f9-5409c00eac37
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v6 0/5] ARM: EXYNOS: cpuidle: fix AFTR mode on boards with
 secure firmware enabled
Date: Fri, 05 Sep 2014 15:51:23 +0200
Message-id: <1409925088-4705-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t9jAV2+A5whBm8Oa1psnLGe1WLeZ1mL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLM6cvsRqcfJPL6PFxq8eDjwe
	d67tYfPYvKTe4/a/x8weW662s3j0bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXxt4P29kLtshU
	7N93iamBsU2ii5GDQ0LAROLndJ4uRk4gU0ziwr31bF2MXBxCAosYJXbO2MQO4XQxSXw7NIsF
	pIpNwEpiYvsqRhBbREBNomfxVkaQImaB2cwSrx4+YAGZKiyQIrG9E6yeRUBV4tjm74wgYV4B
	d4l7t0shlilKdD+bwDaBkXsBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODAeia9g3FV
	g8UhRgEORiUe3gWfOUKEWBPLiitzDzFKcDArifDa7uYMEeJNSaysSi3Kjy8qzUktPsQozcGi
	JM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cDYrFa7lFXq1XbpW/ILd7w9ljBlw5JNzs/qfAoe
	et75ZrK4XqmNMff49W25LE/fmUwp3bB7ee3t9BoRt++BflNfKp/quK87dcGjqaqXggKuCu1g
	vrryt5l3ZJnHX4ct//eaB2qofjg45dK1sx0N6YrTXuy4P3fzPbG8ZaWMYg/akg6HuNYtLtxq
	ocRSnJFoqMVcVJwIANu8TX4oAgAA
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

Currently Exynos4412 SoC support is limited to Trats2 board.

Depends on:
- next-20140904 branch of linux-next kernel tree
- "irqchip: Properly fetch the per cpu offset" patch
  (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg716674.html)
- [PATCH v3 0/5] Firmware-assisted suspend/resume of Exynos SoCs
  (https://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35921.html)

Changes since v5:
- rebased on top of next-20140904 +
  "irqchip: Properly fetch the per cpu offset" patch
  (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg716674.html)
  [PATCH v3 0/5] Firmware-assisted suspend/resume of Exynos SoCs
  (https://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35921.html)
- limit Exynos4412 SoC support to Trats2 board for now

Changes since v4:
- rebased on top of next-20140804 +
  [PATCH v5][next-20140804] ARM: EXYNOS: Fix suspend/resume sequences
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35262.html)
  [PATCH v2 0/2] Firmware-assisted suspend/resume of Exynos SoCs
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34282.html)
- call exynos_save_cp15() only on A9 type core (this is needed for the future
  Exynos3250 SoC support)

Changes since v3:
- rebased on top of next-20140804 +
  [PATCH v4][next-20140804] ARM: EXYNOS: Fix suspend/resume sequences
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35192.html)
  [PATCH v2 0/2] Firmware-assisted suspend/resume of Exynos SoCs
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34282.html)
- (re-)added patch fixing S5P_CENTRAL_SEQ_OPTION register setup

Changes since v2:
- rebased on top of next-20140708 +
  [PATCH 5/6] ARM: EXYNOS: Fix suspend/resume sequencies
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32809.html)
  [with rejects fixed]
  [PATCH 6/6] ARM: EXYNOS: Register cpuidle device only on Exynos4210 and 5250
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32808.html)
  [PATCH 0/2] Firmware-assisted suspend/resume of Exynos SoCs
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32991.html)
  [with rejects fixed in patch #2]
- addressed review comments from Tomasz Figa and Daniel Lezcano

Changes since v1:
- synced against next-20140602
- added missing Acked-by-s

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


Bartlomiej Zolnierkiewicz (5):
  ARM: EXYNOS: PM: replace EXYNOS_BOOT_VECTOR_* macros by static inlines
  ARM: EXYNOS: add AFTR mode support to firmware do_idle method
  ARM: EXYNOS: cpuidle: add secure firmware support to AFTR mode code
  ARM: EXYNOS: PM: fix register setup for AFTR mode code
  ARM: EXYNOS: cpuidle: allow driver usage on Exynos4x12 SoCs

 arch/arm/include/asm/firmware.h |  2 +-
 arch/arm/mach-exynos/common.h   |  5 ++++
 arch/arm/mach-exynos/exynos.c   |  5 +++-
 arch/arm/mach-exynos/firmware.c | 34 ++++++++++++++++-------
 arch/arm/mach-exynos/pm.c       | 60 ++++++++++++++++++++++++-----------------
 5 files changed, 71 insertions(+), 35 deletions(-)

-- 
1.8.2.3

