Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab3FRLom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:44:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56059 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab3FRLob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christopher Harvey <charvey@matrox.com>, Dave Airlie <airlied@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 38/93] drm/mgag200: Add missing write to index before accessing data register
Date: Tue, 18 Jun 2013 12:42:46 +0100
Message-Id: <1371555821-12820-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Harvey <charvey@matrox.com>

commit 91f8f105f2b82b4a38dee2d74760bc39d40ec42c upstream.

This is a bug fix for some versions of g200se cards while doing
mode-setting.

Signed-off-by: Christopher Harvey <charvey@matrox.com>
Tested-by: Julia Lemire <jlemire@matrox.com>
Acked-by: Julia Lemire <jlemire@matrox.com>
Signed-off-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/mgag200/mgag200_mode.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 4860c35..4e48f91 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -1042,13 +1042,14 @@ static int mga_crtc_mode_set(struct drm_crtc *crtc,
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
-- 
1.8.1.2

