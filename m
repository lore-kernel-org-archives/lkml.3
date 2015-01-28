Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbbA1U6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:58:43 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48363 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731AbbA1U6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:58:38 -0500
Date: Wed, 28 Jan 2015 16:37:24 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: hare@suse.de
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/4] scsi: aic79xx: Use kzalloc instead of kmalloc/memset
Message-ID: <20150128073724.GA13641@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 97f2acc..109e2c9 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -10437,14 +10437,13 @@ ahd_handle_en_lun(struct ahd_softc *ahd, struct cam_sim *sim, union ccb *ccb)
 				return;
 			}
 		}
-		lstate = kmalloc(sizeof(*lstate), GFP_ATOMIC);
+		lstate = kzalloc(sizeof(*lstate), GFP_ATOMIC);
 		if (lstate == NULL) {
 			xpt_print_path(ccb->ccb_h.path);
 			printk("Couldn't allocate lstate\n");
 			ccb->ccb_h.status = CAM_RESRC_UNAVAIL;
 			return;
 		}
-		memset(lstate, 0, sizeof(*lstate));
 		status = xpt_create_path(&lstate->path, /*periph*/NULL,
 					 xpt_path_path_id(ccb->ccb_h.path),
 					 xpt_path_target_id(ccb->ccb_h.path),
-- 
1.7.1

