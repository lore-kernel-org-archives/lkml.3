Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaEHTMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:12:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125AbaEHTMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:12:23 -0400
Date: Thu, 8 May 2014 21:11:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] x86/traps: Make math_error() static
Message-ID: <20140508191153.GA16910@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508191140.GA16892@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial, make math_error() static.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/traps.h |    1 -
 arch/x86/kernel/traps.c      |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 58d66fe..a7b212d 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -98,7 +98,6 @@ static inline int get_si_code(unsigned long condition)
 
 extern int panic_on_unrecovered_nmi;
 
-void math_error(struct pt_regs *, int, int);
 void math_emulate(struct math_emu_info *);
 #ifndef CONFIG_X86_32
 asmlinkage void smp_thermal_interrupt(void);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 57409f6..8eddd62 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -488,7 +488,7 @@ exit:
  * the correct behaviour even in the presence of the asynchronous
  * IRQ13 behaviour
  */
-void math_error(struct pt_regs *regs, int error_code, int trapnr)
+static void math_error(struct pt_regs *regs, int error_code, int trapnr)
 {
 	struct task_struct *task = current;
 	siginfo_t info;
-- 
1.5.5.1

