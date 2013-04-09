Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936681Ab3DICa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 22:30:28 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52399 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934428Ab3DICa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 22:30:26 -0400
X-IronPort-AV: E=Sophos;i="4.87,434,1363158000"; 
   d="scan'208";a="36904316"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 0/4] Memory mapped architected timers
Date: Mon,  8 Apr 2013 19:30:19 -0700
Message-Id: <1365474623-29181-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for memory mapped architected timers. We
don't have any other global broadcast timer in our system, so we use the
mmio timer during low power modes. The first patch is the binding.
The next two patches lay some groundwork so that the last patch is simpler.
The final patch adds support for mmio timers.

Patches are based on a recent patch from Mark that removes the
physical count reading (clocksource: arch_timer: use virtual counter,
message id <1364404312-4427-4-git-send-email-mark.rutland@arm.com>).

Stephen Boyd (4):
  Documentation: Add memory mapped ARM architected timer binding
  ARM: arch_timers: Pass clock event to set_mode callback
  clocksource: arch_timer: Push the read/write wrappers deeper
  clocksource: arch_timer: Add support for memory mapped timers

 .../devicetree/bindings/arm/arch_timer.txt         |  62 ++-
 arch/arm/include/asm/arch_timer.h                  |   5 +-
 arch/arm64/include/asm/arch_timer.h                |   4 +-
 drivers/clocksource/arm_arch_timer.c               | 451 +++++++++++++++++----
 include/clocksource/arm_arch_timer.h               |   4 +-
 5 files changed, 448 insertions(+), 78 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

