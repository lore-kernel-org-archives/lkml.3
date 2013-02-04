Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab3BDPwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:52:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9417 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab3BDPwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:52:24 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=-9Ntqml9iOsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=D17T_x5yqqUA:10 a=PrCk1zBdltlUzRl7ezUA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359993141.5642.61.camel@gandalf.local.home>
Subject: [PATCH] rcu: Have rcu torture test select trace_clock
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 04 Feb 2013 10:52:21 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rcu torture test uses trace_clock, and requires that it be built
into the kernel. If it is not, then we get the following build error:

ERROR: "trace_clock_local" [kernel/rcutorture.ko] undefined!

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 4057127..b542477 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -942,6 +942,7 @@ config SPARSE_RCU_POINTER
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL
+	select TRACE_CLOCK
 	default n
 	help
 	  This option provides a kernel module that runs torture tests


