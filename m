Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab3CJUFG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 16:05:06 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38739 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab3CJUFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 16:05:04 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: hare@suse.de, JBottomley@parallels.com, linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] aic7xxx: fix coccicheck warnings
Date: Sun, 10 Mar 2013 22:04:55 +0200
Message-Id: <1362945896-18475-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces a call to kmalloc() followed by memset() with just one
call to kzalloc().

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c |    3 +--
 drivers/scsi/aic7xxx/aic7xxx_osm.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 9328121..f6fdb65 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1324,10 +1324,9 @@ int
 ahd_platform_alloc(struct ahd_softc *ahd, void *platform_arg)
 {
 	ahd->platform_data =
-	    kmalloc(sizeof(struct ahd_platform_data), GFP_ATOMIC);
+	    kzalloc(sizeof(struct ahd_platform_data), GFP_ATOMIC);
 	if (ahd->platform_data == NULL)
 		return (ENOMEM);
-	memset(ahd->platform_data, 0, sizeof(struct ahd_platform_data));
 	ahd->platform_data->irq = AHD_LINUX_NOIRQ;
 	ahd_lockinit(ahd);
 	ahd->seltime = (aic79xx_seltime & 0x3) << 4;
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 5a477cd..54bb1de 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1222,10 +1222,9 @@ ahc_platform_alloc(struct ahc_softc *ahc, void *platform_arg)
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
1.7.9.5

