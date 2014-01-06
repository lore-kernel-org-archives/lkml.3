Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbaAFPmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:42:14 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:43131 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbaAFPmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:42:12 -0500
Date: Mon, 6 Jan 2014 21:12:07 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Mark Kettenis <kettenis@openbsd.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 35/85] drivers: gpu: Move prototype declaration to header
 file radeon_mode.h
Message-ID: <22337ba41abeecf9559ea2d0c4ded36ff32a7828.1389018325.git.rashika.kheria@gmail.com>
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

Move prototype declaration of functions radeon_add_atom_connector() and
radeon_add_legacy_connector() to header file drm/radeon/radeon_mode.h
because  they are used by more than one file.

This eliminates the following warning in drm/radeon/radeon_connectors.c:
drivers/gpu/drm/radeon/radeon_connectors.c:1588:1: warning: no previous prototype for ‘radeon_add_atom_connector’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_connectors.c:2020:1: warning: no previous prototype for ‘radeon_add_legacy_connector’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/radeon_atombios.c |   12 ------------
 drivers/gpu/drm/radeon/radeon_combios.c  |   10 ----------
 drivers/gpu/drm/radeon/radeon_mode.h     |   21 ++++++++++++++++++++-
 3 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index b3bf270..392ea6e 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -41,18 +41,6 @@ extern void
 radeon_add_atom_encoder(struct drm_device *dev, uint32_t encoder_enum,
 			uint32_t supported_device, u16 caps);
 
-/* from radeon_connector.c */
-extern void
-radeon_add_atom_connector(struct drm_device *dev,
-			  uint32_t connector_id,
-			  uint32_t supported_device,
-			  int connector_type,
-			  struct radeon_i2c_bus_rec *i2c_bus,
-			  uint32_t igp_lane_info,
-			  uint16_t connector_object_id,
-			  struct radeon_hpd *hpd,
-			  struct radeon_router *router);
-
 /* from radeon_legacy_encoder.c */
 extern void
 radeon_add_legacy_encoder(struct drm_device *dev, uint32_t encoder_enum,
diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/radeon/radeon_combios.c
index 68ce360..e4c1b8d 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -43,16 +43,6 @@ radeon_get_encoder_enum(struct drm_device *dev, uint32_t supported_device,
 			uint8_t dac);
 extern void radeon_link_encoder_connector(struct drm_device *dev);
 
-/* from radeon_connector.c */
-extern void
-radeon_add_legacy_connector(struct drm_device *dev,
-			    uint32_t connector_id,
-			    uint32_t supported_device,
-			    int connector_type,
-			    struct radeon_i2c_bus_rec *i2c_bus,
-			    uint16_t connector_object_id,
-			    struct radeon_hpd *hpd);
-
 /* from radeon_legacy_encoder.c */
 extern void
 radeon_add_legacy_encoder(struct drm_device *dev, uint32_t encoder_enum,
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index b2b556b..e841fde 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -50,7 +50,6 @@ void
 radeon_combios_connected_scratch_regs(struct drm_connector *connector,
 				      struct drm_encoder *encoder,
 				      bool connected);
-
 enum radeon_rmx_type {
 	RMX_OFF,
 	RMX_FULL,
@@ -629,6 +628,26 @@ struct atom_voltage_table
 	struct atom_voltage_table_entry entries[MAX_VOLTAGE_ENTRIES];
 };
 
+
+void
+radeon_add_atom_connector(struct drm_device *dev,
+			  uint32_t connector_id,
+			  uint32_t supported_device,
+			  int connector_type,
+			  struct radeon_i2c_bus_rec *i2c_bus,
+			  uint32_t igp_lane_info,
+			  uint16_t connector_object_id,
+			  struct radeon_hpd *hpd,
+			  struct radeon_router *router);
+void 
+radeon_add_legacy_connector(struct drm_device *dev,
+			    uint32_t connector_id,
+			    uint32_t supported_device,
+			    int connector_type,
+			    struct radeon_i2c_bus_rec *i2c_bus,
+			    uint16_t connector_object_id,
+			    struct radeon_hpd *hpd);
+
 extern enum radeon_tv_std
 radeon_combios_get_tv_info(struct radeon_device *rdev);
 extern enum radeon_tv_std
-- 
1.7.9.5

