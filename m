Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab3LPTfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 14:35:55 -0500
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:10219 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754787Ab3LPTfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 14:35:54 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH v4 1/9] PCI/MSI/s390: Fix single MSI only check
Date: Mon, 16 Dec 2013 09:34:54 +0100
Message-Id: <2354bf8f2c79a29e688190af56729e56149fb63b.1387140921.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1387140921.git.agordeev@redhat.com>
References: <cover.1387140921.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple MSIs have never been supported on s390 architecture,
but the platform code fails to report single MSI only.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/pci/pci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index bf7c73d..6f3788e 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -409,6 +409,8 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 
 	if (type != PCI_CAP_ID_MSIX && type != PCI_CAP_ID_MSI)
 		return -EINVAL;
+	if (type == PCI_CAP_ID_MSI && nvec > 1)
+		return 1;
 	msi_vecs = min(nvec, ZPCI_MSI_VEC_MAX);
 	msi_vecs = min_t(unsigned int, msi_vecs, CONFIG_PCI_NR_MSI);
 
-- 
1.7.7.6

