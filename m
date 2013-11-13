Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab3KMTnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 14:43:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54597 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab3KMTnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 14:43:15 -0500
Date: Wed, 13 Nov 2013 11:42:57 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-650e4dc2a75959fdca1eecc0147bbb21dbfadf0f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        takata@linux-m32r.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, takata@linux-m32r.org
In-Reply-To: <20130917183628.758421136@linutronix.de>
References: <20130917183628.758421136@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] m32r: Use preempt_schedule_irq
Git-Commit-ID: 650e4dc2a75959fdca1eecc0147bbb21dbfadf0f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 13 Nov 2013 11:43:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  650e4dc2a75959fdca1eecc0147bbb21dbfadf0f
Gitweb:     http://git.kernel.org/tip/650e4dc2a75959fdca1eecc0147bbb21dbfadf0f
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 17 Sep 2013 18:53:07 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 13 Nov 2013 20:21:46 +0100

m32r: Use preempt_schedule_irq

Use the proper core function instead of fiddling with preempt_active
and interrupt enable in the low level code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-m32r-ja@ml.linux-m32r.org
Link: http://lkml.kernel.org/r/20130917183628.758421136@linutronix.de
---
 arch/m32r/kernel/entry.S | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/m32r/kernel/entry.S b/arch/m32r/kernel/entry.S
index 0c01543..7c3db99 100644
--- a/arch/m32r/kernel/entry.S
+++ b/arch/m32r/kernel/entry.S
@@ -182,13 +182,7 @@ need_resched:
 	ld	r4, PSW(sp)		; interrupts off (exception path) ?
 	and3	r4, r4, #0x4000
 	beqz	r4, restore_all
-	LDIMM	(r4, PREEMPT_ACTIVE)
-	st	r4, @(TI_PRE_COUNT, r8)
-	ENABLE_INTERRUPTS(r4)
-	bl	schedule
-	ldi	r4, #0
-	st	r4, @(TI_PRE_COUNT, r8)
-	DISABLE_INTERRUPTS(r4)
+	bl	preempt_schedule_irq
 	bra	need_resched
 #endif
 
