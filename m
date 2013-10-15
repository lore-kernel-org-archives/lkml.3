Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346Ab3JOOWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:22:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47599 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759191Ab3JOOWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:22:43 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.daniel@samsung.com>, <l.majewski@samsung.com>
Subject: [GIT PULL v2] thermal-soc: urgent fixes for 3.12
Date: Tue, 15 Oct 2013 10:22:32 -0400
Message-ID: <1381846952-17654-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rui,

Here is the urgent fixes on thermal-soc drivers, only difference from v1 is
that now it is based on the right branch (your master branch) so that it
does not include any changes for 3.13.

Short changelog:
- Several fixes on exynos driver: exynos 4412 regressions
- Minor fix on ti-soc-thermal: extrapolation with pcb sensor fixed

V1:
http://www.spinics.net/lists/kernel/msg1619642.html

All best,

The following changes since commit 22356f447ceb8d97a4885792e7d9e4607f712e1b:

  mm: Place preemption point in do_mlockall() loop (2013-09-24 19:44:40 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git fixes

for you to fetch changes up to df8f13476443b70608c64b3e91f3876a06fa739c:

  drivers: thermal: allow ti-soc-thermal run without pcb zone (2013-10-15 10:10:43 -0400)

----------------------------------------------------------------
Eduardo Valentin (1):
      drivers: thermal: allow ti-soc-thermal run without pcb zone

Lukasz Majewski (3):
      thermal: exynos: Remove check for thermal device pointer at exynos_report_trigger()
      thermal: exynos: Provide separate TMU data for Exynos4412
      thermal: exynos: Provide initial setting for TMU's test MUX address at Exynos4412

 drivers/thermal/samsung/exynos_thermal_common.c    |  2 --
 drivers/thermal/samsung/exynos_tmu.c               | 12 ++++++---
 drivers/thermal/samsung/exynos_tmu.h               |  7 ++++-
 drivers/thermal/samsung/exynos_tmu_data.c          | 30 +++++++++++++++++-----
 drivers/thermal/samsung/exynos_tmu_data.h          | 13 +++++++++-
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  1 +
 6 files changed, 51 insertions(+), 14 deletions(-)
