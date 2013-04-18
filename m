Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967315Ab3DRJd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:33:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40094 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505Ab3DRJRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christopher Harvey <charvey@matrox.com>, Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 23/72] drm/mgag200: Index 24 in extended CRTC registers is 24 in hex, not decimal.
Date: Thu, 18 Apr 2013 10:16:08 +0100
Message-Id: <1366276617-3553-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Harvey <charvey@matrox.com>

commit 1812a3db0874be1d1524086da9e84397b800f546 upstream.

This change properly enables the "requester" in G200ER cards that is
responsible for getting pixels out of memory and clocking them out to
the screen.

Signed-off-by: Christopher Harvey <charvey@matrox.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/mgag200/mgag200_mode.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 505a917..abb9776 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -752,8 +752,6 @@ static int mga_crtc_mode_set(struct drm_crtc *crtc,
 	int i;
 	unsigned char misc = 0;
 	unsigned char ext_vga[6];
-	unsigned char ext_vga_index24;
-	unsigned char dac_index90 = 0;
 	u8 bppshift;
 
 	static unsigned char dacvalue[] = {
@@ -804,7 +802,6 @@ static int mga_crtc_mode_set(struct drm_crtc *crtc,
 		option2 = 0x0000b000;
 		break;
 	case G200_ER:
-		dac_index90 = 0;
 		break;
 	}
 
@@ -853,10 +850,8 @@ static int mga_crtc_mode_set(struct drm_crtc *crtc,
 		WREG_DAC(i, dacvalue[i]);
 	}
 
-	if (mdev->type == G200_ER) {
-		WREG_DAC(0x90, dac_index90);
-	}
-
+	if (mdev->type == G200_ER)
+		WREG_DAC(0x90, 0);
 
 	if (option)
 		pci_write_config_dword(dev->pdev, PCI_MGA_OPTION, option);
@@ -953,8 +948,6 @@ static int mga_crtc_mode_set(struct drm_crtc *crtc,
 	if (mdev->type == G200_WB)
 		ext_vga[1] |= 0x88;
 
-	ext_vga_index24 = 0x05;
-
 	/* Set pixel clocks */
 	misc = 0x2d;
 	WREG8(MGA_MISC_OUT, misc);
@@ -966,7 +959,7 @@ static int mga_crtc_mode_set(struct drm_crtc *crtc,
 	}
 
 	if (mdev->type == G200_ER)
-		WREG_ECRT(24, ext_vga_index24);
+		WREG_ECRT(0x24, 0x5);
 
 	if (mdev->type == G200_EV) {
 		WREG_ECRT(6, 0);
-- 
1.8.1.2

