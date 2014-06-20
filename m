Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966893AbaFTTcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:32:55 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:42372 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966614AbaFTTcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:32:51 -0400
Message-Id: <20140620193128.347401329@linux.com>
Date: Fri, 20 Jun 2014 14:31:44 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH 29/31] avr32: Replace __get_cpu_var with __this_cpu_write
References: <20140620193115.547427118@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_avr32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the single use of __get_cpu_var in avr32 with
__this_cpu_write.

Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/avr32/kernel/kprobes.c
===================================================================
--- linux.orig/arch/avr32/kernel/kprobes.c	2014-02-25 13:26:10.810735980 -0600
+++ linux/arch/avr32/kernel/kprobes.c	2014-02-25 13:26:10.810735980 -0600
@@ -104,7 +104,7 @@
 
 static void __kprobes set_current_kprobe(struct kprobe *p)
 {
-	__get_cpu_var(current_kprobe) = p;
+	__this_cpu_write(current_kprobe, p);
 }
 
 static int __kprobes kprobe_handler(struct pt_regs *regs)

