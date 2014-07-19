Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965922AbaGSNRH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:17:07 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:11686 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755508AbaGSNQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:16 -0400
Message-Id: <20140719131613.607918175@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        James Hogan <james.hogan@imgtec.com>
Subject: [for-next][PATCH 24/32] metag: ftrace: Remove check of obsolete variable function_trace_stop
References: <20140719131524.009152325@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0024-metag-ftrace-Remove-check-of-obsolete-variable-funct.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Nothing sets function_trace_stop to disable function tracing anymore.
Remove the check for it in the arch code.

Acked-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/metag/Kconfig              |  1 -
 arch/metag/kernel/ftrace_stub.S | 14 --------------
 2 files changed, 15 deletions(-)

diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
index 499b7610eaaf..0b389a81c43a 100644
--- a/arch/metag/Kconfig
+++ b/arch/metag/Kconfig
@@ -13,7 +13,6 @@ config METAG
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_TRACER
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZO
diff --git a/arch/metag/kernel/ftrace_stub.S b/arch/metag/kernel/ftrace_stub.S
index e70bff745bdd..3acc288217c0 100644
--- a/arch/metag/kernel/ftrace_stub.S
+++ b/arch/metag/kernel/ftrace_stub.S
@@ -16,13 +16,6 @@ _mcount_wrapper:
 	.global _ftrace_caller
 	.type	_ftrace_caller,function
 _ftrace_caller:
-	MOVT    D0Re0,#HI(_function_trace_stop)
-	ADD	D0Re0,D0Re0,#LO(_function_trace_stop)
-	GETD	D0Re0,[D0Re0]
-	CMP	D0Re0,#0
-	BEQ	$Lcall_stub
-	MOV	PC,D0.4
-$Lcall_stub:
 	MSETL   [A0StP], D0Ar6, D0Ar4, D0Ar2, D0.4
 	MOV     D1Ar1, D0.4
 	MOV     D0Ar2, D1RtP
@@ -42,13 +35,6 @@ _ftrace_call:
 	.global	_mcount_wrapper
 	.type	_mcount_wrapper,function
 _mcount_wrapper:
-	MOVT    D0Re0,#HI(_function_trace_stop)
-	ADD	D0Re0,D0Re0,#LO(_function_trace_stop)
-	GETD	D0Re0,[D0Re0]
-	CMP	D0Re0,#0
-	BEQ	$Lcall_mcount
-	MOV	PC,D0.4
-$Lcall_mcount:
 	MSETL   [A0StP], D0Ar6, D0Ar4, D0Ar2, D0.4
 	MOV     D1Ar1, D0.4
 	MOV     D0Ar2, D1RtP
-- 
2.0.1


