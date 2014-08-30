Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaH3HMk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 03:12:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:53516 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbaH3HMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 03:12:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="379005388"
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
Subject: [Patch v4] x86, irq: Fix build error caused by 9eabc99a635a77cbf09
Date: Sat, 30 Aug 2014 15:15:16 +0800
Message-Id: <1409382916-10649-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409304383-18806-1-git-send-email-jiang.liu@linux.intel.com>
References: <1409304383-18806-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9eabc99a635a77cbf09 causes following build error when
IOAPIC is disabled.
   arch/x86/pci/irq.c: In function 'pirq_disable_irq':
>> arch/x86/pci/irq.c:1259:2: error: implicit declaration of function 'mp_should_keep_irq' [-Werror=implicit-function-declaration]
     if (io_apic_assign_pci_irqs && !mp_should_keep_irq(&dev->dev) &&
     ^
   cc1: some warnings being treated as errors

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
Hi Thomas and HPA,
	Really sorry about this. I only tested CONFIG_PM_RUNTIME,
but forgot CONFIG_X86_IO_APIC. Could you please help to merge or
fold this patch?
Regards!
Gerry
---
 arch/x86/include/asm/io_apic.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 478c490f3654..1733ab49ac5e 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -239,6 +239,7 @@ static inline int mp_find_ioapic(u32 gsi) { return 0; }
 static inline u32 mp_pin_to_gsi(int ioapic, int pin) { return UINT_MAX; }
 static inline int mp_map_gsi_to_irq(u32 gsi, unsigned int flags) { return gsi; }
 static inline void mp_unmap_irq(int irq) { }
+static inline bool mp_should_keep_irq(struct device *dev) { return 1; }
 
 static inline int save_ioapic_entries(void)
 {
-- 
1.7.10.4

