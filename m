Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab3GVLVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 07:21:34 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42518 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab3GVLVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 07:21:32 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com, Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v2 0/3] ARM/ARM64 architected timer updates
Date: Mon, 22 Jul 2013 12:21:19 +0100
Message-Id: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371575223-21702-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1371575223-21702-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 22 Jul 2013 11:21:27.0981 (UTC) FILETIME=[9BC045D0:01CE86CD]
X-MC-Unique: 113072212212906901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6MBLoep009570

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

This patch series adds support to configure the rate and enable the event
stream for architected timer. Since the timer control register is reset to
zero on warm boot, CPU PM notifier is added to re-initialse it.

Changes v1->v2:
1. Saved event stream divider value on cold reset path and re-used it
   in CPU PM notifier instead of calculating every time.
2. Rebased on v3.11-rc2(to avoid conflicts with __cpuinit* deletion)
3. Dropped "ARM/ARM64: arch_timer: remove __cpuinit attribute for
   arch_counter_set_user_access"(already done as part of __cpuinit*
   deletion)

Regards,
Sudeep


Sudeep KarkadaNagesha (2):
  ARM: arch_timer: add macros for bits in control register
  drivers: clocksource: add CPU PM notifier for ARM architected timer

Will Deacon (1):
  drivers: clocksource: configure event stream for ARM arch timer

 arch/arm/include/asm/arch_timer.h    | 10 ++++++--
 arch/arm64/include/asm/arch_timer.h  | 12 +++++++---
 drivers/clocksource/arm_arch_timer.c | 45 +++++++++++++++++++++++++++++++++++-
 include/clocksource/arm_arch_timer.h | 10 ++++++++
 4 files changed, 71 insertions(+), 6 deletions(-)

-- 
1.8.1.2


