Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaBSXPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 18:15:03 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:39877 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaBSXPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 18:15:00 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: [PATCH v4 0/4] ARM: zynq: cpufreq support
Date: Wed, 19 Feb 2014 15:14:40 -0800
Message-Id: <1392851684-29950-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

another iteration of this series. The patches are the same as in v3, but
the series shrank a bit. I rebased this series on tip/timers/core, hence
the two patches for the clockevent core fell out, since Thomas already
applied those.
Additionally I removed the patch 'clocksource/cadence_ttc: Use only one
counter'. Thomas brought up some questions regarding that patch which
need to be investigated. Since it is not required for the rest of this
series, I just dropped it for now.

	Thanks,
	Sören

Soren Brinkmann (4):
  clocksource/cadence_ttc: Call clockevents_update_freq() with IRQs
    enabled
  clocksource/cadence_ttc: Overhaul clocksource frequency adjustment
  arm: zynq: Don't use arm_global_timer with cpufreq
  arm: zynq: Add support for cpufreq

 arch/arm/boot/dts/zynq-7000.dtsi        |   6 ++
 arch/arm/mach-zynq/Kconfig              |   4 +-
 arch/arm/mach-zynq/common.c             |   3 +
 drivers/clocksource/cadence_ttc_timer.c | 121 +++++++++++++++++++++++---------
 4 files changed, 98 insertions(+), 36 deletions(-)

-- 
1.9.0.1.g4196000

