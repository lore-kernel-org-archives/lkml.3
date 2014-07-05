Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703AbaGEMU6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 08:20:58 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:44604 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbaGEMU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 08:20:57 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Masanari Iida <standby24x7@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: gbefb.c:  Cleaning up variable that is never used
Date: Sat,  5 Jul 2014 14:22:12 +0200
Message-Id: <1404562932-19522-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/gbefb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/gbefb.c b/drivers/video/fbdev/gbefb.c
index 4aa56ba..4227570 100644
--- a/drivers/video/fbdev/gbefb.c
+++ b/drivers/video/fbdev/gbefb.c
@@ -205,7 +205,7 @@ static void gbe_reset(void)
 static void gbe_turn_off(void)
 {
 	int i;
-	unsigned int val, x, y, vpixen_off;
+	unsigned int val, y, vpixen_off;
 
 	gbe_turned_on = 0;
 
@@ -256,7 +256,7 @@ static void gbe_turn_off(void)
 
 	for (i = 0; i < 100000; i++) {
 		val = gbe->vt_xy;
-		x = GET_GBE_FIELD(VT_XY, X, val);
+		GET_GBE_FIELD(VT_XY, X, val);
 		y = GET_GBE_FIELD(VT_XY, Y, val);
 		if (y < vpixen_off)
 			break;
@@ -267,7 +267,7 @@ static void gbe_turn_off(void)
 		       "gbefb: wait for vpixen_off timed out\n");
 	for (i = 0; i < 10000; i++) {
 		val = gbe->vt_xy;
-		x = GET_GBE_FIELD(VT_XY, X, val);
+		GET_GBE_FIELD(VT_XY, X, val);
 		y = GET_GBE_FIELD(VT_XY, Y, val);
 		if (y > vpixen_off)
 			break;
-- 
1.7.10.4

