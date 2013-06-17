Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab3FQPV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:21:58 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:42631 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3FQPVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:21:55 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 07/11] media: davinci: vpif_capture: remove unnecessary loop for IRQ resource
Date: Mon, 17 Jun 2013 20:50:47 +0530
Message-Id: <1371482451-18314-8-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371482451-18314-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1371482451-18314-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

For vpif capture driver each IRQ resource contains a single IRQ
so drop the second loop.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index a4e0eab..5514175 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -2015,16 +2015,13 @@ static __init int vpif_probe(struct platform_device *pdev)
 	}
 
 	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, res_idx))) {
-		for (i = res->start; i <= res->end; i++) {
-			err = devm_request_irq(&pdev->dev, i, vpif_channel_isr,
-					     IRQF_SHARED, "VPIF_Capture",
-					     (void *)(&vpif_obj.dev[res_idx]->
-					     channel_id));
-			if (err) {
-				err = -EINVAL;
-				goto vpif_unregister;
-
-			}
+		err = devm_request_irq(&pdev->dev, res->start, vpif_channel_isr,
+					IRQF_SHARED, "VPIF_Capture",
+					(void *)(&vpif_obj.dev[res_idx]->
+					channel_id));
+		if (err) {
+			err = -EINVAL;
+			goto vpif_unregister;
 		}
 		res_idx++;
 	}
-- 
1.7.9.5

