Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab3BCO4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:56:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34273 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462Ab3BCO4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:03 -0500
Message-Id: <20130203144648.419979525@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:33 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Betty Dall <betty.dall@hp.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Shuah Khan <shuah.khan@hp.com>
Subject: [ 049/128] PCI/AER: pci_get_domain_bus_and_slot() call missing required
 pci_dev_put()
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Betty Dall <betty.dall@hp.com>

commit a82b6af37d20bfe6e99a4d890f1cf1d89059929f upstream.

The function aer_recover_queue() calls pci_get_domain_bus_and_slot(), which
requires that the caller decrement the reference count with pci_dev_put().
This patch adds the missing call to pci_dev_put().

Signed-off-by: Betty Dall <betty.dall@hp.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/pcie/aer/aerdrv_core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 421bbc5..564d97f 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -630,6 +630,7 @@ static void aer_recover_work_func(struct work_struct *work)
 			continue;
 		}
 		do_recovery(pdev, entry.severity);
+		pci_dev_put(pdev);
 	}
 }
 #endif


