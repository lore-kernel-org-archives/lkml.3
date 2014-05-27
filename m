Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaE0I31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:29:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45077 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaE0I3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:29:22 -0400
Date: Tue, 27 May 2014 01:27:29 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-a257954bb38ab23dbf93df812b4b2c01cae29d8b@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        grant.likely@linaro.org, yinghai@kernel.org, trivial@kernel.org,
        joro@8bytes.org, benh@kernel.crashing.org, bhelgaas@google.com,
        rjw@rjwysocki.net, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        grant.likely@linaro.org, yinghai@kernel.org, trivial@kernel.org,
        joro@8bytes.org, benh@kernel.crashing.org, bhelgaas@google.com,
        rjw@rjwysocki.net, paul.gortmaker@windriver.com
In-Reply-To: <1401178092-1228-3-git-send-email-jiang.liu@linux.intel.com>
References: <1401178092-1228-3-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq:
  Improve documentation to match current implementation
Git-Commit-ID: a257954bb38ab23dbf93df812b4b2c01cae29d8b
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

Commit-ID:  a257954bb38ab23dbf93df812b4b2c01cae29d8b
Gitweb:     http://git.kernel.org/tip/a257954bb38ab23dbf93df812b4b2c01cae29d8b
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 27 May 2014 16:07:37 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 27 May 2014 10:16:44 +0200

genirq: Improve documentation to match current implementation

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Jiri Kosina <trivial@kernel.org>
Link: http://lkml.kernel.org/r/1401178092-1228-3-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/IRQ-domain.txt | 3 +--
 kernel/irq/internals.h       | 2 +-
 kernel/irq/irqdomain.c       | 6 +++---
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/Documentation/IRQ-domain.txt b/Documentation/IRQ-domain.txt
index 03df71a..8a8b82c 100644
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
index c4065e3..099ea2e 100644
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
index f140337..eb5e10e 100644
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
