Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937342Ab3DJXJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:09:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937297Ab3DJWre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christopher Harvey <charvey@matrox.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 44/64] drm/mgag200: Index 24 in extended CRTC registers is 24 in hex, not decimal.
Date: Wed, 10 Apr 2013 15:46:41 -0700
Message-Id: <20130410224343.623453009@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Harvey <charvey@matrox.com>

commit 1812a3db0874be1d1524086da9e84397b800f546 upstream.

This change properly enables the "requester" in G200ER cards that is
responsible for getting pixels out of memory and clocking them out to
the screen.

Signed-off-by: Christopher Harvey <charvey@matrox.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/mgag200/mgag200_mode.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -751,8 +751,6 @@ static int mga_crtc_mode_set(struct drm_
 	int i;
 	unsigned char misc = 0;
 	unsigned char ext_vga[6];
-	unsigned char ext_vga_index24;
-	unsigned char dac_index90 = 0;
 	u8 bppshift;
 
 	static unsigned char dacvalue[] = {
@@ -803,7 +801,6 @@ static int mga_crtc_mode_set(struct drm_
 		option2 = 0x0000b000;
 		break;
 	case G200_ER:
-		dac_index90 = 0;
 		break;
 	}
 
@@ -852,10 +849,8 @@ static int mga_crtc_mode_set(struct drm_
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
@@ -952,8 +947,6 @@ static int mga_crtc_mode_set(struct drm_
 	if (mdev->type == G200_WB)
 		ext_vga[1] |= 0x88;
 
-	ext_vga_index24 = 0x05;
-
 	/* Set pixel clocks */
 	misc = 0x2d;
 	WREG8(MGA_MISC_OUT, misc);
@@ -965,7 +958,7 @@ static int mga_crtc_mode_set(struct drm_
 	}
 
 	if (mdev->type == G200_ER)
-		WREG_ECRT(24, ext_vga_index24);
+		WREG_ECRT(0x24, 0x5);
 
 	if (mdev->type == G200_EV) {
 		WREG_ECRT(6, 0);


