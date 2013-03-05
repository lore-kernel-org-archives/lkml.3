Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940Ab3CESiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:38:16 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62301 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab3CESiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:38:14 -0500
From: "Raphael S.Carvalho" <raphael.scarv@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Cc: linux-kernel@vger.kernel.org,
        "Raphael S.Carvalho" <raphael.scarv@gmail.com>
Subject: [PATCH 1/1] arch/x86/smpboot.c: Fix GCC Warning (unused variable)!
Date: Tue,  5 Mar 2013 15:37:05 -0300
Message-Id: <1362508625-7803-1-git-send-email-raphael.scarv@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCC complained about the unused variable c, thus I'm sending
this patch in order to calm it down.
I compiled the file and everything seems be ok!

Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>
---
 arch/x86/kernel/smpboot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a6ceaed..77a5616 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1367,7 +1367,7 @@ static inline void mwait_play_dead(void)
 	unsigned int highest_subcstate = 0;
 	int i;
 	void *mwait_ptr;
-	struct cpuinfo_x86 *c = __this_cpu_ptr(&cpu_info);
+	__this_cpu_ptr(&cpu_info);
 
 	if (!this_cpu_has(X86_FEATURE_MWAIT))
 		return;
-- 
1.7.2.5

