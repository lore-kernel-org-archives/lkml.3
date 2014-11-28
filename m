Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaK1SaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:30:00 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39856 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaK1SYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:25 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 08/30] apm32: Fix cputime == jiffies assumption
Date: Fri, 28 Nov 2014 19:23:38 +0100
Message-Id: <1417199040-21044-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That code wrongly assumes that cputime_t wraps jiffies_t. Lets use
the correct accessors/mutators.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/apm_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 5848744..b3949c3 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -920,7 +920,7 @@ recalc:
 	} else if (jiffies_since_last_check > idle_period) {
 		unsigned int idle_percentage;
 
-		idle_percentage = stime - last_stime;
+		idle_percentage = cputime_to_jiffies(stime - last_stime);
 		idle_percentage *= 100;
 		idle_percentage /= jiffies_since_last_check;
 		use_apm_idle = (idle_percentage > idle_threshold);
-- 
2.1.3

