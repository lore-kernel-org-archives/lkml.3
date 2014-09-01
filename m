Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaIAITV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:19:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47415 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaIAITT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:19:19 -0400
Date: Mon, 1 Sep 2014 01:15:38 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-f3761db1646d3ccb9ada2df8e27553a73ef43826@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        bp@alien8.de, benh@kernel.crashing.org, bhelgaas@google.com,
        rjw@rjwysocki.net
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        bp@alien8.de, benh@kernel.crashing.org, bhelgaas@google.com,
        rjw@rjwysocki.net
In-Reply-To: <1409382916-10649-1-git-send-email-jiang.liu@linux.intel.com>
References: <1409382916-10649-1-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, irq:
  Fix build error caused by 9eabc99a635a77cbf09
Git-Commit-ID: f3761db1646d3ccb9ada2df8e27553a73ef43826
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

Commit-ID:  f3761db1646d3ccb9ada2df8e27553a73ef43826
Gitweb:     http://git.kernel.org/tip/f3761db1646d3ccb9ada2df8e27553a73ef43826
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Sat, 30 Aug 2014 15:15:16 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 1 Sep 2014 10:12:03 +0200

x86, irq: Fix build error caused by 9eabc99a635a77cbf09

Commit 9eabc99a635a77cbf09 causes following build error when
IOAPIC is disabled.
   arch/x86/pci/irq.c: In function 'pirq_disable_irq':
>> arch/x86/pci/irq.c:1259:2: error: implicit declaration of function 'mp_should_keep_irq' [-Werror=implicit-function-declaration]
     if (io_apic_assign_pci_irqs && !mp_should_keep_irq(&dev->dev) &&
     ^
   cc1: some warnings being treated as errors

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
Cc: Grant Likely <grant.likely@linaro.org>
Link: http://lkml.kernel.org/r/1409382916-10649-1-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 478c490..1733ab4 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -239,6 +239,7 @@ static inline int mp_find_ioapic(u32 gsi) { return 0; }
 static inline u32 mp_pin_to_gsi(int ioapic, int pin) { return UINT_MAX; }
 static inline int mp_map_gsi_to_irq(u32 gsi, unsigned int flags) { return gsi; }
 static inline void mp_unmap_irq(int irq) { }
+static inline bool mp_should_keep_irq(struct device *dev) { return 1; }
 
 static inline int save_ioapic_entries(void)
 {
