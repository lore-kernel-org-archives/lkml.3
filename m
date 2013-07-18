Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524Ab3GRX7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:59:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:32886 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759170Ab3GRX7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:59:35 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robherring2@gmail.com>
Subject: [PATCH v4 0/5] Memory mapped architected timers
Date: Thu, 18 Jul 2013 16:59:27 -0700
Message-Id: <1374191972-18015-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for memory mapped architected timers. We
don't have any other global broadcast timer in our system, so we use the
mmio timer during low power modes. The first patch changes the register
accessor to an enum per Thomas' request. The second patch is the binding.
The next two patches lay some groundwork so that the last patch is simpler.
The final patch adds support for mmio timers.

Patches are based on v3.11-rc1.

Updates since v3:
 * Rebased onto v3.11-rc1
 * New patch to use compiler warnings instead of BUILD_BUG_ON()

Updates since v2:
 * Rebased onto v3.10-rc1

Updates since v1:
 * Assigned counter reading function and commented why for arm64
 * Updated DT binding to replace frame-id with frame-number and use status
   property


Stephen Boyd (5):
  clocksource: arch_timer: Make register accessors less error-prone
  Documentation: Add memory mapped ARM architected timer binding
  clocksource: arch_timer: Pass clock event to set_mode callback
  clocksource: arch_timer: Push the read/write wrappers deeper
  clocksource: arch_timer: Add support for memory mapped timers

 .../devicetree/bindings/arm/arch_timer.txt         |  59 ++-
 arch/arm/include/asm/arch_timer.h                  |  14 +-
 arch/arm64/include/asm/arch_timer.h                |  23 +-
 drivers/clocksource/arm_arch_timer.c               | 446 +++++++++++++++++----
 include/clocksource/arm_arch_timer.h               |  10 +-
 5 files changed, 455 insertions(+), 97 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

