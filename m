Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaFEEXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:23:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbaFEEWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Bulkow <david.bulkow@stratus.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 213/214] PCI/ASPM: Dont touch ASPM if forcibly disabled
Date: Wed,  4 Jun 2014 21:19:36 -0700
Message-Id: <20140605041708.123663523@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Lawrence <joe.lawrence@stratus.com>

commit a26d5ecb3201c11e03663a8f4a7dedc0c5f85c07 upstream.

Don't allocate and track PCIe ASPM state when "pcie_aspm=off" is specified
on the kernel command line.

Based-on-patch-from: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: David Bulkow <david.bulkow@stratus.com>
Acked-by: Myron Stowe <myron.stowe@redhat.com>
[wyj: Backported to 3.4: context adjust]
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pcie/aspm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -583,6 +583,9 @@ void pcie_aspm_init_link_state(struct pc
 	struct pcie_link_state *link;
 	int blacklist = !!pcie_aspm_sanity_check(pdev);
 
+	if (!aspm_support_enabled)
+		return;
+
 	if (!pci_is_pcie(pdev) || pdev->link_state)
 		return;
 	if (pdev->pcie_type != PCI_EXP_TYPE_ROOT_PORT &&


