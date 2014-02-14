Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaBNUUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:20:50 -0500
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:53256
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753321AbaBNUUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:20:46 -0500
Message-Id: <20140214201908.639936486@linux.com>
Date: Fri, 14 Feb 2014 14:19:25 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH 44/48] avr32: Replace __get_cpu_var with __this_cpu_write
References: <20140214201841.826179349@linux.com>
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
--- linux.orig/arch/avr32/kernel/kprobes.c	2013-12-02 16:08:00.844326498 -0600
+++ linux/arch/avr32/kernel/kprobes.c	2013-12-02 16:08:00.834326779 -0600
@@ -104,7 +104,7 @@ static void __kprobes resume_execution(s
 
 static void __kprobes set_current_kprobe(struct kprobe *p)
 {
-	__get_cpu_var(current_kprobe) = p;
+	__this_cpu_write(current_kprobe, p);
 }
 
 static int __kprobes kprobe_handler(struct pt_regs *regs)

