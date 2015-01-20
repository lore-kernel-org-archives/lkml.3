Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbbATLnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:43:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56511 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbbATLnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:43:05 -0500
Date: Tue, 20 Jan 2015 03:42:52 -0800
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-4a0d3107d6b19125f21172c2b7d95f9c30ecaf6f@git.kernel.org>
Cc: mingo@kernel.org, jbeulich@suse.com, hpa@zytor.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, JBeulich@suse.com
Reply-To: jbeulich@suse.com, hpa@zytor.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, JBeulich@suse.com, mingo@kernel.org
In-Reply-To: <54B9408B0200007800055E8B@mail.emea.novell.com>
References: <54B9408B0200007800055E8B@mail.emea.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, irq: Properly tag virtualization entry in /
 proc/interrupts
Git-Commit-ID: 4a0d3107d6b19125f21172c2b7d95f9c30ecaf6f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a0d3107d6b19125f21172c2b7d95f9c30ecaf6f
Gitweb:     http://git.kernel.org/tip/4a0d3107d6b19125f21172c2b7d95f9c30ecaf6f
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 16 Jan 2015 15:47:07 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 20 Jan 2015 12:37:23 +0100

x86, irq: Properly tag virtualization entry in /proc/interrupts

The mis-naming likely was a copy-and-paste effect.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/54B9408B0200007800055E8B@mail.emea.novell.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 6307a0f..705ef8d 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -127,7 +127,7 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 	seq_puts(p, "  Machine check polls\n");
 #endif
 #if IS_ENABLED(CONFIG_HYPERV) || defined(CONFIG_XEN)
-	seq_printf(p, "%*s: ", prec, "THR");
+	seq_printf(p, "%*s: ", prec, "HYP");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_hv_callback_count);
 	seq_puts(p, "  Hypervisor callback interrupts\n");
