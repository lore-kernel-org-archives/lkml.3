Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbbAIMco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:32:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60179 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbbAIMcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:32:43 -0500
Date: Fri, 9 Jan 2015 04:31:46 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-0f363b250b15af0f218bb2876d101fe5cd413f8b@git.kernel.org>
Cc: mingo@kernel.org, dave.hansen@linux.intel.com, acme@redhat.com,
        torvalds@linux-foundation.org, jolsa@redhat.com, eranian@google.com,
        jkenisto@us.ibm.com, linux-kernel@vger.kernel.org, kan.liang@intel.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        ak@linux.intel.com, peterz@infradead.org, hpa@zytor.com
Reply-To: eranian@google.com, jkenisto@us.ibm.com,
        linux-kernel@vger.kernel.org, ak@linux.intel.com, kan.liang@intel.com,
        tglx@linutronix.de, masami.hiramatsu.pt@hitachi.com, hpa@zytor.com,
        peterz@infradead.org, mingo@kernel.org, dave.hansen@linux.intel.com,
        jolsa@redhat.com, torvalds@linux-foundation.org, acme@redhat.com
In-Reply-To: <20141216104614.GV3337@twins.programming.kicks-ass.net>
References: <20141216104614.GV3337@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] x86: Fix off-by-one in instruction decoder
Git-Commit-ID: 0f363b250b15af0f218bb2876d101fe5cd413f8b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f363b250b15af0f218bb2876d101fe5cd413f8b
Gitweb:     http://git.kernel.org/tip/0f363b250b15af0f218bb2876d101fe5cd413f8b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 16 Dec 2014 11:46:14 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 9 Jan 2015 11:12:26 +0100

x86: Fix off-by-one in instruction decoder

Stephane reported that the PEBS fixup was broken by the recent commit to
the instruction decoder. The thing had an off-by-one which resulted in
not being able to decode the last instruction and always bail.

Reported-by: Stephane Eranian <eranian@google.com>
Fixes: 6ba48ff46f76 ("x86: Remove arbitrary instruction size limit in instruction decoder")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org # 3.18
Cc: <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Liang Kan <kan.liang@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/20141216104614.GV3337@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/lib/insn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 2480978..1313ae6 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -28,7 +28,7 @@
 
 /* Verify next sizeof(t) bytes can be on the same instruction */
 #define validate_next(t, insn, n)	\
-	((insn)->next_byte + sizeof(t) + n < (insn)->end_kaddr)
+	((insn)->next_byte + sizeof(t) + n <= (insn)->end_kaddr)
 
 #define __get_next(t, insn)	\
 	({ t r = *(t*)insn->next_byte; insn->next_byte += sizeof(t); r; })
