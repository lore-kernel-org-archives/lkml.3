Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaETPgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:36:36 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13384 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaETPge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:36:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 20 May 2014 08:31:40 -0700
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
Date: Tue, 20 May 2014 18:36:08 +0300
Message-ID: <1400600176-435-1-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver (3):
  kernel: add calibration_delay_done()
  ARM: choose highest resolution delay timer
  clocksource: tegra: Use uS counter as delay timer

 arch/arm/lib/delay.c                |   26 ++++++++++++++++++++++----
 drivers/clocksource/tegra20_timer.c |   13 +++++++++++++
 init/calibrate.c                    |   12 ++++++++++++
 3 files changed, 47 insertions(+), 4 deletions(-)

-- 
1.7.7.rc0.72.g4b5ea.dirty

