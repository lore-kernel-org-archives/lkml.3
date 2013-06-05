Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab3FEXyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 19:54:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60356 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab3FEXys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 19:54:48 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christopher Covington <cov@codeaurora.org>
Subject: [PATCHv3 0/3] 64bit friendly generic sched_clock
Date: Wed,  5 Jun 2013 16:54:42 -0700
Message-Id: <1370476485-468-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc3.8.g5e49f30.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok here's the second take at 64 bit support in generic sched_clock.
This assumes that the previous three patches in the v2 of this 
series have been applied.

I've also noticed that we probably need to update the mult/shift
calculation similar to how clocksources are done. Should we
just copy/paste the maxsec calculation code here or do something
else?

Stephen Boyd (3):
  sched_clock: Add support for >32 bit sched_clock
  ARM: arch_timer: Move to generic sched_clock framework
  arm64: Move to generic sched_clock infrastructure

 arch/arm/kernel/arch_timer.c | 14 ++------------
 arch/arm64/Kconfig           |  1 +
 arch/arm64/kernel/time.c     | 11 ++---------
 include/linux/sched_clock.h  |  3 +--
 kernel/time/sched_clock.c    | 46 ++++++++++++++++++++++++++------------------
 5 files changed, 33 insertions(+), 42 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

