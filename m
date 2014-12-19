Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaLSOCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:02:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45729 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaLSOCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:02:11 -0500
Date: Fri, 19 Dec 2014 06:01:10 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-9f50c6ea0d02a58abd498250abd11bde687bbe22@git.kernel.org>
Cc: jiang.liu@linux.intel.com, pavel@ucw.cz, hpa@zytor.com,
        konrad.wilk@oracle.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, joro@8bytes.org, yinghai@kernel.org,
        tglx@linutronix.de, bp@alien8.de, rjw@rjwysocki.net,
        gregkh@linuxfoundation.org, tony.luck@intel.com,
        benh@kernel.crashing.org, rdunlap@infradead.org, bhelgaas@google.com
Reply-To: mingo@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        konrad.wilk@oracle.com, pavel@ucw.cz, jiang.liu@linux.intel.com,
        bhelgaas@google.com, rdunlap@infradead.org, benh@kernel.crashing.org,
        tony.luck@intel.com, bp@alien8.de, tglx@linutronix.de,
        gregkh@linuxfoundation.org, rjw@rjwysocki.net, joro@8bytes.org,
        yinghai@kernel.org, len.brown@intel.com
In-Reply-To: <1414397531-28254-3-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-3-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq, ACPI:
  Fix building warning of unused code
Git-Commit-ID: 9f50c6ea0d02a58abd498250abd11bde687bbe22
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

Commit-ID:  9f50c6ea0d02a58abd498250abd11bde687bbe22
Gitweb:     http://git.kernel.org/tip/9f50c6ea0d02a58abd498250abd11bde687bbe22
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:11:53 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 16 Dec 2014 14:08:14 +0100

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
index a142e77..6ddeba31 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -690,6 +690,7 @@ void acpi_unregister_gsi(u32 gsi)
 }
 EXPORT_SYMBOL_GPL(acpi_unregister_gsi);
 
+#ifdef CONFIG_X86_LOCAL_APIC
 static void __init acpi_set_irq_model_ioapic(void)
 {
 	acpi_irq_model = ACPI_IRQ_MODEL_IOAPIC;
@@ -697,6 +698,7 @@ static void __init acpi_set_irq_model_ioapic(void)
 	__acpi_unregister_gsi = acpi_unregister_gsi_ioapic;
 	acpi_ioapic = 1;
 }
+#endif
 
 /*
  *  ACPI based hotplug support for CPU
