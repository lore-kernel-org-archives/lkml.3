Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbaKEROD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:14:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41719 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762AbaKEROA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:14:00 -0500
Date: Wed, 5 Nov 2014 09:12:30 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-54c3cc2cd894f0d22897ebb283b6eddca4c814c0@git.kernel.org>
Cc: tony.luck@intel.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, yinghai@kernel.org, bhelgaas@google.com,
        rjw@rjwysocki.net, konrad.wilk@oracle.com, bp@alien8.de,
        jiang.liu@linux.intel.com, tglx@linutronix.de, rdunlap@infradead.org,
        joro@8bytes.org, hpa@zytor.com, benh@kernel.crashing.org
Reply-To: linux-kernel@vger.kernel.org, tony.luck@intel.com, mingo@kernel.org,
        bp@alien8.de, konrad.wilk@oracle.com, rjw@rjwysocki.net,
        bhelgaas@google.com, yinghai@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, jiang.liu@linux.intel.com,
        benh@kernel.crashing.org, hpa@zytor.com, joro@8bytes.org,
        rdunlap@infradead.org
In-Reply-To: <1414397531-28254-21-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-21-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Provide empty send_cleanup_vector()
  stub for UP builds
Git-Commit-ID: 54c3cc2cd894f0d22897ebb283b6eddca4c814c0
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

Commit-ID:  54c3cc2cd894f0d22897ebb283b6eddca4c814c0
Gitweb:     http://git.kernel.org/tip/54c3cc2cd894f0d22897ebb283b6eddca4c814c0
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:12:11 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 5 Nov 2014 18:10:45 +0100

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
