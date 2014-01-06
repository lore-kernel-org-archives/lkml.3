Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbaAFPxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:53:45 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:46078 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaAFPxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:53:43 -0500
Date: Mon, 6 Jan 2014 21:23:37 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 44/85] drivers: gpu: Move prototype declaration to header
 file radeon_mode.h from radeon_atombios.c and radeon_encoders.c
Message-ID: <357ad7be5b1183a598bb64b8ebb21966d341bc86.1389018325.git.rashika.kheria@gmail.com>
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

Move prototype declarations of function radeon_add_atom_encoder() and
radeon_atom_backlight_init() to header file drm/radeon/radeon_mode.h
because they are used by more than one file.

This eliminates the following warning in drm/radeon/atombios_encoders.c:
drivers/gpu/drm/radeon/atombios_encoders.c:177:6: warning: no previous prototype for ‘radeon_atom_backlight_init’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/atombios_encoders.c:2600:1: warning: no previous prototype for ‘radeon_add_atom_encoder’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/radeon_atombios.c |    4 ----
 drivers/gpu/drm/radeon/radeon_encoders.c |    4 ----
 drivers/gpu/drm/radeon/radeon_mode.h     |    7 +++++++
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index a876fae..19a7350 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -32,10 +32,6 @@
 #include "radeon_asic.h"
 #include "atom-bits.h"
 
-extern void
-radeon_add_atom_encoder(struct drm_device *dev, uint32_t encoder_enum,
-			uint32_t supported_device, u16 caps);
-
 /* from radeon_legacy_encoder.c */
 extern void
 radeon_add_legacy_encoder(struct drm_device *dev, uint32_t encoder_enum,
diff --git a/drivers/gpu/drm/radeon/radeon_encoders.c b/drivers/gpu/drm/radeon/radeon_encoders.c
index bd4959c..a88ba7a 100644
--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -32,10 +32,6 @@
 extern void
 radeon_legacy_backlight_init(struct radeon_encoder *radeon_encoder,
 			     struct drm_connector *drm_connector);
-extern void
-radeon_atom_backlight_init(struct radeon_encoder *radeon_encoder,
-			   struct drm_connector *drm_connector);
-
 
 static uint32_t radeon_encoder_clones(struct drm_encoder *encoder)
 {
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index b5f4e52..8f2f4a3 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -628,6 +628,13 @@ struct atom_voltage_table
 	struct atom_voltage_table_entry entries[MAX_VOLTAGE_ENTRIES];
 };
 
+void
+radeon_atom_backlight_init(struct radeon_encoder *radeon_encoder,
+			   struct drm_connector *drm_connector);
+
+void
+radeon_add_atom_encoder(struct drm_device *dev, uint32_t encoder_enum,
+			uint32_t supported_device, u16 caps);
 
 void
 radeon_add_atom_connector(struct drm_device *dev,
-- 
1.7.9.5

