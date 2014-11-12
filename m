Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaKLQvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:51:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:62251 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbaKLQvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:51:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="486904434"
Message-ID: <54638FDE.8090507@linux.intel.com>
Date: Thu, 13 Nov 2014 00:50:38 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 15/16] PCI/MSI: Rename write_msi_msg() to pci_write_msi_msg()
References: <20141112133941.647950773@linutronix.de> <20141112134121.115015986@linutronix.de>
In-Reply-To: <20141112134121.115015986@linutronix.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
	Could you please help to fold this into patch 15?
Regards!
Gerry
PCI, MSI: Replace write_msi_msg() with pci_write_msi_msg()

Commit e5f1a59c4e12 "PCI/MSI: Rename write_msi_msg() to pci_write_msi_msg()"
missed one instance of write_msi_msg() in file arch/mips/pci/msi-xlp.c.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/mips/pci/msi-xlp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/pci/msi-xlp.c b/arch/mips/pci/msi-xlp.c
index 262001ee1554..75bceb99e9a6 100644
--- a/arch/mips/pci/msi-xlp.c
+++ b/arch/mips/pci/msi-xlp.c
@@ -446,7 +446,7 @@ static int xlp_setup_msix(uint64_t lnkbase, int
node, int link,
        if (ret < 0)
                return ret;

-       write_msi_msg(xirq, &msg);
+       pci_write_msi_msg(xirq, &msg);
        return 0;
 }

--


On 2014/11/12 21:43, Thomas Gleixner wrote:
