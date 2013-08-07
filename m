Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab3HGPx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:53:58 -0400
Received: from smtp161.dfw.emailsrvr.com ([67.192.241.161]:55651 "EHLO
	smtp161.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab3HGPxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 11:53:55 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org,
        devicetree@vger.kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob.herring@calxeda.com, sergei.shtylyov@cogentembedded.com
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH v3 2/5] sata highbank: enable 64-bit DMA mask when using LPAE
Date: Wed,  7 Aug 2013 10:52:35 -0500
Message-Id: <1375890758-30265-2-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375890758-30265-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1375890758-30265-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
---
Changes from v1, v2
	None.

 drivers/ata/sata_highbank.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index e9a4f46..8b40025 100644
--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -479,6 +479,9 @@ static int ahci_highbank_probe(struct platform_device *pdev)
 	if (hpriv->cap & HOST_CAP_PMP)
 		pi.flags |= ATA_FLAG_PMP;
 
+	if (hpriv->cap & HOST_CAP_64)
+		dma_set_coherent_mask(dev, DMA_BIT_MASK(64));
+
 	/* CAP.NP sometimes indicate the index of the last enabled
 	 * port, at other times, that of the last possible port, so
 	 * determining the maximum port number requires looking at
-- 
1.8.1.2

