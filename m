Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbaAFPql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:46:41 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:63844 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbaAFPqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:46:39 -0500
Date: Mon, 6 Jan 2014 21:16:34 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 39/85] drivers: gpu: Move prototype declaration to header
 file radeon_mode.h from atombios_i2c.c
Message-ID: <44e2d244ed2106a946a5ba27a590a1636154e5e8.1389018325.git.rashika.kheria@gmail.com>
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

Move prototype declaration of function radeon_atom_copy_swap() to header
file drm/radeon/radeon_mode.h because it is used by more than one file.

This eliminates the following warnings in drm/radeon/atombios_dp.c:
drivers/gpu/drm/radeon/atombios_dp.c:53:6: warning: no previous prototype for ‘radeon_atom_copy_swap’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/atombios_i2c.c |    2 --
 drivers/gpu/drm/radeon/radeon_mode.h  |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_i2c.c b/drivers/gpu/drm/radeon/atombios_i2c.c
index f685035dbe..b5162c3 100644
--- a/drivers/gpu/drm/radeon/atombios_i2c.c
+++ b/drivers/gpu/drm/radeon/atombios_i2c.c
@@ -27,8 +27,6 @@
 #include "radeon.h"
 #include "atom.h"
 
-extern void radeon_atom_copy_swap(u8 *dst, u8 *src, u8 num_bytes, bool to_le);
-
 #define TARGET_HW_I2C_CLOCK 50
 
 /* these are a limitation of ProcessI2cChannelTransaction not the hw */
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index d1f7a0e..b5f4e52 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -694,6 +694,7 @@ extern void radeon_atom_ext_encoder_setup_ddc(struct drm_encoder *encoder);
 extern struct drm_encoder *radeon_get_external_encoder(struct drm_encoder *encoder);
 extern int radeon_dp_i2c_aux_ch(struct i2c_adapter *adapter, int mode,
 				u8 write_byte, u8 *read_byte);
+void radeon_atom_copy_swap(u8 *dst, u8 *src, u8 num_bytes, bool to_le);
 
 extern void radeon_i2c_init(struct radeon_device *rdev);
 extern void radeon_i2c_fini(struct radeon_device *rdev);
-- 
1.7.9.5

