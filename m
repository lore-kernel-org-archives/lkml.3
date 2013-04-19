Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968246Ab3DSJx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:53:59 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:40622 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968061Ab3DSJxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:53:55 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 2/2] media: davinci: vpif_display: move displaying of error to approppraite place
Date: Fri, 19 Apr 2013 15:23:30 +0530
Message-Id: <1366365210-3778-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366365210-3778-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1366365210-3778-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

this patch moves the displaying out error case  "VPIF IRQ request failed\n"
when there is actual request_irq() fail.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index d833056..7b17368 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1725,6 +1725,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 				for (j = 0; j < i; j++)
 					free_irq(j, (void *)
 					(&vpif_obj.dev[res_idx]->channel_id));
+				vpif_err("VPIF IRQ request failed\n");
 				goto vpif_int_err;
 			}
 		}
@@ -1878,7 +1879,6 @@ vpif_sd_error:
 	}
 vpif_int_err:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
-	vpif_err("VPIF IRQ request failed\n");
 	for (i = 0; i < res_idx; i++) {
 		res = platform_get_resource(pdev, IORESOURCE_IRQ, i);
 		for (j = res->start; j <= res->end; j++)
-- 
1.7.4.1

