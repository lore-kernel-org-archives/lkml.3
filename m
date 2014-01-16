Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbaAPNkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:40:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38380 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbaAPNkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:40:00 -0500
Date: Thu, 16 Jan 2014 05:39:32 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-54b278b50b8566c227437d6198412cb5a6619e6b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, fengguang.wu@intel.com
In-Reply-To: <20140112212456.GQ7572@laptop.programming.kicks-ass.net>
References: <20140112212456.GQ7572@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] m68k: Fix build warning in mac_via.h
Git-Commit-ID: 54b278b50b8566c227437d6198412cb5a6619e6b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:39:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54b278b50b8566c227437d6198412cb5a6619e6b
Gitweb:     http://git.kernel.org/tip/54b278b50b8566c227437d6198412cb5a6619e6b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sun, 12 Jan 2014 22:24:56 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 16 Jan 2014 09:27:02 +0100

m68k: Fix build warning in mac_via.h

Fengguang Wu's kbuild test robot reported the following new m68k warnings:

     In file included from drivers/nubus/nubus.c:22:0:
  >> arch/m68k/include/asm/mac_via.h:262:47: warning: 'struct irq_desc' declared inside parameter list [enabled by default]
  >> arch/m68k/include/asm/mac_via.h:262:47: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]

Caused by the reworking of the generic local_bh{dis,en}able() code.

To fix it, forward declare 'struct irq_desc'.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Fixes: c795eb55e740 ("sched/preempt, locking: Rework local_bh_{dis,en}able()")
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: geert@linux-m68k.org
Link: http://lkml.kernel.org/r/20140112212456.GQ7572@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/m68k/include/asm/mac_via.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/m68k/include/asm/mac_via.h b/arch/m68k/include/asm/mac_via.h
index aeeedf8..fe3fc9a 100644
--- a/arch/m68k/include/asm/mac_via.h
+++ b/arch/m68k/include/asm/mac_via.h
@@ -254,6 +254,8 @@
 extern volatile __u8 *via1,*via2;
 extern int rbv_present,via_alt_mapping;
 
+struct irq_desc;
+
 extern void via_register_interrupts(void);
 extern void via_irq_enable(int);
 extern void via_irq_disable(int);
