Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbaCCTSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:18:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55937 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbaCCS4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:56:17 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nathan Lynch <nathan_lynch@mentor.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 14/67] arm64: vdso: update wtm fields for CLOCK_MONOTONIC_COARSE
Date: Mon,  3 Mar 2014 10:55:02 -0800
Message-Id: <1393872955-28810-15-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathan_lynch@mentor.com>

commit d4022a335271a48cce49df35d825897914fbffe3 upstream.

Update wall-to-monotonic fields in the VDSO data page
unconditionally.  These are used to service CLOCK_MONOTONIC_COARSE,
which is not guarded by use_syscall.

Signed-off-by: Nathan Lynch <nathan_lynch@mentor.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/kernel/vdso.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index 6a389dc..0ea7a22 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -235,6 +235,8 @@ void update_vsyscall(struct timekeeper *tk)
 	vdso_data->use_syscall			= use_syscall;
 	vdso_data->xtime_coarse_sec		= xtime_coarse.tv_sec;
 	vdso_data->xtime_coarse_nsec		= xtime_coarse.tv_nsec;
+	vdso_data->wtm_clock_sec		= tk->wall_to_monotonic.tv_sec;
+	vdso_data->wtm_clock_nsec		= tk->wall_to_monotonic.tv_nsec;
 
 	if (!use_syscall) {
 		vdso_data->cs_cycle_last	= tk->clock->cycle_last;
@@ -242,8 +244,6 @@ void update_vsyscall(struct timekeeper *tk)
 		vdso_data->xtime_clock_nsec	= tk->xtime_nsec;
 		vdso_data->cs_mult		= tk->mult;
 		vdso_data->cs_shift		= tk->shift;
-		vdso_data->wtm_clock_sec	= tk->wall_to_monotonic.tv_sec;
-		vdso_data->wtm_clock_nsec	= tk->wall_to_monotonic.tv_nsec;
 	}
 
 	smp_wmb();
-- 
1.8.3.2

