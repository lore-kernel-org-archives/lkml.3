Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab3IRStI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 14:49:08 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:47906 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab3IRStG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 14:49:06 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Preeti Murthy <preeti.lkml@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 0/4] arm: zynq: Enable global timer
Date: Wed, 18 Sep 2013 11:48:34 -0700
Message-Id: <1379530118-22813-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

here's a v2. I reused the subject from my v1 submission although the focus of
this series moved a bit towards the timer subsystem.
I replaced Stephen's fix to prevent per cpu devices from becoming
the broadcast device with Thomas' proposal, but I kept the original commit
message. I split the whole approach in small chunks that I found reasonable.

In 4/4, I picked up Grant's comment regarding the DT node name.

v2:
 - drop 1/2 of the original series
 - implement preventing per cpu devices from becoming broadcast device according
   to Thomas' proposal
   - introduce new CLOCK_EVT_FEAT_PERCPU flag
   - set the flag for the arm_global_timer
   - filter per cpu devices based on this flag when choosing the broadcast
     device
 - rename DT node to avoid '_'s
 

Soren Brinkmann (4):
  clockchips: Add FEAT_PERCPU clockevent flag
  clocksource/arm_global_timer: Set FEAT_PERCPU flag
  tick: broadcast: Deny per-cpu clockevents from being broadcast sources
  arm: zynq: Enable arm_global_timer

 arch/arm/boot/dts/zynq-7000.dtsi       | 8 ++++++++
 arch/arm/mach-zynq/Kconfig             | 1 +
 drivers/clocksource/arm_global_timer.c | 3 ++-
 include/linux/clockchips.h             | 1 +
 kernel/time/tick-broadcast.c           | 1 +
 5 files changed, 13 insertions(+), 1 deletion(-)

-- 
1.8.4

