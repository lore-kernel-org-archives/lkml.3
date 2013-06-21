Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423541Ab3FURj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 13:39:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52047 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423388Ab3FURjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 13:39:25 -0400
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
Subject: [PATCHv3/RESEND 0/4] Memory mapped architected timers
Date: Fri, 21 Jun 2013 10:39:17 -0700
Message-Id: <1371836361-20574-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.448.gfb7dfaa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending this patchset to Daniel since it looks like Daniel is
picking up these types of patches.)

This patchset adds support for memory mapped architected timers. We
don't have any other global broadcast timer in our system, so we use the
mmio timer during low power modes. The first patch is the binding.
The next two patches lay some groundwork so that the last patch is simpler.
The final patch adds support for mmio timers.

Patches are based on a patch from Mark that removes the
physical count reading (clocksource: arch_timer: use virtual counter,
message id <1364404312-4427-4-git-send-email-mark.rutland@arm.com>).
This patch is now in RMK's devel-stable branch:

 ftp://ftp.arm.linux.org.uk/pub/linux/arm/kernel/git-cur/linux-2.6-arm.git/ devel-stable

Updates since v2:
 * Rebased onto v3.10-rc1

Updates since v1:
 * Assigned counter reading function and commented why for arm64
 * Updated DT binding to replace frame-id with frame-number and use status
   property

Stephen Boyd (4):
  Documentation: Add memory mapped ARM architected timer binding
  clocksource: arch_timer: Pass clock event to set_mode callback
  clocksource: arch_timer: Push the read/write wrappers deeper
  clocksource: arch_timer: Add support for memory mapped timers

 .../devicetree/bindings/arm/arch_timer.txt         |  59 ++-
 arch/arm/include/asm/arch_timer.h                  |   5 +-
 arch/arm64/include/asm/arch_timer.h                |   4 +-
 drivers/clocksource/arm_arch_timer.c               | 452 +++++++++++++++++----
 include/clocksource/arm_arch_timer.h               |   4 +-
 5 files changed, 448 insertions(+), 76 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

