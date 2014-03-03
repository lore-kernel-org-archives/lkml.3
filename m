Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaCCRiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 12:38:06 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53666 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753149AbaCCReA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 12:34:00 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: [PATCH v4 5/6] pci: Use parent domain number when allocating child busses.
Date: Mon,  3 Mar 2014 17:33:15 +0000
Message-Id: <1393867996-32299-6-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393867996-32299-1-git-send-email-Liviu.Dudau@arm.com>
References: <1393867996-32299-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_alloc_child_bus() uses the newly allocated child bus to figure
out the domain number that is going to use for setting the device
name. A better option is to use the parent bus domain number.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 26237a0..a12cda5 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -677,7 +677,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 	 * now as the parent is not properly set up yet.
 	 */
 	child->dev.class = &pcibus_class;
-	dev_set_name(&child->dev, "%04x:%02x", pci_domain_nr(child), busnr);
+	dev_set_name(&child->dev, "%04x:%02x", pci_domain_nr(parent), busnr);
 
 	/*
 	 * Set up the primary, secondary and subordinate
-- 
1.9.0

