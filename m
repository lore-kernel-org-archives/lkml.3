Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab3AYSEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:04:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23138 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265Ab3AYSET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:04:19 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=AHYp2_bTrk8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ikAxON-xGAUA:10 a=pGLkceISAAAA:8 a=N5gpYUMNoHB8MiE9ncsA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359137056.21576.239.camel@gandalf.local.home>
Subject: [PATCH] mips/ftrace: Fix kernel compile error
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>
Cc: Al Cooper <alcooperx@gmail.com>, David Daney <ddaney.cavm@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>
Date: Fri, 25 Jan 2013 13:04:16 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While compiling for my yeeloong2 laptop, I hit this compile error.

As warnings are set for errors, if we define ftrace_modify_code_2(), we
must use it. As MIPS 64 does not use this function, it requires being
commented out via an #ifndef CONFIG_64bit. Otherwise you get this error:

  CC      arch/mips/kernel/ftrace.o
cc1: warnings being treated as errors
/work/autotest/nobackup/mips-test.git/arch/mips/kernel/ftrace.c:98:12:
error: 'ftrace_modify_code_2' defined but not used
make[3]: *** [arch/mips/kernel/ftrace.o] Error 1
make[2]: *** [arch/mips/kernel] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [arch/mips] Error 2
make[1]: *** Waiting for unfinished jobs....


Cc: Al Cooper <alcooperx@gmail.com>
Cc: David Daney <ddaney.cvm@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
index 6bcb678..83fa146 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -95,6 +95,7 @@ static int ftrace_modify_code(unsigned long ip, unsigned int new_code)
 	return 0;
 }
 
+#ifndef CONFIG_64BIT
 static int ftrace_modify_code_2(unsigned long ip, unsigned int new_code1,
 				unsigned int new_code2)
 {
@@ -110,6 +111,7 @@ static int ftrace_modify_code_2(unsigned long ip, unsigned int new_code1,
 	flush_icache_range(ip, ip + 8); /* original ip + 12 */
 	return 0;
 }
+#endif
 
 /*
  * The details about the calling site of mcount on MIPS


