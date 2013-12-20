Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab3LTRt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 12:49:27 -0500
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:41504
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895Ab3LTRt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 12:49:26 -0500
X-Authority-Analysis: v=2.1 cv=M6V0dUAs c=1 sm=1 tr=0
 a=P1/czelPj/zYsqkqtI4LGg==:117 a=P1/czelPj/zYsqkqtI4LGg==:17 a=PuvxfXWCAAAA:8
 a=C_IRinGWAAAA:8 a=GGcpBh7Jt_oA:10 a=-WwNHMU88Q4A:10 a=WuCusnQs47UA:10
 a=wPDyFdB5xvgA:10 a=NufY4J3AAAAA:8 a=KzMNtAa5ikUA:10 a=nlC_4_pT8q9DhB4Ho9EA:9
 a=cz2ZRIgtxKwA:10 a=wJWlkF7cXJYA:10 a=DKaUk24zBScKoA4pmcsA:9
 a=CjuIK1q_8ugA:10 a=dOYBo6RpTd0A:10 a=pOR2WPV-qBAA:10 a=zAyngx5bAAAA:8
 a=VAFAUJkowcUm3wKbofEA:9 a=kt2o4b_9nEejsCxR:21 a=tHNyf73kXbzlcCHq:21
 a=9g6PTisfegMA:10
Date: Fri, 20 Dec 2013 11:49:23 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: David Daney <ddaney.cavm@gmail.com>
cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips <linux-mips@linux-mips.org>,
        Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 29/40] mips: Replace __get_cpu_var uses
In-Reply-To: <52B37C56.7090302@gmail.com>
Message-ID: <alpine.DEB.2.10.1312201148560.13718@nuc>
References: <20131219155015.443763038@linux.com> <20131219155033.834416420@linux.com> <52B330F3.4090603@gmail.com> <alpine.DEB.2.10.1312191506370.17603@nuc> <52B37C56.7090302@gmail.com>
Content-Type: MULTIPART/Mixed; BOUNDARY=------------070507070702050801040409
Content-ID: <alpine.DEB.2.10.1312201148561.13718@nuc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--------------070507070702050801040409
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Content-ID: <alpine.DEB.2.10.1312201148562.13718@nuc>

On Thu, 19 Dec 2013, David Daney wrote:

> > Use
> >
> > __local_inc(this_cpu_ptr(fpuemustats.M);
> >
>
> No, I couldn't get various incantations of that to work either.

Your patch removes the last use of local.h by mips arch code by the way.


--------------070507070702050801040409
Content-Type: TEXT/X-PATCH; NAME=0001-MIPS-Replace-__get_cpu_var-uses-in-FPU-emulator.patch
Content-ID: <alpine.DEB.2.10.1312201148563.13718@nuc>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME*0=0001-MIPS-Replace-__get_cpu_var-uses-in-FPU-emulator.patch

>From cc9590cf4d75cf7fd36a58be132d35fbbe536a64 Mon Sep 17 00:00:00 2001
From: David Daney <david.daney@cavium.com>
Date: Thu, 19 Dec 2013 14:00:17 -0800
Subject: [PATCH] MIPS: Replace __get_cpu_var uses in FPU emulator.

The use of __this_cpu_inc() requires a fundamental integer type, so
change the type of all the counters to unsigned long, which is the
same width they were before, but not wrapped in local_t.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/fpu_emulator.h | 14 +++++++-------
 arch/mips/math-emu/cp1emu.c          |  6 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/mips/include/asm/fpu_emulator.h b/arch/mips/include/asm/fpu_emulator.h
index 2abb587..619fa5f 100644
--- a/arch/mips/include/asm/fpu_emulator.h
+++ b/arch/mips/include/asm/fpu_emulator.h
@@ -30,12 +30,12 @@
 #ifdef CONFIG_DEBUG_FS
 
 struct mips_fpu_emulator_stats {
-	local_t emulated;
-	local_t loads;
-	local_t stores;
-	local_t cp1ops;
-	local_t cp1xops;
-	local_t errors;
+	unsigned long emulated;
+	unsigned long loads;
+	unsigned long stores;
+	unsigned long cp1ops;
+	unsigned long cp1xops;
+	unsigned long errors;
 };
 
 DECLARE_PER_CPU(struct mips_fpu_emulator_stats, fpuemustats);
@@ -43,7 +43,7 @@ DECLARE_PER_CPU(struct mips_fpu_emulator_stats, fpuemustats);
 #define MIPS_FPU_EMU_INC_STATS(M)					\
 do {									\
 	preempt_disable();						\
-	__local_inc(&__get_cpu_var(fpuemustats).M);			\
+	__this_cpu_inc(fpuemustats.M);					\
 	preempt_enable();						\
 } while (0)
 
diff --git a/arch/mips/math-emu/cp1emu.c b/arch/mips/math-emu/cp1emu.c
index efe0088..b853d05 100644
--- a/arch/mips/math-emu/cp1emu.c
+++ b/arch/mips/math-emu/cp1emu.c
@@ -2110,13 +2110,13 @@ int fpu_emulator_cop1Handler(struct pt_regs *xcp, struct mips_fpu_struct *ctx,
 static int fpuemu_stat_get(void *data, u64 *val)
 {
 	int cpu;
-	unsigned long sum = 0;
+	u64 sum = 0;
 	for_each_online_cpu(cpu) {
 		struct mips_fpu_emulator_stats *ps;
-		local_t *pv;
+		unsigned long *pv;
 		ps = &per_cpu(fpuemustats, cpu);
 		pv = (void *)ps + (unsigned long)data;
-		sum += local_read(pv);
+		sum += *pv;
 	}
 	*val = sum;
 	return 0;
-- 
1.7.11.7


--------------070507070702050801040409--
