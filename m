Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab3CDW7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:59:09 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:33974 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758783Ab3CDW7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:59:08 -0500
Message-ID: <1362437940.4591.24.camel@lorien2>
Subject: [PATCH] arch/x86: fix unused variable warning in mwait_play_dead()
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        a.p.zijlstra@chello.nl, jarkko.sakkinen@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, shuahkhan@gmail.com
Date: Mon, 04 Mar 2013 15:59:00 -0700
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix arch/x86/kernel/smpboot.c: In function ‘mwait_play_dead’:
arch/x86/kernel/smpboot.c:1370:22: warning: unused variable ‘c’ [-Wunused-variable]

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 arch/x86/kernel/smpboot.c |    1 -
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
1.7.10.4



