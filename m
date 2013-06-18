Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581Ab3FRRHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:07:10 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45983 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933150Ab3FRRHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:07:05 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com, linux@arm.linux.org.uk,
        catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com,
        marc.zyngier@arm.com, tglx@linutronix.de,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH 3/4] ARM/ARM64: arch_timer: remove __cpuinit attribute for arch_counter_set_user_access
Date: Tue, 18 Jun 2013 18:07:02 +0100
Message-Id: <1371575223-21702-4-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371575223-21702-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1371575223-21702-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 18 Jun 2013 17:07:02.0310 (UTC) FILETIME=[40544C60:01CE6C46]
X-MC-Unique: 113061818070305001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r5IH7egL002371

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

We must not declare arch_counter_set_user_access as __cpuinit as we
need to use it in warm reset paths like CPU PM notifiers.

Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/include/asm/arch_timer.h   | 2 +-
 arch/arm64/include/asm/arch_timer.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index 6725017..26c65ae 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -89,7 +89,7 @@ static inline u64 arch_counter_get_cntvct(void)
 	return cval;
 }
 
-static inline void __cpuinit arch_counter_set_user_access(int divider)
+static inline void arch_counter_set_user_access(int divider)
 {
 	u32 cntkctl;
 
diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 2269944..3494102 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -97,7 +97,7 @@ static inline u32 arch_timer_get_cntfrq(void)
 	return val;
 }
 
-static inline void __cpuinit arch_counter_set_user_access(int divider)
+static inline void arch_counter_set_user_access(int divider)
 {
 	u32 cntkctl;
 
-- 
1.8.1.2


