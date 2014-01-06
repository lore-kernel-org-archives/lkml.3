Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbaAFPHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:07:24 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52634 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaAFPHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:07:20 -0500
Date: Mon, 6 Jan 2014 20:37:15 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
        Christopher Harvey <charvey@matrox.com>,
        Julia Lemire <jlemire@matrox.com>,
        Mathieu Larouche <mathieu.larouche@matrox.com>,
        Egbert Eich <eich@suse.de>, dri-devel@lists.freedesktop.org,
        josh@joshtriplett.org
Subject: [PATCH 11/85] drivers: gpu: Mark functions as static in
 mgag200_mode.c
Message-ID: <93e90abacdf2bc36e63a19c287528591bd0971d2.1389018324.git.rashika.kheria@gmail.com>
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

Mark functions mga_set_start_address(), mga_encoder_destroy() and
mga_connector_best_encoder() as static in drm/mgag200/mgag200_mode.c
because they are not used outside this file.

This eliminates the following warnings in drm/mgag200/mgag200_mode.c:
drivers/gpu/drm/mgag200/mgag200_mode.c:694:6: warning: no previous
prototype for ‘mga_set_start_address’ [-Wmissing-prototypes]
drivers/gpu/drm/mgag200/mgag200_mode.c:1401:6: warning: no previous
prototype for ‘mga_encoder_destroy’ [-Wmissing-prototypes]
drivers/gpu/drm/mgag200/mgag200_mode.c:1561:21: warning: no previous
prototype for ‘mga_connector_best_encoder’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/mgag200/mgag200_mode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index ee6ed63..b8583f2 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -691,7 +691,7 @@ static void mga_g200wb_commit(struct drm_crtc *crtc)
    CRTCEXT0 has to be programmed last to trigger an update and make the
    new addr variable take effect.
  */
-void mga_set_start_address(struct drm_crtc *crtc, unsigned offset)
+static void mga_set_start_address(struct drm_crtc *crtc, unsigned offset)
 {
 	struct mga_device *mdev = crtc->dev->dev_private;
 	u32 addr;
@@ -1398,7 +1398,7 @@ static void mga_encoder_commit(struct drm_encoder *encoder)
 {
 }
 
-void mga_encoder_destroy(struct drm_encoder *encoder)
+static void mga_encoder_destroy(struct drm_encoder *encoder)
 {
 	struct mga_encoder *mga_encoder = to_mga_encoder(encoder);
 	drm_encoder_cleanup(encoder);
@@ -1558,7 +1558,7 @@ static int mga_vga_mode_valid(struct drm_connector *connector,
 	return MODE_OK;
 }
 
-struct drm_encoder *mga_connector_best_encoder(struct drm_connector
+static struct drm_encoder *mga_connector_best_encoder(struct drm_connector
 						  *connector)
 {
 	int enc_id = connector->encoder_ids[0];
-- 
1.7.9.5

