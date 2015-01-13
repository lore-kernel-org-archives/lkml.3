Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbbAMTGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:06:22 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:61611 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbbAMTGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:06:21 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/radeon/radeon_i2c: Remove unused function
Date: Tue, 13 Jan 2015 20:09:27 +0100
Message-Id: <1421176167-7180-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function radeon_best_encoder() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/radeon/radeon_i2c.c  |    5 -----
 drivers/gpu/drm/radeon/radeon_mode.h |    2 --
 2 files changed, 7 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_i2c.c b/drivers/gpu/drm/radeon/radeon_i2c.c
index add6220..9590bcd 100644
--- a/drivers/gpu/drm/radeon/radeon_i2c.c
+++ b/drivers/gpu/drm/radeon/radeon_i2c.c
@@ -1048,11 +1048,6 @@ struct radeon_i2c_chan *radeon_i2c_lookup(struct radeon_device *rdev,
 	return NULL;
 }
 
-struct drm_encoder *radeon_best_encoder(struct drm_connector *connector)
-{
-	return NULL;
-}
-
 void radeon_i2c_get_byte(struct radeon_i2c_chan *i2c_bus,
 			 u8 slave_addr,
 			 u8 addr,
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index 04db2fd..66c17e3 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -740,8 +740,6 @@ extern void radeon_router_select_ddc_port(struct radeon_connector *radeon_connec
 extern void radeon_router_select_cd_port(struct radeon_connector *radeon_connector);
 extern bool radeon_ddc_probe(struct radeon_connector *radeon_connector, bool use_aux);
 
-extern struct drm_encoder *radeon_best_encoder(struct drm_connector *connector);
-
 extern bool radeon_atombios_get_ppll_ss_info(struct radeon_device *rdev,
 					     struct radeon_atom_ss *ss,
 					     int id);
-- 
1.7.10.4

