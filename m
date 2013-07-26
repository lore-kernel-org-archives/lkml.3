Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab3GZPWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:22:23 -0400
Received: from smtp121.dfw.emailsrvr.com ([67.192.241.121]:36538 "EHLO
	smtp121.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab3GZPWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:22:18 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jul 2013 11:22:18 EDT
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org,
        devicetree@vger.kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob.herring@calxeda.com
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH 2/5] sata highbank: enable 64-bit DMA mask when using LPAE
Date: Fri, 26 Jul 2013 10:11:55 -0500
Message-Id: <1374851518-4802-2-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374851518-4802-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1374851518-4802-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
---
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

