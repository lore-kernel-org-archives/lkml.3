Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbaJFPgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:36:49 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:18814 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082AbaJFPgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:36:46 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvENAEC2MlRXQzrG/2dsb2JhbABfgw6BK7gQAQUBc5pnAoEDFwF7hAQBBScvIxBROR4ZiEIBsluONxiGIIolBxaENQWdPoxSiS6DZTsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-edac@vger.kernel.org
Subject: [PATCH 1/7 linux-next] mv64x60_edac: remove deprecated IRQF_DISABLED
Date: Mon,  6 Oct 2014 17:35:48 +0200
Message-Id: <1412609755-28627-2-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412609755-28627-1-git-send-email-fabf@skynet.be>
References: <1412609755-28627-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See include/linux/interrupt.h:

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/edac/mv64x60_edac.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index 542fad7..6366e88 100644
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
-- 
1.9.3

