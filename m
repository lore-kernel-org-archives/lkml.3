Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3IIPVC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:21:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab3IIPU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:20:59 -0400
Date: Mon, 9 Sep 2013 17:22:52 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: [PATCH 2/9] PCI/MSI/PPC: Make return values only 0/-errno when MSIs
 allocated
Message-ID: <20130909152252.GC24962@dhcp-26-207.brq.redhat.com>
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
 arch/powerpc/kernel/msi.c            |    2 +-
 arch/powerpc/platforms/pseries/msi.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/msi.c b/arch/powerpc/kernel/msi.c
index 8bbc12d..36d70b9 100644
--- a/arch/powerpc/kernel/msi.c
+++ b/arch/powerpc/kernel/msi.c
@@ -22,7 +22,7 @@ int arch_msi_check_device(struct pci_dev* dev, int nvec, int type)
 
 	/* PowerPC doesn't support multiple MSI yet */
 	if (type == PCI_CAP_ID_MSI && nvec > 1)
-		return 1;
+		return -EINVAL;
 
 	if (ppc_md.msi_check_device) {
 		pr_debug("msi: Using platform check routine.\n");
diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
index 009ec73..89648c1 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -348,7 +348,7 @@ static int rtas_msi_check_device(struct pci_dev *pdev, int nvec, int type)
 	quota = msi_quota_for_device(pdev, nvec);
 
 	if (quota && quota < nvec)
-		return quota;
+		return -ENOSPC;
 
 	return 0;
 }
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
