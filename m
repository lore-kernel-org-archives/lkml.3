Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbaKZXUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:20:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59060 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbaKZXUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:20:14 -0500
Date: Wed, 26 Nov 2014 15:19:22 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-6de39aa81a72cb41c25497fe8ccfb05873ab862a@git.kernel.org>
Cc: rjw@rjwysocki.net, gregkh@linuxfoundation.org, hpa@zytor.com,
        grant.likely@linaro.org, bp@alien8.de, yinghai@kernel.org,
        jiang.liu@linux.intel.com, tglx@linutronix.de, jroedel@suse.de,
        mingo@kernel.org, rdunlap@infradead.org, benh@kernel.crashing.org,
        konrad.wilk@oracle.com, tony.luck@intel.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com
Reply-To: bhelgaas@google.com, linux-kernel@vger.kernel.org, joro@8bytes.org,
        tony.luck@intel.com, konrad.wilk@oracle.com, rdunlap@infradead.org,
        benh@kernel.crashing.org, tglx@linutronix.de, jroedel@suse.de,
        mingo@kernel.org, jiang.liu@linux.intel.com, yinghai@kernel.org,
        bp@alien8.de, grant.likely@linaro.org, hpa@zytor.com,
        gregkh@linuxfoundation.org, rjw@rjwysocki.net
In-Reply-To: <1416901802-24211-27-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-27-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Kill struct io_apic_irq_attr
Git-Commit-ID: 6de39aa81a72cb41c25497fe8ccfb05873ab862a
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

Commit-ID:  6de39aa81a72cb41c25497fe8ccfb05873ab862a
Gitweb:     http://git.kernel.org/tip/6de39aa81a72cb41c25497fe8ccfb05873ab862a
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:50 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:48 +0100

x86, irq: Kill struct io_apic_irq_attr

Now there's no user of struct io_apic_irq_attr anymore, so kill it.

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
Cc: Grant Likely <grant.likely@linaro.org>
Link: http://lkml.kernel.org/r/1416901802-24211-27-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/io_apic.h |  7 -------
 arch/x86/kernel/apic/io_apic.c | 10 ----------
 2 files changed, 17 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 3b54f0f..1597c77 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -157,13 +157,6 @@ extern int restore_ioapic_entries(void);
 extern void setup_ioapic_ids_from_mpc(void);
 extern void setup_ioapic_ids_from_mpc_nocheck(void);
 
-struct io_apic_irq_attr {
-	int ioapic;
-	int ioapic_pin;
-	int trigger;
-	int polarity;
-};
-
 enum ioapic_domain_type {
 	IOAPIC_DOMAIN_INVALID,
 	IOAPIC_DOMAIN_LEGACY,
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 69aa3b0..f0ef583 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2949,16 +2949,6 @@ int mp_ioapic_registered(u32 gsi_base)
 	return 0;
 }
 
-static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
-					int ioapic, int ioapic_pin,
-					int trigger, int polarity)
-{
-	irq_attr->ioapic	= ioapic;
-	irq_attr->ioapic_pin	= ioapic_pin;
-	irq_attr->trigger	= trigger;
-	irq_attr->polarity	= polarity;
-}
-
 static void mp_irqdomain_get_attr(u32 gsi, struct mp_chip_data *data,
 				  struct irq_alloc_info *info)
 {
