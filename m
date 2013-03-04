Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab3CDW2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:28:45 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:57468 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367Ab3CDW2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:28:44 -0500
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] arch: x86: kernel: smpboot: fixed unused variable warning
Date: Tue,  5 Mar 2013 00:28:00 +0200
Message-Id: <1362436081-28782-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unused variable 'c' and fixed the following warning:
arch/x86/kernel/smpboot.c: In function ‘mwait_play_dead’:
arch/x86/kernel/smpboot.c:1370:22: warning: unused variable ‘c’ [-Wunused-variable]

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
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
1.7.9.5

