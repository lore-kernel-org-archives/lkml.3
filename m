Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab3GLHR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:17:28 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:45822 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071Ab3GLHR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:17:27 -0400
From: Cosmin Stanescu <cosmin90stanescu@gmail.com>
To: hare@suse.de
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Cosmin Stanescu <cosmin90stanescu@gmail.com>
Subject: [PATCH] ic7xxx_osm: use kzalloc instead of kmalloc + memset
Date: Fri, 12 Jul 2013 10:17:05 +0300
Message-Id: <1373613425-30725-1-git-send-email-cosmin90stanescu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

found using coccinelle.

Signed-off-by: Cosmin Stanescu <cosmin90stanescu@gmail.com>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index c0c6258..7167cfe 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1223,10 +1223,9 @@ ahc_platform_alloc(struct ahc_softc *ahc, void *platform_arg)
 {
 
 	ahc->platform_data =
-	    kmalloc(sizeof(struct ahc_platform_data), GFP_ATOMIC);
+	    kzalloc(sizeof(struct ahc_platform_data), GFP_ATOMIC);
 	if (ahc->platform_data == NULL)
 		return (ENOMEM);
-	memset(ahc->platform_data, 0, sizeof(struct ahc_platform_data));
 	ahc->platform_data->irq = AHC_LINUX_NOIRQ;
 	ahc_lockinit(ahc);
 	ahc->seltime = (aic7xxx_seltime & 0x3) << 4;
-- 
1.7.10.4

