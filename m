Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab3HLWSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 18:18:18 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:53183 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab3HLWSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 18:18:17 -0400
MIME-Version: 1.0
Date: Mon, 12 Aug 2013 15:18:16 -0700
Message-ID: <CAOUhrBGcH4Oe32cDFs++a1UyKaGNfCm1sCG6UC4an_fO5vDjjQ@mail.gmail.com>
Subject: [PATCH] fix a Sparse warning in the arch/x86/kernel/irq_work.c file
From: Shailaja Neelam <neelamshaila@gmail.com>
To: fweisbec@gmail.com, rostedt@goodmis.org, akpm@linux-foundation.org,
        anish198519851985@gmail.com, james.hogan@imgtec.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am a high school student trying to become familiar with the
opensource process and linux kernel. This is my first submission to
the ITC mailing list.

My patch is for the file arch/x86/kernel/irq_work.c in the vesion
linux-3.10 kernel. When I ran the kernel with Sparse, the error read:
arch/x86/kernel/irq_work.c:21:
6: warning: symbol 'arch_irq_work_raise'
was not declared. Should it be static?

To fix this (rather than add static) I declared the symbol in the
header file linux/irq_work.h. Afterwards, my error did not show up
when I ran the kernel with Sparse again. I also ran the command "make
menuconfig" to change the kernel version so that I could assure the
correct kernel was running when I tested it, and it was. Then I test
built the kernel. It built and rebooted correctly.

Signed-off-by: Shailaja Neelam <neelamshaila@gmail.com>
---
--- linux-3.10/include/linux/irq_
work.h    2013-06-30 15:13:29.000000000 -0700
+++ linux-3.10.change/include/linux/irq_work.h    2013-07-24
12:06:15.521140635 -0700
@@ -33,6 +33,7 @@ void init_irq_work(struct irq_work *work
 void irq_work_queue(struct irq_work *work);
 void irq_work_run(void);
 void irq_work_sync(struct irq_work *work);
+void arch_irq_work_raise(void);

 #ifdef CONFIG_IRQ_WORK
 bool irq_work_needs_cpu(void);
