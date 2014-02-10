Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaBJNAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:00:46 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:59757 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbaBJNAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:00:39 -0500
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: lenb@kernel.org, rjw@rjwysocki.net
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH 2/2] ACPI, PCI, ISA: Fix memory leak when there is no IRQ in the ACPI subsystem.
Date: Mon, 10 Feb 2014 14:00:11 +0100
Message-Id: <1392037211-29349-2-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392037211-29349-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1392037211-29349-1-git-send-email-tomasz.nowicki@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whenever we register ISA interrupt or not, we need to free the IRQ routing
table entry.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 drivers/acpi/pci_irq.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index b0e31b6..6ec0f36 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -432,6 +432,7 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 #endif
 		dev_warn(&dev->dev, "PCI INT %c: no GSI\n", pin_name(pin));
 
+		kfree(entry);
 		return 0;
 	}
 
-- 
1.7.9.5

