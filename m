Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaEVXHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:07:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbaEVXHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:07:41 -0400
Subject: [PATCH v4 02/16] PCI: define pci_dev_flags as bit shifts
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, acooks@gmail.com, linux-kernel@vger.kernel.org,
        eddy0596@gmail.com, linux@horizon.com
Date: Thu, 22 May 2014 17:07:36 -0600
Message-ID: <20140522230736.2856.30635.stgit@bling.home>
In-Reply-To: <20140522230230.2856.40017.stgit@bling.home>
References: <20140522230230.2856.40017.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're only a few entries away from where using the decimal value
becomes cumbersome.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 include/linux/pci.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 14b074b..545903d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -164,13 +164,13 @@ enum pci_dev_flags {
 	/* INTX_DISABLE in PCI_COMMAND register disables MSI
 	 * generation too.
 	 */
-	PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG = (__force pci_dev_flags_t) 1,
+	PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG = (__force pci_dev_flags_t) (1 << 0),
 	/* Device configuration is irrevocably lost if disabled into D3 */
-	PCI_DEV_FLAGS_NO_D3 = (__force pci_dev_flags_t) 2,
+	PCI_DEV_FLAGS_NO_D3 = (__force pci_dev_flags_t) (1 << 1),
 	/* Provide indication device is assigned by a Virtual Machine Manager */
-	PCI_DEV_FLAGS_ASSIGNED = (__force pci_dev_flags_t) 4,
+	PCI_DEV_FLAGS_ASSIGNED = (__force pci_dev_flags_t) (1 << 2),
 	/* Flag for quirk use to store if quirk-specific ACS is enabled */
-	PCI_DEV_FLAGS_ACS_ENABLED_QUIRK = (__force pci_dev_flags_t) 8,
+	PCI_DEV_FLAGS_ACS_ENABLED_QUIRK = (__force pci_dev_flags_t) (1 << 3),
 };
 
 enum pci_irq_reroute_variant {

