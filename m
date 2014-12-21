Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbaLUMyG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 07:54:06 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35507 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbaLUMyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 07:54:04 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: radio: wl128x: fmdrv_rx.c:  Remove unused function
Date: Sun, 21 Dec 2014 13:56:49 +0100
Message-Id: <1419166609-2320-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function fm_rx_get_rds_system() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/media/radio/wl128x/fmdrv_rx.c |   16 ----------------
 drivers/media/radio/wl128x/fmdrv_rx.h |    1 -
 2 files changed, 17 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_rx.c b/drivers/media/radio/wl128x/fmdrv_rx.c
index 09632cb..cfaeb24 100644
--- a/drivers/media/radio/wl128x/fmdrv_rx.c
+++ b/drivers/media/radio/wl128x/fmdrv_rx.c
@@ -785,22 +785,6 @@ int fm_rx_set_rds_system(struct fmdev *fmdev, u8 rds_mode)
 	return 0;
 }
 
-/* Returns current RDS operation mode */
-int fm_rx_get_rds_system(struct fmdev *fmdev, u8 *rds_mode)
-{
-	if (fmdev->curr_fmmode != FM_MODE_RX)
-		return -EPERM;
-
-	if (rds_mode == NULL) {
-		fmerr("Invalid memory\n");
-		return -ENOMEM;
-	}
-
-	*rds_mode = fmdev->rx.rds_mode;
-
-	return 0;
-}
-
 /* Configures Alternate Frequency switch mode */
 int fm_rx_set_af_switch(struct fmdev *fmdev, u8 af_mode)
 {
diff --git a/drivers/media/radio/wl128x/fmdrv_rx.h b/drivers/media/radio/wl128x/fmdrv_rx.h
index 32add81..2392218 100644
--- a/drivers/media/radio/wl128x/fmdrv_rx.h
+++ b/drivers/media/radio/wl128x/fmdrv_rx.h
@@ -40,7 +40,6 @@ void fm_rx_reset_station_info(struct fmdev *);
 int fm_rx_seek(struct fmdev *, u32, u32, u32);
 
 int fm_rx_get_rds_mode(struct fmdev *, u8 *);
-int fm_rx_get_rds_system(struct fmdev *, u8 *);
 int fm_rx_get_mute_mode(struct fmdev *, u8 *);
 int fm_rx_get_volume(struct fmdev *, u16 *);
 int fm_rx_get_band_freq_range(struct fmdev *,
-- 
1.7.10.4

