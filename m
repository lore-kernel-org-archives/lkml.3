Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557Ab3BLRoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:44:15 -0500
Received: from sema.semaphore.gr ([78.46.194.137]:34194 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932262Ab3BLRoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:44:14 -0500
Message-ID: <511A7F62.1020804@semaphore.gr>
Date: Tue, 12 Feb 2013 19:44:02 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH linux-next] x86: smpboot.c: Remove unused variable c
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused variable 'c' in mwait_play_dead and fixes
the following warning:

arch/x86/kernel/smpboot.c: In function ‘mwait_play_dead’:
arch/x86/kernel/smpboot.c:1370:22: warning:
unused variable ‘c’ [-Wunused-variable]

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 arch/x86/kernel/smpboot.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a6ceaed..7bc998a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1367,7 +1367,6 @@ static inline void mwait_play_dead(void)
 	unsigned int highest_subcstate = 0;
 	int i;
 	void *mwait_ptr;
-	struct cpuinfo_x86 *c = __this_cpu_ptr(&cpu_info);
 
 	if (!this_cpu_has(X86_FEATURE_MWAIT))
 		return;
-- 
1.8.1.2

