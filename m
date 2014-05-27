Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaE0IGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:06:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:15206 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbaE0IG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:06:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,917,1392192000"; 
   d="scan'208";a="538015979"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiri Kosina <trivial@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [Patch V3 02/37] genirq, trivial: improve documentation to match current implementation
Date: Tue, 27 May 2014 16:07:37 +0800
Message-Id: <1401178092-1228-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com>
References: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 Documentation/IRQ-domain.txt |    3 +--
 kernel/irq/internals.h       |    2 +-
 kernel/irq/irqdomain.c       |    6 +++---
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/Documentation/IRQ-domain.txt b/Documentation/IRQ-domain.txt
index 03df71aeb38c..8a8b82c9ca53 100644
--- a/Documentation/IRQ-domain.txt
+++ b/Documentation/IRQ-domain.txt
@@ -41,8 +41,7 @@ An interrupt controller driver creates and registers an irq_domain by
 calling one of the irq_domain_add_*() functions (each mapping method
 has a different allocator function, more on that later).  The function
 will return a pointer to the irq_domain on success.  The caller must
-provide the allocator function with an irq_domain_ops structure with
-the .map callback populated as a minimum.
+provide the allocator function with an irq_domain_ops structure.
 
 In most cases, the irq_domain will begin empty without any mappings
 between hwirq and IRQ numbers.  Mappings are added to the irq_domain
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index c4065e3edbc3..099ea2e0eb88 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -33,7 +33,7 @@ enum {
 };
 
 /*
- * Bit masks for desc->state
+ * Bit masks for desc->core_internal_state__do_not_mess_with_it
  *
  * IRQS_AUTODETECT		- autodetection in progress
  * IRQS_SPURIOUS_DISABLED	- was disabled due to spurious interrupt
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index f14033700c25..eb5e10e32e05 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -27,14 +27,14 @@ static struct irq_domain *irq_default_domain;
  * __irq_domain_add() - Allocate a new irq_domain data structure
  * @of_node: optional device-tree node of the interrupt controller
  * @size: Size of linear map; 0 for radix mapping only
+ * @hwirq_max: Maximum number of interrupts supported by controller
  * @direct_max: Maximum value of direct maps; Use ~0 for no limit; 0 for no
  *              direct mapping
  * @ops: map/unmap domain callbacks
  * @host_data: Controller private data pointer
  *
- * Allocates and initialize and irq_domain structure.  Caller is expected to
- * register allocated irq_domain with irq_domain_register().  Returns pointer
- * to IRQ domain, or NULL on failure.
+ * Allocates and initialize and irq_domain structure.
+ * Returns pointer to IRQ domain, or NULL on failure.
  */
 struct irq_domain *__irq_domain_add(struct device_node *of_node, int size,
 				    irq_hw_number_t hwirq_max, int direct_max,
-- 
1.7.10.4

