Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965228Ab3GCTHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:07:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964997Ab3GCTA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:28 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=1FQpJXCwRe8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=xLaRRN9_UWAA:10 a=6zZ5Uxn1AAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=QwnTS9JGZEsA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184102.222102193@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Christopher Harvey <charvey@matrox.com>, Julia Lemire <jlemire@matrox.com>,
        Dave Airlie <airlied@gmail.com>
Subject: [097/141] drm/mgag200: Add missing write to index before accessing data
 register
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0097-drm-mgag200-Add-missing-write-to-index-before-access.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Christopher Harvey <charvey@matrox.com>

[ Upstream commit 91f8f105f2b82b4a38dee2d74760bc39d40ec42c ]

This is a bug fix for some versions of g200se cards while doing
mode-setting.

Signed-off-by: Christopher Harvey <charvey@matrox.com>
Tested-by: Julia Lemire <jlemire@matrox.com>
Acked-by: Julia Lemire <jlemire@matrox.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/mgag200/mgag200_mode.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 85ef6cc..64e24f6 100644
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
1.7.10.4


