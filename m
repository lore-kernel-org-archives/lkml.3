Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbaKEROd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:14:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41752 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbaKEROa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:14:30 -0500
Date: Wed, 5 Nov 2014 09:13:03 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-a4aad01aa04e405dc41b6c8e75bed3a9b63327d7@git.kernel.org>
Cc: bp@alien8.de, benh@kernel.crashing.org, pavel@ucw.cz,
        gregkh@linuxfoundation.org, bhelgaas@google.com, tony.luck@intel.com,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, jiang.liu@linux.intel.com,
        rjw@rjwysocki.net, hpa@zytor.com, len.brown@intel.com, joro@8bytes.org,
        rdunlap@infradead.org
Reply-To: jiang.liu@linux.intel.com, rjw@rjwysocki.net, rdunlap@infradead.org,
        len.brown@intel.com, joro@8bytes.org, hpa@zytor.com, bp@alien8.de,
        pavel@ucw.cz, benh@kernel.crashing.org, gregkh@linuxfoundation.org,
        tony.luck@intel.com, bhelgaas@google.com, mingo@kernel.org,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, yinghai@kernel.org
In-Reply-To: <1414397531-28254-3-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-3-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq, ACPI:
  Fix building warning of unused code
Git-Commit-ID: a4aad01aa04e405dc41b6c8e75bed3a9b63327d7
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

Commit-ID:  a4aad01aa04e405dc41b6c8e75bed3a9b63327d7
Gitweb:     http://git.kernel.org/tip/a4aad01aa04e405dc41b6c8e75bed3a9b63327d7
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:11:53 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 5 Nov 2014 18:10:45 +0100

x86, irq, ACPI: Fix building warning of unused code

Fix building warning when CONFIG_X86_LOCAL_APIC is disabled.
arch/x86/kernel/acpi/boot.c:699:20: warning: ‘acpi_set_irq_model_ioapic’ defined but not used [-Wunused-function]

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
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Link: http://lkml.kernel.org/r/1414397531-28254-3-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/acpi/boot.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index a0e095f..4433a4b 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -703,6 +703,7 @@ void acpi_unregister_gsi(u32 gsi)
 }
 EXPORT_SYMBOL_GPL(acpi_unregister_gsi);
 
+#ifdef CONFIG_X86_LOCAL_APIC
 static void __init acpi_set_irq_model_ioapic(void)
 {
 	acpi_irq_model = ACPI_IRQ_MODEL_IOAPIC;
@@ -710,6 +711,7 @@ static void __init acpi_set_irq_model_ioapic(void)
 	__acpi_unregister_gsi = acpi_unregister_gsi_ioapic;
 	acpi_ioapic = 1;
 }
+#endif
 
 /*
  *  ACPI based hotplug support for CPU
