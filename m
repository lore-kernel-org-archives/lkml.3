Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3EJVSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 17:18:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13174 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab3EJVS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 17:18:27 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=jB67A_zoR28A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=0cHSfWUJHcEA:10 a=NpxI-HVzja7l_C84ficA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130510211825.655823570@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 17:12:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/3] nohz: Warn if the machine can not perform nohz_full
References: <20130510211225.594959788@goodmis.org>
Content-Disposition: inline; filename=warn-no-hz.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the user configures NO_HZ_FULL and defines nohz_full=XXX on the
kerenl command line, or enables NO_HZ_FULL_ALL, but nohz fails
due to the machine having a unstable clock, warn about it.

We do not want users thinking that they are getting the benefit
of nohz when their machine can not support it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-trace.git/kernel/time/tick-sched.c
===================================================================
--- linux-trace.git.orig/kernel/time/tick-sched.c
+++ linux-trace.git/kernel/time/tick-sched.c
@@ -178,6 +178,11 @@ static bool can_stop_full_tick(void)
 	 */
 	if (!sched_clock_stable) {
 		trace_tick_stop(0, "unstable sched clock\n");
+		/*
+		 * Don't allow the user to think they can get
+		 * full NO_HZ with this machine.
+		 */
+		WARN_ONCE(1, "NO_HZ FULL will not work with unstable sched clock");
 		return false;
 	}
 #endif

