Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631AbaEEMr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:47:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41049 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932325AbaEEMnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:35 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mohit Kumar <mohit.kumar@st.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 28/50] PCI: designware: Fix RC BAR to be single 64-bit non-prefetchable memory BAR
Date: Mon,  5 May 2014 14:43:10 +0200
Message-Id: <47495e3596d95047168e4a831b2a8ccdf7efafaa.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohit Kumar <mohit.kumar@st.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit dbffdd6862e67d60703f2df66c558bf448f81d6e upstream.

The Synopsys PCIe core provides one pair of 32-bit BARs (BAR 0 and BAR 1).
The BARs can be configured as follows:

  - One 64-bit BAR: BARs 0 and 1 are combined to form a single 64-bit BAR
  - Two 32-bit BARs: BARs 0 and 1 are two independent 32-bit BARs

This patch corrects 64-bit, non-prefetchable memory BAR configuration
implemented in dw driver.

Signed-off-by: Mohit Kumar <mohit.kumar@st.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Pratyush Anand <pratyush.anand@st.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/pci/host/pcie-designware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index c10e9ac9bbbc..09eba9f338fe 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -532,7 +532,7 @@ void dw_pcie_setup_rc(struct pcie_port *pp)
 
 	/* setup RC BARs */
 	dw_pcie_writel_rc(pp, 0x00000004, PCI_BASE_ADDRESS_0);
-	dw_pcie_writel_rc(pp, 0x00000004, PCI_BASE_ADDRESS_1);
+	dw_pcie_writel_rc(pp, 0x00000000, PCI_BASE_ADDRESS_1);
 
 	/* setup interrupt pins */
 	dw_pcie_readl_rc(pp, PCI_INTERRUPT_LINE, &val);
-- 
1.9.2

