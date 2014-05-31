Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935044AbaEaAjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 20:39:00 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54636 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935005AbaEaAi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 20:38:58 -0400
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
Subject: [PATCH 1/2] pci: Add IORESOURCE_BIT entry for PCIe ECAM resources.
Date: Sat, 31 May 2014 01:36:40 +0100
Message-Id: <1401496601-31983-2-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1401496601-31983-1-git-send-email-Liviu.Dudau@arm.com>
References: <20140530233034.GH1677@bart.dudau.co.uk>
 <1401496601-31983-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We would like to be able to describe PCIe ECAM resources as
IORESOURCE_MEM blocks while distinguish them from standard
memory resources. Add an IORESOURCE_BIT entry for this case.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 include/linux/ioport.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 5e3a906..9672533 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -103,6 +103,7 @@ struct resource {
 
 /* PCI control bits.  Shares IORESOURCE_BITS with above PCI ROM.  */
 #define IORESOURCE_PCI_FIXED		(1<<4)	/* Do not move resource */
+#define IORESOURCE_PCI_ECFG		(1<<5)  /* ECAM config resource */
 
 
 /* helpers to define resources */
-- 
1.9.2

