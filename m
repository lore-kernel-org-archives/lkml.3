Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab3CDUQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:16:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55843 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381Ab3CDUQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:16:36 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 1/5] x86, smpboot: Remove unused variable
Date: Mon,  4 Mar 2013 21:16:16 +0100
Message-Id: <1362428180-8865-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1362428180-8865-1-git-send-email-bp@alien8.de>
References: <1362428180-8865-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

The cpuinfo_x86 ptr is unused now. Drop it. Got obsolete by 69fb3676df33
("x86 idle: remove mwait_idle() and "idle=mwait" cmdline param")
removing its only user.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/smpboot.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a6ceaedc396a..9f190a2a00e9 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1365,9 +1365,8 @@ static inline void mwait_play_dead(void)
 	unsigned int eax, ebx, ecx, edx;
 	unsigned int highest_cstate = 0;
 	unsigned int highest_subcstate = 0;
-	int i;
 	void *mwait_ptr;
-	struct cpuinfo_x86 *c = __this_cpu_ptr(&cpu_info);
+	int i;
 
 	if (!this_cpu_has(X86_FEATURE_MWAIT))
 		return;
-- 
1.8.1.3.535.ga923c31

