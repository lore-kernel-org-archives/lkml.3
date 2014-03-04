Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435AbaCDUSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:18:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292AbaCDUFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.10 62/97] ACPI / PCI: Fix memory leak in acpi_pci_irq_enable()
Date: Tue,  4 Mar 2014 12:04:15 -0800
Message-Id: <20140304200348.069731318@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Nowicki <tomasz.nowicki@linaro.org>

commit b685f3b1744061aa9ad822548ba9c674de5be7c6 upstream.

acpi_pci_link_allocate_irq() can return negative gsi even if
entry != NULL.  For that case we have a memory leak, so free
entry before returning from acpi_pci_irq_enable() for gsi < 0.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
[rjw: Subject and changelog]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/pci_irq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -432,6 +432,7 @@ int acpi_pci_irq_enable(struct pci_dev *
 				 pin_name(pin));
 		}
 
+		kfree(entry);
 		return 0;
 	}
 


