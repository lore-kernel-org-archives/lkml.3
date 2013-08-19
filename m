Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab3HSUpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:45:04 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:62746 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3HSUpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:45:02 -0400
MIME-Version: 1.0
Date: Mon, 19 Aug 2013 13:45:01 -0700
Message-ID: <CALJNCATz+mXNCMC1nqfkXE=ya0n-hv_Nh2DQwVVguLfri4eEDQ@mail.gmail.com>
Subject: [PATCH] fix for a Sparse Warning in the arch/x86/kernel/irq_work.c file
From: Charvi Bhargava <cbhargava15@jesuitmail.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am a high school student familiarizing myself the opensource process
as well as the linux kernel. This is my first submission the LTC -
interlock mailing list.

My patch is a patch for the file arch/x86/kernel/irq_work.c in the
version linux-3.10. When I ran the kernel with Sparse, the error read:
arch/x86/kernel/irq_work.c:12:
6 warning: symbol
'arch_irq_work_interrupt' was not declared. Should it be static?

To fix this I declared the symbol for 'smp_irq_work_interrupt' in the
irq_work.h header file.

Signed off by: Charvi Bhargava <cbhargava15@jesuitmail.org>

---

 include/linux/irq_work.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 6601702..919751a 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -33,6 +33,7 @@ void init_irq_work(struct irq_work *work, void
(*func)(struct irq_work *))
 void irq_work_queue(struct irq_work *work);
 void irq_work_run(void);
 void irq_work_sync(struct irq_work *work);
+void smp_irq_work_interrupt(struct pt_regs *regs);

 #ifdef CONFIG_IRQ_WORK
 bool irq_work_needs_cpu(void);
--

After creating this patch, I verified that my error did not show up
when I ran the kernel with Sparse again. I also ran the command "make
menuconfig" and changed the kernel version of the kernel so that I
could assure the correct kernel was running when I tested it, and it
was. Then I test built the kernel. It built and rebooted correctly.
