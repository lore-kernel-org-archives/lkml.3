Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaIBC45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 22:56:57 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:60412 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaIBC4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 22:56:55 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Thierry Reding <thierry.reding@gmail.com>, dri-devel@lists.freedesktop.org
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH] drm/panel: update innolux n116bge timings
Date: Tue,  2 Sep 2014 10:56:46 +0800
Message-Id: <1409626606-15225-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several different models of N116BGE.  According to the commit
that added innolux_n116bge_mode [0], this N116BGE is for the eDP variety.

[0] commit 0a2288c06aab73c966e82045c8f20b0e713baf2a
 Author: Thierry Reding <treding@nvidia.com>
 Date:   Thu Jul 3 14:02:59 2014 +0200

   drm/panel: simple: Add Innolux N116BGE panel support

The clock and htotal values from add by that patch are out of spec according to
the datasheets I have seen for the eDP N116BGE (-EA2 and -EB2).

This patch changes the values to the "Typ" values on the datasheet.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---

Thierry,

It is possible that your timings were correct for the panel you are using on
the norrin reference board.  In that case I'm happy to upload a new patch
that creates a new panel entry.  However, I'm pretty sure we are using the
same N116BGE.

 drivers/gpu/drm/panel/panel-simple.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 4ce1db0..776764a 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -519,15 +519,15 @@ static const struct panel_desc foxlink_fl500wvr00_a0t = {
 };
 
 static const struct drm_display_mode innolux_n116bge_mode = {
-	.clock = 71000,
+	.clock = 76420,
 	.hdisplay = 1366,
-	.hsync_start = 1366 + 64,
-	.hsync_end = 1366 + 64 + 6,
-	.htotal = 1366 + 64 + 6 + 64,
+	.hsync_start = 1366 + 136,
+	.hsync_end = 1366 + 136 + 30,
+	.htotal = 1366 + 136 + 30 + 60,
 	.vdisplay = 768,
 	.vsync_start = 768 + 8,
-	.vsync_end = 768 + 8 + 4,
-	.vtotal = 768 + 8 + 4 + 8,
+	.vsync_end = 768 + 8 + 12,
+	.vtotal = 768 + 8 + 12 + 12,
 	.vrefresh = 60,
 	.flags = DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_NVSYNC,
 };
-- 
2.1.0.rc2.206.gedb03e5

