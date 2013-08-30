Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab3H3QwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 12:52:19 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49559 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab3H3QwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 12:52:18 -0400
Message-ID: <5220CDD8.6090903@arm.com>
Date: Fri, 30 Aug 2013 17:52:40 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Sudeep.KarkadaNagesha@arm.com
Subject: [GIT PULL] ARM/ARM64 architected timer updates for v3.12, take 2
X-OriginalArrivalTime: 30 Aug 2013 16:52:15.0752 (UTC) FILETIME=[480E0880:01CEA5A1]
X-MC-Unique: 113083017521604401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

These are the ARM/ARM64 arch timer updates for v3.12.
I have re-based the changes on tip/timers/core as there are conflicts
with memory mapped arch_timers support queued recently.
Since this series adds CPU PM notifiers for arch_timers, it is required
to enable ARM bL cpuidle drivers(already queued for v3.12)

Russell said he wants someone from ARM to ack it, Will did the same.
For ARM64, Catalin acked. I have updated the branch accordingly.
If not too late, please do consider it for v3.12

Regards,
Sudeep

The following changes since commit cfb6d656d569510ac9239583ce09e4c92ad54719:

  Merge branch 'timers/clockevents-next' of
git://git.linaro.org/people/dlezcano/clockevents into timers/core
(2013-08-21 14:59:23 +0200)

are available in the git repository at:


  git://linux-arm.org/linux-skn.git timer_evtstrm

for you to fetch changes up to c213e17db6904bb593fd26894091103554eaca09:

  drivers: clocksource: add CPU PM notifier for ARM architected timer
(2013-08-30 17:40:26 +0100)

----------------------------------------------------------------
Sudeep KarkadaNagesha (4):
  ARM/ARM64: arch_timer: add macros for bits in control register
  ARM: arch_timer: add support to configure and enable event stream
  ARM64: arch_timer: add support to configure and enable event stream
  drivers: clocksource: add CPU PM notifier for ARM architected timer

Will Deacon (1):
  drivers: clocksource: add support for ARM architected timer event stream

 arch/arm/include/asm/arch_timer.h    | 36 +++++++++++--
 arch/arm/include/uapi/asm/hwcap.h    |  1 +
 arch/arm/kernel/setup.c              |  1 +
 arch/arm64/include/asm/arch_timer.h  | 42 +++++++++++++---
 arch/arm64/include/asm/hwcap.h       | 11 ++--
 arch/arm64/include/uapi/asm/hwcap.h  |  1 +
 arch/arm64/kernel/setup.c            | 11 ++++
 drivers/clocksource/Kconfig          | 15 ++++++
 drivers/clocksource/arm_arch_timer.c | 49 ++++++++++++++++++
 include/clocksource/arm_arch_timer.h | 10 ++++
 10 files changed, 161 insertions(+), 16 deletions(-)

