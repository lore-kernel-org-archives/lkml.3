Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaDYJVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:21:45 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:46863 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaDYJVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:21:38 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 05/13] IA64/PCI: Use new pci_is_bridge() to simplify code
Date: Fri, 25 Apr 2014 17:18:27 +0800
Message-ID: <1398417515-8740-6-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1398417515-8740-1-git-send-email-wangyijing@huawei.com>
References: <1398417515-8740-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we can use new pci_is_bridge() helper function
to simplify code.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/ia64/pci/fixup.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/pci/fixup.c b/arch/ia64/pci/fixup.c
index eee069a..1fe9aa5 100644
--- a/arch/ia64/pci/fixup.c
+++ b/arch/ia64/pci/fixup.c
@@ -49,9 +49,7 @@ static void pci_fixup_video(struct pci_dev *pdev)
 		 * type BRIDGE, or CARDBUS. Host to PCI controllers use
 		 * PCI header type NORMAL.
 		 */
-		if (bridge
-		    &&((bridge->hdr_type == PCI_HEADER_TYPE_BRIDGE)
-		       ||(bridge->hdr_type == PCI_HEADER_TYPE_CARDBUS))) {
+		if (bridge && (pci_is_bridge(bridge))) {
 			pci_read_config_word(bridge, PCI_BRIDGE_CONTROL,
 						&config);
 			if (!(config & PCI_BRIDGE_CTL_VGA))
-- 
1.7.1


