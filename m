Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaCBJWK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 04:22:10 -0500
Received: from www84.your-server.de ([213.133.104.84]:48026 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaCBJUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 04:20:52 -0500
From: Stefani Seibold <stefani@seibold.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH v21 05/12] replace VVAR(vsyscall_gtod_data) by gtod macro
Date: Sun,  2 Mar 2014 10:20:13 +0100
Message-Id: <1393752020-6740-6-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393752020-6740-1-git-send-email-stefani@seibold.net>
References: <1393752020-6740-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There a currently more than 30 users of the gtod macro, so replace the
last VVAR(vsyscall_gtod_data) by gtod macro.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/vdso/vclock_gettime.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index fd074dd..743f277 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -109,7 +109,7 @@ static notrace cycle_t vread_pvclock(int *mode)
 		*mode = VCLOCK_NONE;
 
 	/* refer to tsc.c read_tsc() comment for rationale */
-	last = VVAR(vsyscall_gtod_data).clock.cycle_last;
+	last = gtod->clock.cycle_last;
 
 	if (likely(ret >= last))
 		return ret;
@@ -133,7 +133,7 @@ notrace static cycle_t vread_tsc(void)
 	rdtsc_barrier();
 	ret = (cycle_t)vget_cycles();
 
-	last = VVAR(vsyscall_gtod_data).clock.cycle_last;
+	last = gtod->clock.cycle_last;
 
 	if (likely(ret >= last))
 		return ret;
@@ -288,7 +288,7 @@ int gettimeofday(struct timeval *, struct timezone *)
 notrace time_t __vdso_time(time_t *t)
 {
 	/* This is atomic on x86_64 so we don't need any locks. */
-	time_t result = ACCESS_ONCE(VVAR(vsyscall_gtod_data).wall_time_sec);
+	time_t result = ACCESS_ONCE(gtod->wall_time_sec);
 
 	if (t)
 		*t = result;
-- 
1.9.0

