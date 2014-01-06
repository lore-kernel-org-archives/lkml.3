Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbaAFPAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:00:20 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:38097 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaAFPAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:00:19 -0500
Date: Mon, 6 Jan 2014 20:30:14 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Gerd Hoffmann <kraxel@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        josh@joshtriplett.org
Subject: [PATCH 06/85] drivers: gpu: Mark functions as static in cirrus_mode.c
Message-ID: <d5826178da31ac64081dd107cecf0cd4f45e60d5.1389018324.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions cirrus_set_start_address(), cirrus_encoder_destroy(),
cirrus_vga_get_modes() and cirrus_connector_best_encoder() as static in
drm/cirrus/cirrus_mode.c because they are not used outside this file.

This eliminates the following warnings in drm/cirrus/cirrus_mode.c:
drivers/gpu/drm/cirrus/cirrus_mode.c:105:6: warning: no previous
prototype for ‘cirrus_set_start_address’ [-Wmissing-prototypes]
drivers/gpu/drm/cirrus/cirrus_mode.c:456:6: warning: no previous
prototype for ‘cirrus_encoder_destroy’ [-Wmissing-prototypes]
drivers/gpu/drm/cirrus/cirrus_mode.c:495:5: warning: no previous
prototype for ‘cirrus_vga_get_modes’ [-Wmissing-prototypes]
drivers/gpu/drm/cirrus/cirrus_mode.c:512:21: warning: no previous
prototype for ‘cirrus_connector_best_encoder’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/cirrus/cirrus_mode.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/cirrus/cirrus_mode.c b/drivers/gpu/drm/cirrus/cirrus_mode.c
index adabc3d..58dd900 100644
--- a/drivers/gpu/drm/cirrus/cirrus_mode.c
+++ b/drivers/gpu/drm/cirrus/cirrus_mode.c
@@ -102,7 +102,7 @@ static bool cirrus_crtc_mode_fixup(struct drm_crtc *crtc,
 	return true;
 }
 
-void cirrus_set_start_address(struct drm_crtc *crtc, unsigned offset)
+static void cirrus_set_start_address(struct drm_crtc *crtc, unsigned offset)
 {
 	struct cirrus_device *cdev = crtc->dev->dev_private;
 	u32 addr;
@@ -453,7 +453,7 @@ static void cirrus_encoder_commit(struct drm_encoder *encoder)
 {
 }
 
-void cirrus_encoder_destroy(struct drm_encoder *encoder)
+static void cirrus_encoder_destroy(struct drm_encoder *encoder)
 {
 	struct cirrus_encoder *cirrus_encoder = to_cirrus_encoder(encoder);
 	drm_encoder_cleanup(encoder);
@@ -492,7 +492,7 @@ static struct drm_encoder *cirrus_encoder_init(struct drm_device *dev)
 }
 
 
-int cirrus_vga_get_modes(struct drm_connector *connector)
+static int cirrus_vga_get_modes(struct drm_connector *connector)
 {
 	int count;
 
@@ -509,7 +509,7 @@ static int cirrus_vga_mode_valid(struct drm_connector *connector,
 	return MODE_OK;
 }
 
-struct drm_encoder *cirrus_connector_best_encoder(struct drm_connector
+static struct drm_encoder *cirrus_connector_best_encoder(struct drm_connector
 						  *connector)
 {
 	int enc_id = connector->encoder_ids[0];
-- 
1.7.9.5

