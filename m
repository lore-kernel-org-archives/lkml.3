Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3BCVvc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 16:51:32 -0500
Received: from mout.gmx.net ([212.227.15.18]:64580 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab3BCVv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 16:51:27 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19iz1Zg1aNiOz2X+HgOa2v/vKD2xJSiqnP0ElWN1Z
	tkbGJLY1EpTBZU
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] staging/xgifb: mttr must be (signed) int
Date: Sun,  3 Feb 2013 22:54:32 +0100
Message-Id: <1359928479-8484-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
References: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mttr field must be declared as signed int (as in every other fb
driver) for the mttr functions to work properly.
Moreover the value should be initialized with -1.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/XGI_main_26.c |    2 +-
 drivers/staging/xgifb/XGIfb.h       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 83f8a6a..fa351f9 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1802,7 +1802,7 @@ static int xgifb_probe(struct pci_dev *pdev,
 	if (!XGIInitNew(pdev))
 		dev_err(&pdev->dev, "XGIInitNew() failed!\n");
 
-	xgifb_info->mtrr = (unsigned int) 0;
+	xgifb_info->mtrr = -1;
 
 	xgifb_info->hasVB = HASVB_NONE;
 	if ((xgifb_info->chip == XG20) ||
diff --git a/drivers/staging/xgifb/XGIfb.h b/drivers/staging/xgifb/XGIfb.h
index 8054798..af50362 100644
--- a/drivers/staging/xgifb/XGIfb.h
+++ b/drivers/staging/xgifb/XGIfb.h
@@ -67,7 +67,7 @@ struct xgifb_video_info {
 	unsigned long mmio_size;
 	void __iomem *mmio_vbase;
 	unsigned long vga_base;
-	unsigned long mtrr;
+	int mtrr;
 
 	int    video_bpp;
 	int    video_cmap_len;
-- 
1.7.8.6

