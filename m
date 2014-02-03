Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbaBCWet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:34:49 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:59343 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaBCWer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:34:47 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: [PATCH v3 0/7] ARM: zynq: cpufreq support
Date: Mon,  3 Feb 2014 14:34:30 -0800
Message-Id: <1391466877-28908-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the merge window is over and ARM is also booting again. So, time to
restart the discussion on this series.
I rebased the series on 3.14-rc1 which removed some of the patches of
the original submission due to them already having been merged.
Other than that, I didn't do many changes compared to the patches that
have been sent out in early December. Changelogs are included with the
patches.

	Thanks,
	Sören

Soren Brinkmann (7):
  time: Serialize calls to 'clockevents_update_freq' in the timing core
  time: clockevents: Adjust timer interval when frequency changes
  clocksource/cadence_ttc: Call clockevents_update_freq() with IRQs
    enabled
  clocksource/cadence_ttc: Overhaul clocksource frequency adjustment
  clocksource/cadence_ttc: Use only one counter
  arm: zynq: Don't use arm_global_timer with cpufreq
  arm: zynq: Add support for cpufreq

 arch/arm/boot/dts/zynq-7000.dtsi        |   6 +
 arch/arm/mach-zynq/Kconfig              |   4 +-
 arch/arm/mach-zynq/common.c             |   3 +
 drivers/clocksource/cadence_ttc_timer.c | 213 ++++++++++++++++++--------------
 kernel/time/clockevents.c               |  32 +++--
 kernel/time/tick-broadcast.c            |  25 +++-
 kernel/time/tick-internal.h             |   4 +
 7 files changed, 177 insertions(+), 110 deletions(-)

-- 
1.8.5.3

