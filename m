Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3IIPWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:22:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab3IIPWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:22:11 -0400
Date: Mon, 9 Sep 2013 17:24:05 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: [PATCH 3/9] PCI/MSI/x86: Make return values only 0/-errno when MSIs
 allocated
Message-ID: <20130909152404.GD24962@dhcp-26-207.brq.redhat.com>
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
 arch/x86/kernel/apic/io_apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9ed796c..4a95d9a 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3140,7 +3140,7 @@ int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 
 	/* Multiple MSI vectors only supported with interrupt remapping */
 	if (type == PCI_CAP_ID_MSI && nvec > 1)
-		return 1;
+		return -EINVAL;
 
 	node = dev_to_node(&dev->dev);
 	irq_want = nr_irqs_gsi;
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
