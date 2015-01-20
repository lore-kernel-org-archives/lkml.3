Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbbATKuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:50:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55994 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbbATKuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:50:12 -0500
Date: Tue, 20 Jan 2015 02:49:44 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-9889eaeb7c999cae64006bb98c47f40f412ec875@git.kernel.org>
Cc: david.vrabel@citrix.com, hpa@zytor.com, linux@eikelenboom.it,
        tony.luck@intel.com, jiang.liu@linux.intel.com, mingo@kernel.org,
        tglx@linutronix.de, lenb@kernel.org, konrad.wilk@oracle.com,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Reply-To: linux@eikelenboom.it, tony.luck@intel.com, jiang.liu@linux.intel.com,
        mingo@kernel.org, tglx@linutronix.de, lenb@kernel.org,
        konrad.wilk@oracle.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com, hpa@zytor.com
In-Reply-To: <1421720467-7709-3-git-send-email-jiang.liu@linux.intel.com>
References: <1421720467-7709-3-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] ACPI: pci: Do not clear pci_dev->
 irq in acpi_pci_irq_disable()
Git-Commit-ID: 9889eaeb7c999cae64006bb98c47f40f412ec875
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

Commit-ID:  9889eaeb7c999cae64006bb98c47f40f412ec875
Gitweb:     http://git.kernel.org/tip/9889eaeb7c999cae64006bb98c47f40f412ec875
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 20 Jan 2015 10:21:06 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 20 Jan 2015 11:44:40 +0100

ACPI: pci: Do not clear pci_dev->irq in acpi_pci_irq_disable()

Xen pciback driver assumes that pci_dev->irq won't change after calling
pci_disable_device(). But commit cffe0a2b5a34c95a4dadc9ec7132690a5b0f6687
("x86, irq: Keep balance of IOAPIC pin reference count") frees irq
resources and resets pci_dev->irq to zero when pci_disable_device() is
called.

So this is a hotfix for 3.19 to avoid resetting pci_dev->irq, and
another proper fix will be prepared for next merging window.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Tested-by: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Link: http://lkml.kernel.org/r/1421720467-7709-3-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/acpi/pci_irq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 5277a0e..b1def41 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -512,7 +512,6 @@ void acpi_pci_irq_disable(struct pci_dev *dev)
 	dev_dbg(&dev->dev, "PCI INT %c disabled\n", pin_name(pin));
 	if (gsi >= 0) {
 		acpi_unregister_gsi(gsi);
-		dev->irq = 0;
 		dev->irq_managed = 0;
 	}
 }
