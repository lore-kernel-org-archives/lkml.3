Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbaFLP6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:58:46 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:1138 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbaFLP6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:58:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Jun 2014 08:49:47 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH 0/3] Use Tegra's microsecond counter for udelay()
Date: Thu, 12 Jun 2014 18:58:26 +0300
Message-ID: <1402588713-18766-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces support for Tegra's microsecond counter as the
udelay() timer. This is useful on Tegra SoCs which do not have an arch timer
such as Tegra20 and Tegra30. Using the microsecond counter instead of a delay
based loop avoids potential problems during cpu frequency changes.

The set consists of 3 patches:

Patch 1 introduces a new call which is used by the ARM architecture delay
timer code to prevent changing the delay timer after calibration is finished
and thus can be in use.

Patch 2 adds logic to choose the delay timer with the highest resolution. This
allows the same registration code to be used on all Tegra SoCs and yet use the
higher resolution arch timer when available (eg on Tegra114 or Tegra124).

Patch 3 adds the actual delay timer code.

Patch set has been verified on ventana (Tegra20), beaver (Tegra30),
dalmore (Tegra114) and jetson TK1 (Tegra124).

Changes since v1:
* Address review comments

What needs to be done to make progress on this one? I think it's really useful
to have this when CPU DVFS is available.

Peter De Schrijver (3):
  kernel: add calibration_delay_done()
  ARM: choose highest resolution delay timer
  clocksource: tegra: Use us counter as delay timer

 arch/arm/lib/delay.c                |   26 ++++++++++++++++++++++----
 drivers/clocksource/tegra20_timer.c |   13 +++++++++++++
 init/calibrate.c                    |   11 +++++++++++
 3 files changed, 46 insertions(+), 4 deletions(-)

-- 
1.7.7.rc0.72.g4b5ea.dirty

