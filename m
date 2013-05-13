Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab3EMT4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:56:41 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28351 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab3EMT4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:56:39 -0400
X-IronPort-AV: E=Sophos;i="4.87,663,1363158000"; 
   d="scan'208";a="46885528"
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv3 0/4] Memory mapped architected timers
Date: Mon, 13 May 2013 12:56:33 -0700
Message-Id: <1368474997-10859-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc1.25.g423ecb0.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for memory mapped architected timers. We
don't have any other global broadcast timer in our system, so we use the
mmio timer during low power modes. The first patch is the binding.
The next two patches lay some groundwork so that the last patch is simpler.
The final patch adds support for mmio timers.

Patches are based on a patch from Mark that removes the
physical count reading (clocksource: arch_timer: use virtual counter,
message id <1364404312-4427-4-git-send-email-mark.rutland@arm.com>).

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

