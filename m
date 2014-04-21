Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaDUEft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:35:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaDUEeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:34:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mohit Kumar <mohit.kumar@st.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3.13 05/32] PCI: designware: Fix RC BAR to be single 64-bit non-prefetchable memory BAR
Date: Sun, 20 Apr 2014 19:13:22 -0700
Message-Id: <20140421021134.603894801@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140421021133.865086647@linuxfoundation.org>
References: <20140421021133.865086647@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohit Kumar <mohit.kumar@st.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/host/pcie-designware.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -773,7 +773,7 @@ void dw_pcie_setup_rc(struct pcie_port *
 
 	/* setup RC BARs */
 	dw_pcie_writel_rc(pp, 0x00000004, PCI_BASE_ADDRESS_0);
-	dw_pcie_writel_rc(pp, 0x00000004, PCI_BASE_ADDRESS_1);
+	dw_pcie_writel_rc(pp, 0x00000000, PCI_BASE_ADDRESS_1);
 
 	/* setup interrupt pins */
 	dw_pcie_readl_rc(pp, PCI_INTERRUPT_LINE, &val);


