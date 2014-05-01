Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbaEAUlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 16:41:24 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:57537
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022AbaEAUlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 16:41:22 -0400
Date: Thu, 1 May 2014 15:41:20 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Haavard Skinnemoen <hskinnemoen@gmail.com>
cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel@vger.kernel.org
Subject: avr32: Replace __get_cpu_var with __this_cpu_write
Message-ID: <alpine.DEB.2.10.1405011540050.21167@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
