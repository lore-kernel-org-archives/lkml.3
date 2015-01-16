Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbbAPPrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:47:10 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:50278 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbbAPPrI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 16 Jan 2015 10:47:08 -0500
Message-Id: <54B9408B0200007800055E8B@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Fri, 16 Jan 2015 15:47:07 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: properly tag virtualization entry in
 /proc/interrupts
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mis-naming likely was a copy-and-paste effect.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 arch/x86/kernel/irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.19-rc4/arch/x86/kernel/irq.c
+++ 3.19-rc4-xen-x86-HYP-interrupt/arch/x86/kernel/irq.c
@@ -127,7 +127,7 @@ int arch_show_interrupts(struct seq_file
 	seq_puts(p, "  Machine check polls\n");
 #endif
 #if IS_ENABLED(CONFIG_HYPERV) || defined(CONFIG_XEN)
-	seq_printf(p, "%*s: ", prec, "THR");
+	seq_printf(p, "%*s: ", prec, "HYP");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_hv_callback_count);
 	seq_puts(p, "  Hypervisor callback interrupts\n");



