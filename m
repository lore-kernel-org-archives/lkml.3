Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaJAKYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 06:24:37 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33452 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750992AbaJAKYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 06:24:36 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: dougthompson@xmission.com, bp@alien8.de, m.chehab@samsung.com,
        akpm@linux-foundation.org
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] EDAC: remove deprecated IRQF_DISABLED
Date: Wed,  1 Oct 2014 12:24:03 +0200
Message-Id: <1412159043-7348-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <542BD4DC.40900@free-electrons.com>
References: <542BD4DC.40900@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/edac/mv64x60_edac.c | 8 ++++----
 drivers/edac/ppc4xx_edac.c  | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index 542fad70e360..6366e880f978 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -178,7 +178,7 @@ static int mv64x60_pci_err_probe(struct platform_device *pdev)
 		res = devm_request_irq(&pdev->dev,
 				       pdata->irq,
 				       mv64x60_pci_isr,
-				       IRQF_DISABLED,
+				       0,
 				       "[EDAC] PCI err",
 				       pci);
 		if (res < 0) {
@@ -345,7 +345,7 @@ static int mv64x60_sram_err_probe(struct platform_device *pdev)
 		res = devm_request_irq(&pdev->dev,
 				       pdata->irq,
 				       mv64x60_sram_isr,
-				       IRQF_DISABLED,
+				       0,
 				       "[EDAC] SRAM err",
 				       edac_dev);
 		if (res < 0) {
@@ -540,7 +540,7 @@ static int mv64x60_cpu_err_probe(struct platform_device *pdev)
 		res = devm_request_irq(&pdev->dev,
 				       pdata->irq,
 				       mv64x60_cpu_isr,
-				       IRQF_DISABLED,
+				       0,
 				       "[EDAC] CPU err",
 				       edac_dev);
 		if (res < 0) {
@@ -800,7 +800,7 @@ static int mv64x60_mc_err_probe(struct platform_device *pdev)
 		res = devm_request_irq(&pdev->dev,
 				       pdata->irq,
 				       mv64x60_mc_isr,
-				       IRQF_DISABLED,
+				       0,
 				       "[EDAC] MC err",
 				       mci);
 		if (res < 0) {
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index ef6b7e08f485..702394419f6a 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -1120,7 +1120,7 @@ static int ppc4xx_edac_register_irq(struct platform_device *op,
 
 	status = request_irq(ded_irq,
 			     ppc4xx_edac_isr,
-			     IRQF_DISABLED,
+			     0,
 			     "[EDAC] MC ECCDED",
 			     mci);
 
@@ -1134,7 +1134,7 @@ static int ppc4xx_edac_register_irq(struct platform_device *op,
 
 	status = request_irq(sec_irq,
 			     ppc4xx_edac_isr,
-			     IRQF_DISABLED,
+			     0,
 			     "[EDAC] MC ECCSEC",
 			     mci);
 
-- 
1.9.1

