Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbaAFPnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:43:24 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:49594 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaAFPnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:43:22 -0500
Date: Mon, 6 Jan 2014 21:13:17 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Mark Kettenis <kettenis@openbsd.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 36/85] drivers: gpu: Move prototype declarations to header
 file radeon_mode.h from radeon_atombios.c and radeon_combios.c
Message-ID: <5d9f325f03a2276cdb0840295aee52cb40959a6a.1389018325.git.rashika.kheria@gmail.com>
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

Move prototype declarations of functions radeon_get_encoder_enum() and
radeon_link_encoder_connector() to header file drm/radeon/radeon_mode.h
because they are used by more than one file.

This eliminates the following warnings in drm/radeon/radeon_encoders.c:
drivers/gpu/drm/radeon/radeon_encoders.c:86:1: warning: no previous prototype for ‘radeon_get_encoder_enum’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_encoders.c:162:1: warning: no previous prototype for ‘radeon_link_encoder_connector’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/radeon_atombios.c |    5 -----
 drivers/gpu/drm/radeon/radeon_combios.c  |    6 ------
 drivers/gpu/drm/radeon/radeon_mode.h     |    4 ++++
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 392ea6e..a876fae 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -32,11 +32,6 @@
 #include "radeon_asic.h"
 #include "atom-bits.h"
 
-/* from radeon_encoder.c */
-extern uint32_t
-radeon_get_encoder_enum(struct drm_device *dev, uint32_t supported_device,
-			uint8_t dac);
-extern void radeon_link_encoder_connector(struct drm_device *dev);
 extern void
 radeon_add_atom_encoder(struct drm_device *dev, uint32_t encoder_enum,
 			uint32_t supported_device, u16 caps);
diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/radeon/radeon_combios.c
index e4c1b8d..6651177 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -37,12 +37,6 @@
 #include <asm/pci-bridge.h>
 #endif /* CONFIG_PPC_PMAC */
 
-/* from radeon_encoder.c */
-extern uint32_t
-radeon_get_encoder_enum(struct drm_device *dev, uint32_t supported_device,
-			uint8_t dac);
-extern void radeon_link_encoder_connector(struct drm_device *dev);
-
 /* from radeon_legacy_encoder.c */
 extern void
 radeon_add_legacy_encoder(struct drm_device *dev, uint32_t encoder_enum,
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index e841fde..d1f7a0e 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -647,6 +647,10 @@ radeon_add_legacy_connector(struct drm_device *dev,
 			    struct radeon_i2c_bus_rec *i2c_bus,
 			    uint16_t connector_object_id,
 			    struct radeon_hpd *hpd);
+uint32_t
+radeon_get_encoder_enum(struct drm_device *dev, uint32_t supported_device,
+			uint8_t dac);
+void radeon_link_encoder_connector(struct drm_device *dev);
 
 extern enum radeon_tv_std
 radeon_combios_get_tv_info(struct radeon_device *rdev);
-- 
1.7.9.5

