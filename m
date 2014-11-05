Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbaKEQgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:36:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41164 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaKEQgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:36:20 -0500
Date: Wed, 5 Nov 2014 08:34:19 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-e70425eb31f79a802d601fd411fe694458c4561b@git.kernel.org>
Cc: jiang.liu@linux.intel.com, tony.luck@intel.com, rjw@rjwysocki.net,
        yinghai@kernel.org, konrad.wilk@oracle.com, bhelgaas@google.com,
        joro@8bytes.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        bp@alien8.de, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, rdunlap@infradead.org,
        gregkh@linuxfoundation.org
Reply-To: rjw@rjwysocki.net, yinghai@kernel.org, jiang.liu@linux.intel.com,
        tony.luck@intel.com, joro@8bytes.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, bhelgaas@google.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@kernel.org, bp@alien8.de,
        rdunlap@infradead.org, gregkh@linuxfoundation.org,
        benh@kernel.crashing.org
In-Reply-To: <1414397531-28254-21-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-21-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Provide empty send_cleanup_vector()
  stub for UP builds
Git-Commit-ID: e70425eb31f79a802d601fd411fe694458c4561b
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

Commit-ID:  e70425eb31f79a802d601fd411fe694458c4561b
Gitweb:     http://git.kernel.org/tip/e70425eb31f79a802d601fd411fe694458c4561b
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:12:11 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 5 Nov 2014 11:04:46 +0100

x86, irq: Provide empty send_cleanup_vector() stub for UP builds

Define an empty send_cleanup_vector() for UP kernel to fix link error
of undefined reference, which is used by uv_irq and irq_remapping.

[ tglx: Made it an inline stub and moved it ahead of the file split
  	changes ]

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1414397531-28254-21-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/hw_irq.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index cb7917f..8dbe237 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -153,7 +153,11 @@ struct irq_cfg {
 };
 
 extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
+#ifdef CONFIG_SMP
 extern void send_cleanup_vector(struct irq_cfg *);
+#else
+static inline void send_cleanup_vector(struct irq_cfg *c) { }
+#endif
 
 struct irq_data;
 int __ioapic_set_affinity(struct irq_data *, const struct cpumask *,
