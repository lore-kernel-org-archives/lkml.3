Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab3FQPWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:22:31 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:36352 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab3FQPWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:22:23 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 11/11] media: davinci: vpif_display: remove unnecessary loop for IRQ resource
Date: Mon, 17 Jun 2013 20:50:51 +0530
Message-Id: <1371482451-18314-12-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371482451-18314-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1371482451-18314-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

For vpif display driver each IRQ resource contains a single IRQ
so drop the second loop.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 1bf289d..e6e5736 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1651,16 +1651,14 @@ static __init int vpif_probe(struct platform_device *pdev)
 	}
 
 	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, res_idx))) {
-		for (i = res->start; i <= res->end; i++) {
-			err = devm_request_irq(&pdev->dev, i, vpif_channel_isr,
-					     IRQF_SHARED, "VPIF_Display",
-					     (void *)(&vpif_obj.dev[res_idx]->
-					     channel_id));
-			if (err) {
-				err = -EINVAL;
-				vpif_err("VPIF IRQ request failed\n");
-				goto vpif_unregister;
-			}
+		err = devm_request_irq(&pdev->dev, res->start, vpif_channel_isr,
+					IRQF_SHARED, "VPIF_Display",
+					(void *)(&vpif_obj.dev[res_idx]->
+					channel_id));
+		if (err) {
+			err = -EINVAL;
+			vpif_err("VPIF IRQ request failed\n");
+			goto vpif_unregister;
 		}
 		res_idx++;
 	}
-- 
1.7.9.5

