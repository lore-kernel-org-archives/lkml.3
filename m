Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbaCEPSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:18:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40925 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967AbaCEOZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 047/131] ACPI / PCI: Fix memory leak in acpi_pci_irq_enable()
Date: Wed,  5 Mar 2014 14:22:51 +0000
Message-Id: <1394029455-23128-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Nowicki <tomasz.nowicki@linaro.org>

commit b685f3b1744061aa9ad822548ba9c674de5be7c6 upstream.

acpi_pci_link_allocate_irq() can return negative gsi even if
entry != NULL.  For that case we have a memory leak, so free
entry before returning from acpi_pci_irq_enable() for gsi < 0.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
[rjw: Subject and changelog]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/pci_irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 41c5e1b..f658e09 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -432,6 +432,7 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 				 pin_name(pin));
 		}
 
+		kfree(entry);
 		return 0;
 	}
 
-- 
1.9.0

