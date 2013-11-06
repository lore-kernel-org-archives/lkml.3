Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab3KFRnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 12:43:35 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:37676 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754557Ab3KFRne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 12:43:34 -0500
Date: Wed, 6 Nov 2013 12:43:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH] avr32: Remove HAVE_KPROBES from avr32 Kconfig
Message-ID: <20131106124330.4d73d200@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although there's a arch/avr32/kernel/kprobes.c file, this arch does not
compile with kprobes enabled:

 In file included from cross-linux.git/arch/avr32/kernel/kprobes.c:14:
 cross-linux.git/include/linux/kprobes.h: In function 'get_kprobe_ctlblk':
 cross-linux.git/include/linux/kprobes.h:358: error: invalid use of undefined type 'struct kprobe_ctlblk'
 cross-linux.git/include/linux/kprobes.h:358: error: dereferencing pointer to incomplete type
 make[2]: *** [arch/avr32/kernel/kprobes.o] Error 1

This is because it does not define the required kprobe_ctlblk struct,
and fails to compile when CONFIG_KPROBES is set.

Unfortunately, this also makes my testing of various configs for
different archs to fail on avr32 as well.

If kprobes is not supported by avr32 than do not say that it is.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index b6878eb..25bcc62 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -5,7 +5,6 @@ config AVR32
 	select EXPERT
 	select HAVE_CLK
 	select HAVE_OPROFILE
-	select HAVE_KPROBES
 	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_ATOMIC64
