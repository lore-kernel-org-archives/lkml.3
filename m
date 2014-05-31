Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935000AbaEaAip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 20:38:45 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54602 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934624AbaEaAio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 20:38:44 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Kumar Gala <galak@codeaurora.org>, Rob Herring <robherring2@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 2/2] of: treat PCI config space as IORESOURCE_MEM type with special flags.
Date: Sat, 31 May 2014 01:36:41 +0100
Message-Id: <1401496601-31983-3-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1401496601-31983-1-git-send-email-Liviu.Dudau@arm.com>
References: <20140530233034.GH1677@bart.dudau.co.uk>
 <1401496601-31983-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have a PCI config space specified in something like a ranges
property we should treat it as memory type resource. Use the
IORESOURCE_ECFG bit to distinguish the config space from standard
IORESOURCE_MEM resources.

Signed-off-by: Kumar Gama <galak@codeaurora.org>
[Updated commit log and added IORESOURCE_ECFG bit]
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/of/address.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 2fcfbae..877e9e5 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -123,6 +123,9 @@ static unsigned int of_bus_pci_get_flags(const __be32 *addr)
 	u32 w = be32_to_cpup(addr);
 
 	switch((w >> 24) & 0x03) {
+	case 0x00: /* cfg space */
+		flags |= IORESOURCE_MEM | IORESOURCE_PCI_ECFG;
+		break;
 	case 0x01:
 		flags |= IORESOURCE_IO;
 		break;
-- 
1.9.2

