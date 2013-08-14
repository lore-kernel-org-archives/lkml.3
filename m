Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab3HNCUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 22:20:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:51921 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759136Ab3HNCUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 22:20:32 -0400
From: Li Wang <li.wang@windriver.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
CC: <li.wang@windriver.com>
Subject: [PATCH] x86: remove redundant local_irq_enable() after cpuidle_idle_call()
Date: Wed, 14 Aug 2013 10:20:00 +0800
Message-ID: <1376446800-3778-1-git-send-email-li.wang@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cpuidle_idle_call() return 0, it shows that linux system is using
idle framwork driver. Now, local irq has already been enabled in
cpuidle_idle_call(). So, it need not enable local irq again, when return 0.

The code is introduced by commit:
97a5b81fa4d3a11dcdf224befc577f2e0abadc0b ("x86: Fix idle consolidation fallout")
In that defect, it does not use idle framework driver, just call amd_e400_idle().
That problem is that amd_e400_idle() does not enable irq.

Signed-off-by: Li Wang <li.wang@windriver.com>
---
 arch/x86/kernel/process.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 83369e5..cb55ee4 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -300,8 +300,6 @@ void arch_cpu_idle(void)
 {
 	if (cpuidle_idle_call())
 		x86_idle();
-	else
-		local_irq_enable();
 }
 
 /*
-- 
1.7.9.5

