Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbaEHOhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:37:50 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60976 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaEHOhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:37:48 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org
Cc: lenb@kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com,
        rjw@rjwysocki.net
Subject: [RFC PATCH 0/5] ACPI: thermal: Migrate cpufreq cooling to generic cpu_cooling layer
Date: Thu,  8 May 2014 20:07:55 +0530
Message-Id: <1399559880-20562-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds notification support for those clients of cpu_cooling
APIs which may want to do something extra after receiving these
cpu_cooling events shown below. The notifier structure passed is of both Set/Get type.
The notfications events can be of the following type,

1. CPU_COOLING_SET_STATE_PRE
2. CPU_COOLING_SET_STATE_POST
3. CPU_COOLING_GET_CUR_STATE
4. CPU_COOLING_GET_MAX_STATE

The advantages of these notfications is to differentiate between different
P states in the cpufreq table and the cooling states. The clients of these
events may group few P states into 1 cooling states as done by ACPI .
Also some more cooling states can be enabled when the maximum of P state is
reached. In case of ACPI processor throttling are enabled when minimum
P-state is reached. Post notification events can be used for those cases.

Amit Daniel Kachhap (5):
  thermal: cpu_cooling: Support passing driver private data.
  thermal: cpu_cooling: Add notifications support for the clients
  thermal: cpu_cooling: Add support to find nearby frequency levels.
  thermal: cpu_cooling: Release the upper cooling limit checks
  ACPI: thermal: processor: Use the generic cpufreq infrastructure

 drivers/acpi/processor_driver.c                    |    6 +-
 drivers/acpi/processor_thermal.c                   |  210 +++++++++----------
 drivers/thermal/cpu_cooling.c                      |  220 +++++++++++++++++---
 drivers/thermal/db8500_cpufreq_cooling.c           |    2 +-
 drivers/thermal/samsung/exynos_thermal_common.c    |    5 +-
 drivers/thermal/step_wise.c                        |    2 +-
 drivers/thermal/thermal_core.c                     |    9 +-
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |    2 +-
 include/linux/cpu_cooling.h                        |   83 +++++++-
 include/linux/thermal.h                            |    1 +
 10 files changed, 378 insertions(+), 162 deletions(-)

