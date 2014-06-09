Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbaFIIXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:23:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:34398 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932725AbaFIIXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:23:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352321877"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch V4 36/42] genirq: export irq_domain_disassociate() to architecture interrupt drivers
Date: Mon,  9 Jun 2014 16:20:05 +0800
Message-Id: <1402302011-23642-37-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export irq_domain_disassociate() to architecture interrupt drivers,
so it could be used to handle legacy IRQ descriptors on x86.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 include/linux/irqdomain.h |    2 ++
 kernel/irq/irqdomain.c    |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index c983ed18c332..b0f9d16e48f6 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -172,6 +172,8 @@ extern int irq_domain_associate(struct irq_domain *domain, unsigned int irq,
 extern void irq_domain_associate_many(struct irq_domain *domain,
 				      unsigned int irq_base,
 				      irq_hw_number_t hwirq_base, int count);
+extern void irq_domain_disassociate(struct irq_domain *domain,
+				    unsigned int irq);
 
 extern unsigned int irq_create_mapping(struct irq_domain *host,
 				       irq_hw_number_t hwirq);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index eb5e10e32e05..6534ff6ce02e 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -231,7 +231,7 @@ void irq_set_default_host(struct irq_domain *domain)
 }
 EXPORT_SYMBOL_GPL(irq_set_default_host);
 
-static void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
+void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 {
 	struct irq_data *irq_data = irq_get_irq_data(irq);
 	irq_hw_number_t hwirq;
-- 
1.7.10.4

