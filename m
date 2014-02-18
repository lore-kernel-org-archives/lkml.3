Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbaBRWqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:46:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbaBRWqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nathan Lynch <nathan_lynch@mentor.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.10 07/26] arm64: vdso: update wtm fields for CLOCK_MONOTONIC_COARSE
Date: Tue, 18 Feb 2014 14:47:03 -0800
Message-Id: <20140218224530.619195831@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224530.398913499@linuxfoundation.org>
References: <20140218224530.398913499@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathan_lynch@mentor.com>

commit d4022a335271a48cce49df35d825897914fbffe3 upstream.

Update wall-to-monotonic fields in the VDSO data page
unconditionally.  These are used to service CLOCK_MONOTONIC_COARSE,
which is not guarded by use_syscall.

Signed-off-by: Nathan Lynch <nathan_lynch@mentor.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/vdso.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -235,6 +235,8 @@ void update_vsyscall(struct timekeeper *
 	vdso_data->use_syscall			= use_syscall;
 	vdso_data->xtime_coarse_sec		= xtime_coarse.tv_sec;
 	vdso_data->xtime_coarse_nsec		= xtime_coarse.tv_nsec;
+	vdso_data->wtm_clock_sec		= tk->wall_to_monotonic.tv_sec;
+	vdso_data->wtm_clock_nsec		= tk->wall_to_monotonic.tv_nsec;
 
 	if (!use_syscall) {
 		vdso_data->cs_cycle_last	= tk->clock->cycle_last;
@@ -242,8 +244,6 @@ void update_vsyscall(struct timekeeper *
 		vdso_data->xtime_clock_nsec	= tk->xtime_nsec;
 		vdso_data->cs_mult		= tk->mult;
 		vdso_data->cs_shift		= tk->shift;
-		vdso_data->wtm_clock_sec	= tk->wall_to_monotonic.tv_sec;
-		vdso_data->wtm_clock_nsec	= tk->wall_to_monotonic.tv_nsec;
 	}
 
 	smp_wmb();


