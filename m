Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab3FWHDz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 03:03:55 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:57756 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab3FWHDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 03:03:44 -0400
From: Chad Williamson <chad@dahc.us>
To: gregkh@linuxfoundation.org
Cc: puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        tulinizer@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Chad Williamson <chad@dahc.us>
Subject: [PATCH 2/6] Staging: silicom: capitalize labels in the bp_media_type enum
Date: Sun, 23 Jun 2013 02:02:24 -0500
Message-Id: <1371970948-26802-3-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371970948-26802-1-git-send-email-chad@dahc.us>
References: <1371970948-26802-1-git-send-email-chad@dahc.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Capitalize the names of the media types in enum bp_media_type in
bpctl_mod.c, as is the preffered style.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 drivers/staging/silicom/bpctl_mod.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 33e226d..96cda96 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -53,10 +53,10 @@ if (down_interruptible(&bpctl_sema)) {			\
 
 /* Media Types */
 enum bp_media_type {
-	bp_copper = 0,
-	bp_fiber,
-	bp_cx4,
-	bp_none,
+	BP_COPPER = 0,
+	BP_FIBER,
+	BP_CX4,
+	BP_NONE,
 };
 
 struct bypass_pfs_sd {
@@ -3400,7 +3400,7 @@ static int bypass_status(bpctl_dev_t *pbpctl_dev)
 					 BP10G_SDP7_DATA_IN) != 0 ? 0 : 1);
 			}
 
-		} else if (pbpctl_dev->media_type == bp_copper) {
+		} else if (pbpctl_dev->media_type == BP_COPPER) {
 
 			return (((BPCTL_READ_REG(pbpctl_dev_b, CTRL)) &
 				 BPCTLI_CTRL_SWDPIN1) != 0 ? 1 : 0);
@@ -3646,7 +3646,7 @@ int tap_status(bpctl_dev_t *pbpctl_dev)
 					 BP10G_SDP6_DATA_IN) != 0 ? 0 : 1);
 			}
 
-		} else if (pbpctl_dev->media_type == bp_copper)
+		} else if (pbpctl_dev->media_type == BP_COPPER)
 			return (((BPCTL_READ_REG(pbpctl_dev, CTRL)) &
 				 BPCTLI_CTRL_SWDPIN0) != 0 ? 1 : 0);
 		else {
@@ -3741,7 +3741,7 @@ int disc_off_status(bpctl_dev_t *pbpctl_dev)
 				 BP10G_SDP2_DATA) != 0 ? 1 : 0);
 
 		}
-		if (pbpctl_dev->media_type == bp_copper) {
+		if (pbpctl_dev->media_type == BP_COPPER) {
 
 #if 0
 			return ((((read_reg(pbpctl_dev, STATUS_DISC_REG_ADDR)) &
@@ -4032,36 +4032,36 @@ void bypass_caps_init(bpctl_dev_t *pbpctl_dev)
 	}
 #endif
 	if ((pbpctl_dev->bp_fiber5) || (pbpctl_dev->bp_10g9)) {
-		pbpctl_dev->media_type = bp_fiber;
+		pbpctl_dev->media_type = BP_FIBER;
 	} else if (pbpctl_dev->bp_10gb) {
 		if (BP10GB_CX4_SERIES(pbpctl_dev->subdevice))
-			pbpctl_dev->media_type = bp_cx4;
+			pbpctl_dev->media_type = BP_CX4;
 		else
-			pbpctl_dev->media_type = bp_fiber;
+			pbpctl_dev->media_type = BP_FIBER;
 
 	}
 
 	else if (pbpctl_dev->bp_540)
-		pbpctl_dev->media_type = bp_none;
+		pbpctl_dev->media_type = BP_NONE;
 	else if (!pbpctl_dev->bp_10g) {
 
 		ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
 		if ((ctrl_ext & BPCTLI_CTRL_EXT_LINK_MODE_MASK) == 0x0)
-			pbpctl_dev->media_type = bp_copper;
+			pbpctl_dev->media_type = BP_COPPER;
 		else
-			pbpctl_dev->media_type = bp_fiber;
+			pbpctl_dev->media_type = BP_FIBER;
 
 	} else {
 		if (BP10G_CX4_SERIES(pbpctl_dev->subdevice))
-			pbpctl_dev->media_type = bp_cx4;
+			pbpctl_dev->media_type = BP_CX4;
 		else
-			pbpctl_dev->media_type = bp_fiber;
+			pbpctl_dev->media_type = BP_FIBER;
 	}
 
 	if (is_bypass_fn(pbpctl_dev)) {
 
 		pbpctl_dev->bp_caps |= BP_PWOFF_ON_CAP;
-		if (pbpctl_dev->media_type == bp_fiber)
+		if (pbpctl_dev->media_type == BP_FIBER)
 			pbpctl_dev->bp_caps |=
 			    (TX_CTL_CAP | TX_STATUS_CAP | TPL_CAP);
 
@@ -5030,7 +5030,7 @@ static int get_bypass_link_status(bpctl_dev_t *pbpctl_dev)
 	if (!pbpctl_dev)
 		return -1;
 
-	if (pbpctl_dev->media_type == bp_fiber)
+	if (pbpctl_dev->media_type == BP_FIBER)
 		return ((BPCTL_READ_REG(pbpctl_dev, CTRL) &
 			 BPCTLI_CTRL_SWDPIN1));
 	else
-- 
1.8.1.4

