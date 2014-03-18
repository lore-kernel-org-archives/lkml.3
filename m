Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647AbaCRV3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:29:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54471 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933625AbaCRV3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:29:12 -0400
Date: Tue, 18 Mar 2014 14:28:37 -0700
From: tip-bot for Stefani Seibold <tipbot@zytor.com>
Message-ID: <tip-af8c93d8d9809c3cf71cae2c398069399e64efa3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1395094933-14252-6-git-send-email-stefani@seibold.net>
References: <1395094933-14252-6-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso: Replace VVAR(vsyscall_gtod_data)
  by gtod macro
Git-Commit-ID: af8c93d8d9809c3cf71cae2c398069399e64efa3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af8c93d8d9809c3cf71cae2c398069399e64efa3
Gitweb:     http://git.kernel.org/tip/af8c93d8d9809c3cf71cae2c398069399e64efa3
Author:     Stefani Seibold <stefani@seibold.net>
AuthorDate: Mon, 17 Mar 2014 23:22:05 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 18 Mar 2014 12:52:03 -0700

x86, vdso: Replace VVAR(vsyscall_gtod_data) by gtod macro

There a currently more than 30 users of the gtod macro, so replace the
last VVAR(vsyscall_gtod_data) by gtod macro.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/1395094933-14252-6-git-send-email-stefani@seibold.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
