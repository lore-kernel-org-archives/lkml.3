Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab3HWQUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 12:20:25 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55937 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab3HWQUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 12:20:23 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v4 0/5] ARM/ARM64 architected timer updates
Date: Fri, 23 Aug 2013 17:19:04 +0100
Message-Id: <1377274749-6196-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
X-OriginalArrivalTime: 23 Aug 2013 16:20:21.0079 (UTC) FILETIME=[A9EDDE70:01CEA01C]
X-MC-Unique: 113082317202103801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7NGLUbg007997

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

This patch series adds support to configure the rate and enable the
event stream for architected timer. The event streams can be used to
impose a timeout on a wfe, to safeguard against any programming error
in case an expected event is not generated or even to implement
wfe-based timeouts for userspace locking implementations. This feature
can be disabled(enabled by default).

Since the timer control register is reset to zero on warm boot, CPU
PM notifier is added to re-initialize it.

Changes v3->v4:
1. Added a config option to en/disable the timer event stream feature.
   Due to this the ordering of the patches as well as some cosmetic
   code changes are done.( So dropped previous reviewed-by tags)
2. Removed exporting compat_dyn_elf_hwcap as there are no modules
   requiring it for now.

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
  ARM: arch_timer: add support to configure and enable event stream
  ARM64: arch_timer: add support to configure and enable event stream
  drivers: clocksource: add support for ARM architected timer event
    stream
  drivers: clocksource: add CPU PM notifier for ARM architected timer

 arch/arm/include/asm/arch_timer.h    | 41 ++++++++++++++++++++---
 arch/arm/include/uapi/asm/hwcap.h    |  1 +
 arch/arm/kernel/setup.c              |  1 +
 arch/arm64/include/asm/arch_timer.h  | 48 +++++++++++++++++++++++----
 arch/arm64/include/asm/hwcap.h       |  7 +++-
 arch/arm64/include/uapi/asm/hwcap.h  |  1 +
 arch/arm64/kernel/setup.c            |  5 +++
 drivers/clocksource/Kconfig          | 14 ++++++++
 drivers/clocksource/arm_arch_timer.c | 64 ++++++++++++++++++++++++++++++++++++
 include/clocksource/arm_arch_timer.h | 10 ++++++
 10 files changed, 180 insertions(+), 12 deletions(-)

-- 
1.8.1.2


