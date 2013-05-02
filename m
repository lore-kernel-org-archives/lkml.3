Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555Ab3EBP0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:26:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26856 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab3EBP0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:26:15 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=GyEmDguFxqsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=WCdGjqVMsPwA:10 a=IOi9Ra_DCKqvQt2miG4A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367508373.30667.142.camel@gandalf.local.home>
Subject: [PATCH] tracing/trivial: Put trace_puts() comment above
 trace_puts() macro for kernel doc
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>
Date: Thu, 02 May 2013 11:26:13 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Kernel-doc gives the following warning:

  DOCPROC Documentation/DocBook/kernel-api.xml
Warning(/include/linux/kernel.h:590): No description found for parameter 'ip'
Warning(/include/linux/kernel.h:590): No description found for parameter 'ip'

Due to the externs between the the comment and the trace_puts() macro.
This is fixed by moving the externs below the macro and keeping the
macro and comment directly together.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2dac79c..2675814 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -586,9 +586,6 @@ int __trace_printk(unsigned long ip, const char *fmt, ...);
  * Returns: 0 if nothing was written, positive # if string was.
  *  (1 when __trace_bputs is used, strlen(str) when __trace_puts is used)
  */
-
-extern int __trace_bputs(unsigned long ip, const char *str);
-extern int __trace_puts(unsigned long ip, const char *str, int size);
 #define trace_puts(str) ({						\
 	static const char *trace_printk_fmt				\
 		__attribute__((section("__trace_printk_fmt"))) =	\
@@ -599,6 +596,8 @@ extern int __trace_puts(unsigned long ip, const char *str, int size);
 	else								\
 		__trace_puts(_THIS_IP_, str, strlen(str));		\
 })
+extern int __trace_bputs(unsigned long ip, const char *str);
+extern int __trace_puts(unsigned long ip, const char *str, int size);
 
 extern void trace_dump_stack(int skip);
 


