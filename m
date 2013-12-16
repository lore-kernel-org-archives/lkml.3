Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab3LPTeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 14:34:18 -0500
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:10174 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755379Ab3LPTeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 14:34:17 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH v4 2/9] PCI/MSI/s390: Remove superfluous check of MSI type
Date: Mon, 16 Dec 2013 09:34:55 +0100
Message-Id: <f317583c5dda2b440ac2906b2cd04c97cae5ed1b.1387140921.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1387140921.git.agordeev@redhat.com>
References: <cover.1387140921.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_setup_msi_irqs() hook can only be called from the generic
MSI code which ensures correct MSI type parameter.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/pci/pci.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 6f3788e..4859c40 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -407,8 +407,6 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 	struct msi_msg msg;
 	int rc;
 
-	if (type != PCI_CAP_ID_MSIX && type != PCI_CAP_ID_MSI)
-		return -EINVAL;
 	if (type == PCI_CAP_ID_MSI && nvec > 1)
 		return 1;
 	msi_vecs = min(nvec, ZPCI_MSI_VEC_MAX);
-- 
1.7.7.6

