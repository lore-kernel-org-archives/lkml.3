Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbaEPNjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:39:23 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:34744 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268AbaEPNjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:39:19 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 13/49] media: davinci: vpif_display: drop reserving memory for device
Date: Fri, 16 May 2014 19:03:18 +0530
Message-Id: <1400247235-31434-15-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch drops reserving contigiuos memory for the device,
as now with CMA support there is no need of this.
This patch also prepares to removal of config_params.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |   18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 8bd3794..bfe1e50 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1338,7 +1338,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 	struct video_device *vfd;
 	struct resource *res;
 	int subdev_count;
-	size_t size;
 
 	vpif_dev = &pdev->dev;
 	err = initialize_vpif();
@@ -1395,23 +1394,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 		ch->video_dev = vfd;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res) {
-		size = resource_size(res);
-		/* The resources are divided into two equal memory and when
-		 * we have HD output we can add them together
-		 */
-		for (j = 0; j < VPIF_DISPLAY_MAX_DEVICES; j++) {
-			ch = vpif_obj.dev[j];
-			ch->channel_id = j;
-
-			/* only enabled if second resource exists */
-			config_params.video_limit[ch->channel_id] = 0;
-			if (size)
-				config_params.video_limit[ch->channel_id] =
-									size/2;
-		}
-	}
 	vpif_obj.config = pdev->dev.platform_data;
 	subdev_count = vpif_obj.config->subdev_count;
 	subdevdata = vpif_obj.config->subdevinfo;
-- 
1.7.9.5

