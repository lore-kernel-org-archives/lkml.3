Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723AbbA1CIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:08:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759923AbbA1B2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Beulich <jbeulich@suse.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.18 37/61] x86, irq: Properly tag virtualization entry in /proc/interrupts
Date: Tue, 27 Jan 2015 17:26:49 -0800
Message-Id: <20150128012640.956299851@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <JBeulich@suse.com>

commit 4a0d3107d6b19125f21172c2b7d95f9c30ecaf6f upstream.

The mis-naming likely was a copy-and-paste effect.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/54B9408B0200007800055E8B@mail.emea.novell.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -127,7 +127,7 @@ int arch_show_interrupts(struct seq_file
 	seq_printf(p, "  Machine check polls\n");
 #endif
 #if IS_ENABLED(CONFIG_HYPERV) || defined(CONFIG_XEN)
-	seq_printf(p, "%*s: ", prec, "THR");
+	seq_printf(p, "%*s: ", prec, "HYP");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_hv_callback_count);
 	seq_printf(p, "  Hypervisor callback interrupts\n");


