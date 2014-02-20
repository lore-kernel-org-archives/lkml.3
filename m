Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbaBTRqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:46:44 -0500
Received: from mail1.windriver.com ([147.11.146.13]:39499 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbaBTRqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:46:42 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: David Howells <dhowells@redhat.com>
CC: <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH] frv: replace now removed pci_bus_b() causing build failure
Date: Thu, 20 Feb 2014 12:46:06 -0500
Message-ID: <1392918366-19079-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 94e6a9b93064b49024b8701d2d81fcb4a821fa09 ("PCI: Remove
pci_bus_b() and use list_for_each_entry() directly") the function
pci_bus_b() was removed, but one instance of its usage was missed.

Replace it in the same fashion that the original commit did.

Cc: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[Note: commit ID referenced above is from linux-next and will
 be invalid if the PCI-next content is ever rebased.]

 arch/frv/mb93090-mb00/pci-frv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/frv/mb93090-mb00/pci-frv.c b/arch/frv/mb93090-mb00/pci-frv.c
index c28121765448..67b1d1685759 100644
--- a/arch/frv/mb93090-mb00/pci-frv.c
+++ b/arch/frv/mb93090-mb00/pci-frv.c
@@ -88,7 +88,7 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
 
 	/* Depth-First Search on bus tree */
 	for (ln=bus_list->next; ln != bus_list; ln=ln->next) {
-		bus = pci_bus_b(ln);
+		bus = list_entry(ln, struct pci_bus, node);
 		if ((dev = bus->self)) {
 			for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_NUM_RESOURCES; idx++) {
 				r = &dev->resource[idx];
-- 
1.8.5.2

