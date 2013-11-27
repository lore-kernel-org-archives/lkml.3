Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090Ab3K0BFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:05:18 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:35844 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758562Ab3K0BFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:05:11 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 0/9] arm: zynq: Add support for cpufreq
Date: Tue, 26 Nov 2013 17:04:47 -0800
Message-Id: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I revised this series and rebased on top of Linus' tree. Patch specific
changes are tracked in the respective email with their patch. On the
level of the whole series, this changed:

v2:
 - added 'clocksource/cadence_ttc: Use enable/disable_irq'. I hope that
   is more appropriate to avoid races of the timer with its interrupt
   handler.
 - added 'arm: zynq: Don't use arm_global_timer with cpufreq'. In the
   3.13 merge window we enabled the arm_global_timer for Zynq. That
   timer is clocked by the CPU clock and hence does not provide a stable
   clocksource when cpufreq is enabled. That patch makes the selection of
   the GT driver depend on !CPU_FREQ for Zynq.

	Sören

Soren Brinkmann (9):
  arm: dt: zynq: Remove 'clock-ranges' from TTC nodes
  arm: dt: zynq: Add 'cpus' node
  clocksource/cadence_ttc: Store timer frequency in driver data
  clocksource/cadence_ttc: Use enable/disable_irq
  clocksource/cadence_ttc: Adjust interval in clock notifier
  clocksource/cadence_ttc: Overhaul clocksource frequency adjustment
  clocksource/cadence_ttc: Use only one counter
  arm: zynq: Don't use arm_global_timer with cpufreq
  arm: zynq: Add support for cpufreq

 arch/arm/boot/dts/zynq-7000.dtsi        |  27 +++-
 arch/arm/mach-zynq/Kconfig              |   4 +-
 arch/arm/mach-zynq/common.c             |   3 +
 drivers/clocksource/cadence_ttc_timer.c | 235 +++++++++++++++++++-------------
 4 files changed, 174 insertions(+), 95 deletions(-)

-- 
1.8.4.4

