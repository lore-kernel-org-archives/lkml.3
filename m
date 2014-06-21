Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbaFUVH5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:07:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35423 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbaFUVHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:07:55 -0400
Date: Sat, 21 Jun 2014 14:06:33 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-43a775916d63d1c822107b39987192ca5ced445c@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
In-Reply-To: <1402302011-23642-37-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-37-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Export irq_domain_disassociate()
  to architecture interrupt drivers
Git-Commit-ID: 43a775916d63d1c822107b39987192ca5ced445c
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

Commit-ID:  43a775916d63d1c822107b39987192ca5ced445c
Gitweb:     http://git.kernel.org/tip/43a775916d63d1c822107b39987192ca5ced445c
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:20:05 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:03:36 +0200

genirq: Export irq_domain_disassociate() to architecture interrupt drivers

Export irq_domain_disassociate() to architecture interrupt drivers,
so it could be used to handle legacy IRQ descriptors on x86.

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
Link: http://lkml.kernel.org/r/1402302011-23642-37-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irqdomain.h | 2 ++
 kernel/irq/irqdomain.c    | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index c983ed1..b0f9d16 100644
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
index eb5e10e..6534ff6 100644
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
