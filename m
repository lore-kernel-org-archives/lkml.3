Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbaBQAxi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 19:53:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51728 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbaBQAxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 19:53:36 -0500
Date: Sun, 16 Feb 2014 16:53:14 -0800
From: tip-bot for Stefani Seibold <tipbot@zytor.com>
Message-ID: <tip-d3e68e3e3fed760169cef2fa95e73551f5d24022@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stefani@seibold.net, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stefani@seibold.net, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1392587568-7325-6-git-send-email-stefani@seibold.net>
References: <1392587568-7325-6-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso: Replace VVAR(vsyscall_gtod_data)
  by the gtod macro
Git-Commit-ID: d3e68e3e3fed760169cef2fa95e73551f5d24022
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 16 Feb 2014 16:53:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3e68e3e3fed760169cef2fa95e73551f5d24022
Gitweb:     http://git.kernel.org/tip/d3e68e3e3fed760169cef2fa95e73551f5d24022
Author:     Stefani Seibold <stefani@seibold.net>
AuthorDate: Sun, 16 Feb 2014 22:52:43 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 16 Feb 2014 15:07:01 -0800

x86, vdso: Replace VVAR(vsyscall_gtod_data) by the gtod macro

There a currently more than 30 users of the gtod macro, so replace the
last VVAR(vsyscall_gtod_data) by gtod macro.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/1392587568-7325-6-git-send-email-stefani@seibold.net
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
