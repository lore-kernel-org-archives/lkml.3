Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbbAZOuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:50:39 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:51650 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbbAZOud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:50:33 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: am437x: fix sparse warnings
Date: Mon, 26 Jan 2015 14:50:15 +0000
Message-Id: <1422283815-1795-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes following spare warnings:

drivers/media/platform/am437x/am437x-vpfe.c:66:28: warning: symbol 'vpfe_standards' was not declared. Should it be static?
drivers/media/platform/am437x/am437x-vpfe.c:2202:57: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/am437x/am437x-vpfe.c:2202:57:    expected void [noderef] <asn:1>*params
drivers/media/platform/am437x/am437x-vpfe.c:2202:57:    got void *param
include/linux/spinlock.h:364:9: warning: context imbalance in 'vpfe_start_streaming' - unexpected unlock

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/am437x/am437x-vpfe.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index e01ac22..349bd06 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -63,7 +63,7 @@ struct vpfe_standard {
 	int frame_format;
 };
 
-const struct vpfe_standard vpfe_standards[] = {
+static const struct vpfe_standard vpfe_standards[] = {
 	{V4L2_STD_525_60, 720, 480, {11, 10}, 1},
 	{V4L2_STD_625_50, 720, 576, {54, 59}, 1},
 };
@@ -2024,7 +2024,6 @@ err:
 		list_del(&buf->list);
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
 	}
-	spin_unlock_irqrestore(&vpfe->dma_queue_lock, flags);
 
 	return ret;
 }
@@ -2199,7 +2198,7 @@ static long vpfe_ioctl_default(struct file *file, void *priv,
 
 	switch (cmd) {
 	case VIDIOC_AM437X_CCDC_CFG:
-		ret = vpfe_ccdc_set_params(&vpfe->ccdc, param);
+		ret = vpfe_ccdc_set_params(&vpfe->ccdc, (void __user *)param);
 		if (ret) {
 			vpfe_dbg(2, vpfe,
 				"Error setting parameters in CCDC\n");
-- 
1.9.1

