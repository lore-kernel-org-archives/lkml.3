Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3IIPZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:25:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab3IIPZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:25:47 -0400
Date: Mon, 9 Sep 2013 17:27:39 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: [PATCH 6/9] PCI/MSI/s390: Remove superfluous check of MSI type
Message-ID: <20130909152738.GH24962@dhcp-26-207.brq.redhat.com>
References: <20130905150259.GA30984@dhcp-26-207.brq.redhat.com>
 <20130905150442.GA24148@htj.dyndns.org>
 <20130905154041.GD30984@dhcp-26-207.brq.redhat.com>
 <20130905154436.GC24148@htj.dyndns.org>
 <20130905185440.GA13175@dhcp-26-207.brq.redhat.com>
 <20130905200608.GA3846@htj.dyndns.org>
 <CAErSpo4TU2geqzY3AYsL08KimBqtfwa4iUoFHgcFt0zMTBJkHw@mail.gmail.com>
 <20130906160621.GF22763@mtj.dyndns.org>
 <20130906233205.GF12956@google.com>
 <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/s390/pci/pci.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index c79c6e4..61a3c2c 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -425,8 +425,6 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 	int rc;
 
 	pr_debug("%s: requesting %d MSI-X interrupts...", __func__, nvec);
-	if (type != PCI_CAP_ID_MSIX && type != PCI_CAP_ID_MSI)
-		return -EINVAL;
 	if (type == PCI_CAP_ID_MSI && nvec > 1)
 		return 1;
 	msi_vecs = min(nvec, ZPCI_MSI_VEC_MAX);
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
