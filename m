Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaCNJIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:08:50 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:63155 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbaCNJIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:08:48 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: sachin.kamat@linaro.org, shaun@xresource.ca,
        dulshani.gunawardhana89@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: cxt1e1: remove redundant memset() call
Date: Fri, 14 Mar 2014 18:08:43 +0900
Message-ID: <17439351.R8V0LkWGHs@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The banner array doens't need to set to 0.
sprintf() adds a terminating '\0'.

And the sn array can be declared and initialized to zero.
So remove redundant memset() with zero.

Remove unnecessary cast for memcpy().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/cxt1e1/hwprobe.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index d87a011..d41fb79 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -51,22 +51,16 @@ show_two(hdw_info_t *hi, int brdno)
 	struct pci_dev *pdev;
 	char       *bid;
 	char       banner[80];
-	char	sn[6];
-
-	/* clear print buffer */
-	memset(banner, 0, 80);
+	char	sn[6] = {0,};
 
 	ci = (ci_t *)(netdev_priv(hi->ndev));
 	bid = sbeid_get_bdname(ci);
 	switch (hi->promfmt) {
 	case PROM_FORMAT_TYPE1:
-		memcpy(sn, (FLD_TYPE1 *)(hi->mfg_info.pft1.Serial), 6);
+		memcpy(sn, hi->mfg_info.pft1.Serial, 6);
 		break;
 	case PROM_FORMAT_TYPE2:
-		memcpy(sn, (FLD_TYPE2 *)(hi->mfg_info.pft2.Serial), 6);
-		break;
-	default:
-		memset(sn, 0, 6);
+		memcpy(sn, hi->mfg_info.pft2.Serial, 6);
 		break;
 	}
 
-- 
1.7.4.4


