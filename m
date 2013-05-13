Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab3EMQm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 12:42:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:53717 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab3EMQmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 12:42:08 -0400
Message-ID: <51911712.1090608@infradead.org>
Date: Mon, 13 May 2013 09:38:42 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] linux/kernel.h: fix kernel-doc warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix kernel-doc warning in <linux/kernel.h>:

Warning(include/linux/kernel.h:590): No description found for parameter 'ip'

scripts/kernel-doc cannot handle macros, functions, or function
prototypes between the function or macro that is being documented
and its definition, so move these prototypes above the function
that is being documented.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 include/linux/kernel.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- lnx-310-rc1.orig/include/linux/kernel.h
+++ lnx-310-rc1/include/linux/kernel.h
@@ -562,6 +562,9 @@ int __trace_bprintk(unsigned long ip, co
 extern __printf(2, 3)
 int __trace_printk(unsigned long ip, const char *fmt, ...);
 
+extern int __trace_bputs(unsigned long ip, const char *str);
+extern int __trace_puts(unsigned long ip, const char *str, int size);
+
 /**
  * trace_puts - write a string into the ftrace buffer
  * @str: the string to record
@@ -587,8 +590,6 @@ int __trace_printk(unsigned long ip, con
  *  (1 when __trace_bputs is used, strlen(str) when __trace_puts is used)
  */
 
-extern int __trace_bputs(unsigned long ip, const char *str);
-extern int __trace_puts(unsigned long ip, const char *str, int size);
 #define trace_puts(str) ({						\
 	static const char *trace_printk_fmt				\
 		__attribute__((section("__trace_printk_fmt"))) =	\
