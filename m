Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934244Ab3E1Niv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:38:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50651 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934061Ab3E1Nit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:38:49 -0400
Date: Tue, 28 May 2013 06:38:32 -0700
From: tip-bot for David Cohen <tipbot@zytor.com>
Message-ID: <tip-8c956b1b935ec98decb470a6abff8c1f8b28e9f0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, david.a.cohen@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, david.a.cohen@intel.com
In-Reply-To: <1367364015-12521-1-git-send-email-david.a.cohen@intel.com>
References: <1367364015-12521-1-git-send-email-david.a.cohen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irq/x86/io_apic: Fix number of pre-allocated irqs
Git-Commit-ID: 8c956b1b935ec98decb470a6abff8c1f8b28e9f0
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

Commit-ID:  8c956b1b935ec98decb470a6abff8c1f8b28e9f0
Gitweb:     http://git.kernel.org/tip/8c956b1b935ec98decb470a6abff8c1f8b28e9f0
Author:     David Cohen <david.a.cohen@intel.com>
AuthorDate: Tue, 30 Apr 2013 16:20:15 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 12:01:29 +0200

irq/x86/io_apic: Fix number of pre-allocated irqs

arch_probe_nr_irqs() has a typo when returning number of
preallocated irqs. Instead of returning the calculated value, it
returns a constant number NR_IRQ_LEGACY.

This patch makes sure the calculated value is returned intead.

Signed-off-by: David Cohen <david.a.cohen@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: joro@8bytes.org
Link: http://lkml.kernel.org/r/1367364015-12521-1-git-send-email-david.a.cohen@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9ed796c..7ef2bd9 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3437,7 +3437,7 @@ int __init arch_probe_nr_irqs(void)
 	if (nr < nr_irqs)
 		nr_irqs = nr;
 
-	return NR_IRQS_LEGACY;
+	return nr;
 }
 
 int io_apic_set_pci_routing(struct device *dev, int irq,
