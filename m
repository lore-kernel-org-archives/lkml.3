Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab3FZTnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:43:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12204 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3FZTnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:43:40 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Oxi_NWkH43cA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=imA-zbZYuvsA:10 a=1mlNsQWPZikZu6gH3BsA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372275817.18733.270.camel@gandalf.local.home>
Subject: [RFC][PATCH RT 0.5/6] locallock: Add include of percpu.h
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clark.williams@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 26 Jun 2013 15:43:37 -0400
In-Reply-To: <20130626192806.107564905@goodmis.org>
References: <20130626192806.107564905@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ I cut and pasted the series file but missed this patch to start ]

locallock.h uses per cpu variables, and if it is included by code
that does not include percpu.h, the compiler complains.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/include/linux/locallock.h
===================================================================
--- linux-rt.git.orig/include/linux/locallock.h
+++ linux-rt.git/include/linux/locallock.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_LOCALLOCK_H
 #define _LINUX_LOCALLOCK_H
 
+#include <linux/percpu.h>
 #include <linux/spinlock.h>
 
 #ifdef CONFIG_PREEMPT_RT_BASE


