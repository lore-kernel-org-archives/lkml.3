Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab3BSB7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 20:59:22 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:64544 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab3BSB7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 20:59:21 -0500
From: maxin.john@gmail.com
To: djbw@fb.com, vinod.koul@intel.com
Cc: geert@linux-m68k.org, linux-kernel@vger.kernel.org,
        "Maxin B. John" <maxin.john@enea.com>
Subject: [PATCH] dma: timb_dma: Fix compiler warning
Date: Mon, 18 Feb 2013 21:59:06 +0200
Message-Id: <1361217546-3116-1-git-send-email-maxin.john@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Maxin B. John" <maxin.john@enea.com>

Fix this compiler warning:
warning: 'td_remove' defined but not used [-Wunused-function]

Signed-off-by: Maxin B. John <maxin.john@enea.com>
---
 drivers/dma/timb_dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 952f823..f709279 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -798,7 +798,7 @@ err_release_region:
 
 }
 
-static int td_remove(struct platform_device *pdev)
+static int __exit td_remove(struct platform_device *pdev)
 {
 	struct timb_dma *td = platform_get_drvdata(pdev);
 	struct resource *iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
1.7.7

