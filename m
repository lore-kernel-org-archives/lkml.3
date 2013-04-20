Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965283Ab3DTA3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 20:29:11 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47892 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965140Ab3DTA3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 20:29:09 -0400
X-IronPort-AV: E=Sophos;i="4.87,512,1363158000"; 
   d="scan'208";a="40095500"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/4] ARM 64 bit sched_clock take #2
Date: Fri, 19 Apr 2013 17:29:02 -0700
Message-Id: <1366417746-24990-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1.392.g85e7e81
In-Reply-To: <51709FD7.8050408@gmail.com>
References: <51709FD7.8050408@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is what I was thinking. I don't see why we can't move this to generic code and have arm64 use it too. Those patches will follow once I find an arm64
compiler.

First two patches should probably go in even if the 64 bit stuff doesn't go in
at the same time.

Stephen Boyd (4):
  ARM: sched_clock: Remove unused needs_suspend member
  ARM: sched_clock: Return suspended count earlier
  ARM: sched_clock: Add support for >32 bit sched_clock
  ARM: arch_timer: Move to setup_sched_clock_64()

 arch/arm/include/asm/sched_clock.h |   5 +-
 arch/arm/kernel/arch_timer.c       |  14 +----
 arch/arm/kernel/sched_clock.c      | 111 ++++++++++++++++++++++++++-----------
 3 files changed, 84 insertions(+), 46 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

