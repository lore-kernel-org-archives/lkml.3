Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab3FKUL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:11:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734Ab3FKUEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christopher Harvey <charvey@matrox.com>,
        Julia Lemire <jlemire@matrox.com>, Dave Airlie <airlied@gmail.com>
Subject: [ 53/79] drm/mgag200: Add missing write to index before accessing data register
Date: Tue, 11 Jun 2013 13:03:19 -0700
Message-Id: <20130611195323.077120525@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Harvey <charvey@matrox.com>

commit 91f8f105f2b82b4a38dee2d74760bc39d40ec42c upstream.

This is a bug fix for some versions of g200se cards while doing
mode-setting.

Signed-off-by: Christopher Harvey <charvey@matrox.com>
Tested-by: Julia Lemire <jlemire@matrox.com>
Acked-by: Julia Lemire <jlemire@matrox.com>
Signed-off-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/mgag200/mgag200_mode.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -1041,13 +1041,14 @@ static int mga_crtc_mode_set(struct drm_
 			else
 				hi_pri_lvl = 5;
 
-			WREG8(0x1fde, 0x06);
-			WREG8(0x1fdf, hi_pri_lvl);
+			WREG8(MGAREG_CRTCEXT_INDEX, 0x06);
+			WREG8(MGAREG_CRTCEXT_DATA, hi_pri_lvl);
 		} else {
+			WREG8(MGAREG_CRTCEXT_INDEX, 0x06);
 			if (mdev->reg_1e24 >= 0x01)
-				WREG8(0x1fdf, 0x03);
+				WREG8(MGAREG_CRTCEXT_DATA, 0x03);
 			else
-				WREG8(0x1fdf, 0x04);
+				WREG8(MGAREG_CRTCEXT_DATA, 0x04);
 		}
 	}
 	return 0;


