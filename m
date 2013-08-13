Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039Ab3HMRaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:30:03 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45603 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758325Ab3HMR3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:29:55 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v3 0/6] ARM/ARM64 architected timer updates
Date: Tue, 13 Aug 2013 18:29:38 +0100
Message-Id: <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 13 Aug 2013 17:29:50.0532 (UTC) FILETIME=[B6FC6840:01CE984A]
X-MC-Unique: 113081318295300201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7DHViTN000822

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

This patch series adds support to configure the rate and enable the
event stream for architected timer. The event streams can be used to
impose a timeout on a WFE, to safeguard against any programming error
in case an expected event is not generated or even to implement
wfe-based timeouts for userspace locking implementations.

Since the timer control register is reset to zero on warm boot, CPU
PM notifier is added to re-initialize it.

Changes v2->v3:
1. Moved ARM and ARM64 changes into separate patches
2. Added native hwcaps definations(ARM/ARM64) and compat-specific
   definitions(ARM64) to the users for the event stream feature. 

Changes v1->v2:
1. Saved event stream divider value on cold reset path and re-used it
   in CPU PM notifier instead of calculating every time.
2. Rebased on v3.11-rc2(to avoid conflicts with __cpuinit* deletion)
3. Dropped "ARM/ARM64: arch_timer: remove __cpuinit attribute for
   arch_counter_set_user_access"(already done as part of __cpuinit*
   deletion)

Regards,
Sudeep


Sudeep KarkadaNagesha (5):
  ARM/ARM64: arch_timer: add macros for bits in control register
  ARM: arch_timer: configure and enable event stream
  ARM64: arch_timer: configure and enable event stream
  drivers: clocksource: enable hwcaps for event stream on ARM arch timer
  drivers: clocksource: add CPU PM notifier for ARM architected timer

Will Deacon (1):
  drivers: clocksource: configure event stream for ARM arch timer

 arch/arm/include/asm/arch_timer.h    | 18 +++++++++++---
 arch/arm/include/uapi/asm/hwcap.h    |  1 +
 arch/arm/kernel/setup.c              |  1 +
 arch/arm64/include/asm/arch_timer.h  | 22 +++++++++++++----
 arch/arm64/include/asm/hwcap.h       |  4 ++-
 arch/arm64/include/uapi/asm/hwcap.h  |  1 +
 arch/arm64/kernel/setup.c            |  1 +
 drivers/clocksource/arm_arch_timer.c | 48 +++++++++++++++++++++++++++++++++++-
 include/clocksource/arm_arch_timer.h | 10 ++++++++
 9 files changed, 96 insertions(+), 10 deletions(-)

-- 
1.8.1.2


