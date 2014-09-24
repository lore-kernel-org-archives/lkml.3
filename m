Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaIXIAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:00:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:61677 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbaIXIAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:00:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,587,1406617200"; 
   d="scan'208";a="604520638"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-usb@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [resend PATCH 2/3] usb: dwc3: core: only setting the dma_mask when needed
Date: Wed, 24 Sep 2014 11:00:38 +0300
Message-Id: <1411545639-18741-3-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411545639-18741-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1411545639-18741-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the probe drivers have already set the dma_mask, not
replacing the value.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/dwc3/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index b0f4d52..d08cac5 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -708,9 +708,11 @@ static int dwc3_probe(struct platform_device *pdev)
 	spin_lock_init(&dwc->lock);
 	platform_set_drvdata(pdev, dwc);
 
-	dev->dma_mask	= dev->parent->dma_mask;
-	dev->dma_parms	= dev->parent->dma_parms;
-	dma_set_coherent_mask(dev, dev->parent->coherent_dma_mask);
+	if (!dev->dma_mask) {
+		dev->dma_mask = dev->parent->dma_mask;
+		dev->dma_parms = dev->parent->dma_parms;
+		dma_set_coherent_mask(dev, dev->parent->coherent_dma_mask);
+	}
 
 	pm_runtime_enable(dev);
 	pm_runtime_get_sync(dev);
-- 
2.1.0

