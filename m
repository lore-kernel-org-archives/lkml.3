Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaIHN5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:57:34 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53646 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753977AbaIHN4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:56:25 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v10 09/10] PCI: Assign unassigned bus resources in pci_scan_root_bus()
Date: Mon,  8 Sep 2014 14:54:31 +0100
Message-Id: <1410184472-17630-10-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com>
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the firmware has not assigned all the bus resources and
we are not just probing the PCIe busses, it makes sense to
assign the unassigned resources in pci_scan_root_bus().

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/pci/probe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index ef891d2..508cf61 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1953,6 +1953,9 @@ struct pci_bus *pci_scan_root_bus(struct device *parent, int bus,
 	if (!found)
 		pci_bus_update_busn_res_end(b, max);
 
+	if (!pci_has_flag(PCI_PROBE_ONLY))
+		pci_assign_unassigned_bus_resources(b);
+
 	pci_bus_add_devices(b);
 	return b;
 }
-- 
2.0.4

