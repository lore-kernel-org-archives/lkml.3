Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaIYCyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 22:54:31 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:41649 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaIYCuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 22:50:55 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arch@vger.kernel.org>,
        <arnab.basu@freescale.com>, <Bharat.Bhushan@freescale.com>,
        <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>, Joerg Roedel <joro@8bytes.org>,
        <iommu@lists.linux-foundation.org>, <linux-mips@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        "Tony Luck" <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        David Vrabel <david.vrabel@citrix.com>,
        "Sergei Shtylyov" <sergei.shtylyov@cogentembedded.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Thomas Petazzoni" <thomas.petazzoni@free-electrons.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH v2 13/22] MIPS/Xlp: Remove the dead function destroy_irq() to fix build error
Date: Thu, 25 Sep 2014 11:14:23 +0800
Message-ID: <1411614872-4009-14-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1411614872-4009-1-git-send-email-wangyijing@huawei.com>
References: <1411614872-4009-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 465665f78a7 ("mips: Kill pointless destroy_irq()") removed
the destroy_irq(). So remove the leftover one in xlp_setup_msix()
to fix build error.

arch/mips/pci/msi-xlp.c: In function 'xlp_setup_msix':
arch/mips/pci/msi-xlp.c:447:3: error: implicit declaration of function 'destroy_irq'..
cc1: some warnings being treated as errors
make[1]: *** [arch/mips/pci/msi-xlp.o] Error 1
make: *** [arch/mips/pci/] Error 2

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mips/pci/msi-xlp.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/mips/pci/msi-xlp.c b/arch/mips/pci/msi-xlp.c
index fa374fe..e469dc7 100644
--- a/arch/mips/pci/msi-xlp.c
+++ b/arch/mips/pci/msi-xlp.c
@@ -443,10 +443,8 @@ static int xlp_setup_msix(uint64_t lnkbase, int node, int link,
 	msg.data = 0xc00 | msixvec;
 
 	ret = irq_set_msi_desc(xirq, desc);
-	if (ret < 0) {
-		destroy_irq(xirq);
+	if (ret < 0) 
 		return ret;
-	}
 
 	write_msi_msg(xirq, &msg);
 	return 0;
-- 
1.7.1

