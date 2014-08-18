Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbaHRCpc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 22:45:32 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:59974 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751569AbaHRCpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 22:45:31 -0400
Date: Sun, 17 Aug 2014 21:45:27 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 26/35] [PATCH 26/36] powerpc: Replace __get_cpu_var
 uses
In-Reply-To: <20140817173036.985604442@linux.com>
Message-ID: <alpine.DEB.2.11.1408172143020.9652@gentwo.org>
References: <20140817173023.439660246@linux.com> <20140817173036.985604442@linux.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

korg tester found an issue:


From: Christoph Lameter <cl@liknux.com>
Subject: powerpc: Fix reference to opal_trace_depth.

depth is an address and not a scalar. Use & to determine the address.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/powerpc/platforms/powernv/opal-tracepoints.c
===================================================================
--- linux.orig/arch/powerpc/platforms/powernv/opal-tracepoints.c
+++ linux/arch/powerpc/platforms/powernv/opal-tracepoints.c
@@ -48,7 +48,7 @@ void __trace_opal_entry(unsigned long op

 	local_irq_save(flags);

-	depth = this_cpu_ptr(opal_trace_depth);
+	depth = this_cpu_ptr(&opal_trace_depth);

 	if (*depth)
 		goto out;
@@ -69,7 +69,7 @@ void __trace_opal_exit(long opcode, unsi

 	local_irq_save(flags);

-	depth = this_cpu_ptr(opal_trace_depth);
+	depth = this_cpu_ptr(&opal_trace_depth);

 	if (*depth)
 		goto out;
