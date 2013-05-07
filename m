Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab3EGEG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:06:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057Ab3EGD6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:49 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=XejxuXeKI0UA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=uNamD4sBjgAA:10 a=6zZ5Uxn1AAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=UOpjjlpZozkG-P3uORQA:9 a=QwnTS9JGZEsA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035845.735964216@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Christopher Harvey <charvey@matrox.com>, Dave Airlie <airlied@redhat.com>
Subject: [029/126] drm/mgag200: Index 24 in extended CRTC registers is 24 in hex, not
 decimal.
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0029-drm-mgag200-Index-24-in-extended-CRTC-registers-is-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Christopher Harvey <charvey@matrox.com>

[ Upstream commit 1812a3db0874be1d1524086da9e84397b800f546 ]

This change properly enables the "requester" in G200ER cards that is
responsible for getting pixels out of memory and clocking them out to
the screen.

Signed-off-by: Christopher Harvey <charvey@matrox.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/mgag200/mgag200_mode.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 0a5daaa..fa82ead 100644
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
1.7.10.4


