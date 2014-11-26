Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaKZXMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:12:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58461 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaKZXM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:12:28 -0500
Date: Wed, 26 Nov 2014 15:11:36 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-179f77471f9654cc18693d6502fbc7ce075ed765@git.kernel.org>
Cc: rdunlap@infradead.org, bhelgaas@google.com, gregkh@linuxfoundation.org,
        tglx@linutronix.de, benh@kernel.crashing.org, konrad.wilk@oracle.com,
        yinghai@kernel.org, tony.luck@intel.com, rjw@rjwysocki.net,
        joro@8bytes.org, mingo@kernel.org, bp@alien8.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, jiang.liu@linux.intel.com
Reply-To: gregkh@linuxfoundation.org, bhelgaas@google.com,
        rdunlap@infradead.org, benh@kernel.crashing.org, tglx@linutronix.de,
        konrad.wilk@oracle.com, yinghai@kernel.org, rjw@rjwysocki.net,
        joro@8bytes.org, tony.luck@intel.com, bp@alien8.de, hpa@zytor.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org,
        jiang.liu@linux.intel.com
In-Reply-To: <1416894816-23245-24-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-24-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Normalize x86 irq_chip name
Git-Commit-ID: 179f77471f9654cc18693d6502fbc7ce075ed765
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

Commit-ID:  179f77471f9654cc18693d6502fbc7ce075ed765
Gitweb:     http://git.kernel.org/tip/179f77471f9654cc18693d6502fbc7ce075ed765
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 13:53:32 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 18:59:26 +0100

x86, irq: Normalize x86 irq_chip name

Some irq_chip names use underscore, others use hyphen. So normalize them
to use hythen as separator.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1416894816-23245-24-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/msi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index a24b803..2bf1348 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -188,7 +188,7 @@ dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 }
 
 static struct irq_chip dmar_msi_controller = {
-	.name			= "DMAR_MSI",
+	.name			= "DMAR-MSI",
 	.irq_unmask		= dmar_msi_unmask,
 	.irq_mask		= dmar_msi_mask,
 	.irq_ack		= irq_chip_ack_parent,
@@ -319,7 +319,7 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 }
 
 static struct irq_chip hpet_msi_controller = {
-	.name = "HPET_MSI",
+	.name = "HPET-MSI",
 	.irq_unmask = hpet_msi_unmask,
 	.irq_mask = hpet_msi_mask,
 	.irq_ack = irq_chip_ack_parent,
