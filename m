Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab3LSUeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:34:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35954 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab3LSUd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:33:59 -0500
Date: Thu, 19 Dec 2013 12:33:23 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-7d590cca7cd2cce4ed7c47d221d6f90566653ba8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, hpa@linux.intel.com, len.brown@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, hpa@linux.intel.com, len.brown@intel.com
In-Reply-To: <CA+55aFzGxcML7j8CEvQPYzh0W81uVoAAVmGctMOUZ7CZ1yYd2A@mail.gmail.com>
References: <CA+55aFzGxcML7j8CEvQPYzh0W81uVoAAVmGctMOUZ7CZ1yYd2A@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/idle] x86, idle:
  Add memory barriers around clflush in mwait_play_dead()
Git-Commit-ID: 7d590cca7cd2cce4ed7c47d221d6f90566653ba8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 19 Dec 2013 12:33:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d590cca7cd2cce4ed7c47d221d6f90566653ba8
Gitweb:     http://git.kernel.org/tip/7d590cca7cd2cce4ed7c47d221d6f90566653ba8
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 19 Dec 2013 12:30:03 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 19 Dec 2013 12:30:03 -0800

x86, idle: Add memory barriers around clflush in mwait_play_dead()

For consistency with mwait_idle_with_hints().  Not sure they help, but
they really won't hurt...

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Len Brown <len.brown@intel.com>
Link: http://lkml.kernel.org/r/CA%2B55aFzGxcML7j8CEvQPYzh0W81uVoAAVmGctMOUZ7CZ1yYd2A@mail.gmail.com
---
 arch/x86/kernel/smpboot.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 85dc05a..f5252c4 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1417,7 +1417,9 @@ static inline void mwait_play_dead(void)
 		 * The WBINVD is insufficient due to the spurious-wakeup
 		 * case where we return around the loop.
 		 */
+		mb();
 		clflush(mwait_ptr);
+		mb();
 		__monitor(mwait_ptr, 0, 0);
 		mb();
 		__mwait(eax, 0);
