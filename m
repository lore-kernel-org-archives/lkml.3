Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbaE2QDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:03:53 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47231 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336AbaE2QDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:03:50 -0400
From: Kumar Gala <galak@codeaurora.org>
To: Rob Herring <robh+dt@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Liviu Dudau <liviu@dudau.co.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH] of: treat PCI config space as IORESOURCE_MEM type
Date: Thu, 29 May 2014 11:03:46 -0500
Message-Id: <1401379426-9701-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have a PCI config space specified in something like a ranges
property we should treat it as memory type resource.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 drivers/of/address.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index cb4242a..4e7ee59 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -122,6 +122,9 @@ static unsigned int of_bus_pci_get_flags(const __be32 *addr)
 	u32 w = be32_to_cpup(addr);
 
 	switch((w >> 24) & 0x03) {
+	case 0x00: /* cfg space */
+		flags |= IORESOURCE_MEM;
+		break;
 	case 0x01:
 		flags |= IORESOURCE_IO;
 		break;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

