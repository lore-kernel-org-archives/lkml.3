Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbaCNFZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:25:50 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:53042 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaCNFZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:25:48 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: davinci: vpbe: fix build warning
Date: Fri, 14 Mar 2014 10:55:35 +0530
Message-Id: <1394774735-22320-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch fixes following build warning
drivers/media/platform/davinci/vpbe_display.c: In function 'vpbe_start_streaming':
drivers/media/platform/davinci/vpbe_display.c:344: warning: unused variable 'vpbe_dev'

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 7a0e40e..b4f12d0 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -341,7 +341,6 @@ static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vpbe_fh *fh = vb2_get_drv_priv(vq);
 	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
 	int ret;
 
 	/* Get the next frame from the buffer queue */
-- 
1.7.9.5

