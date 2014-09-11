Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbaIKIWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:22:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:19347 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbaIKIWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:22:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="571628855"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC Part1 v1 01/18] x86, irq, ACPI: Fix building warning of unused code
Date: Thu, 11 Sep 2014 16:24:48 +0800
Message-Id: <1410423905-26239-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix building warning when CONFIG_X86_LOCAL_APIC is disabled.
arch/x86/kernel/acpi/boot.c:699:20: warning: ‘acpi_set_irq_model_ioapic’ defined but not used [-Wunused-function]

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 132f98a2288b..7f00bbf7956b 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -706,6 +706,7 @@ void acpi_unregister_gsi(u32 gsi)
 }
 EXPORT_SYMBOL_GPL(acpi_unregister_gsi);
 
+#ifdef CONFIG_X86_LOCAL_APIC
 static void __init acpi_set_irq_model_ioapic(void)
 {
 	acpi_irq_model = ACPI_IRQ_MODEL_IOAPIC;
@@ -713,6 +714,7 @@ static void __init acpi_set_irq_model_ioapic(void)
 	__acpi_unregister_gsi = acpi_unregister_gsi_ioapic;
 	acpi_ioapic = 1;
 }
+#endif
 
 /*
  *  ACPI based hotplug support for CPU
-- 
1.7.10.4

