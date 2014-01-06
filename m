Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbaAFP4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:56:19 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:63484 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaAFP4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:56:18 -0500
Date: Mon, 6 Jan 2014 21:26:08 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Rashika Kheria <rashika.kheria@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 46/85] drivers: gpu: Move prototype declarations to header
 file radeon_mode.h from radeon_i2c.c
Message-ID: <52e05a6b4ef0b8ab2b60c01e61c9982f56d40717.1389018325.git.rashika.kheria@gmail.com>
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

Move prototype declaration of functions radeon_atom_hw_i2c_xfer() and
radeon_atom_hw_i2c_func() to header file drm/radeon/radeon_mode.h
because they are used by more than one file.

This eliminates the following warnings in drm/radeon/atombios_i2c.c:
drivers/gpu/drm/radeon/atombios_i2c.c:96:5: warning: no previous prototype for ‘radeon_atom_hw_i2c_xfer’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/atombios_i2c.c:146:5: warning: no previous prototype for ‘radeon_atom_hw_i2c_func’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/radeon_i2c.c  |    4 ----
 drivers/gpu/drm/radeon/radeon_mode.h |    4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_i2c.c b/drivers/gpu/drm/radeon/radeon_i2c.c
index fc60b74..fd07db8 100644
--- a/drivers/gpu/drm/radeon/radeon_i2c.c
+++ b/drivers/gpu/drm/radeon/radeon_i2c.c
@@ -31,10 +31,6 @@
 #include "radeon.h"
 #include "atom.h"
 
-extern int radeon_atom_hw_i2c_xfer(struct i2c_adapter *i2c_adap,
-				   struct i2c_msg *msgs, int num);
-extern u32 radeon_atom_hw_i2c_func(struct i2c_adapter *adap);
-
 /**
  * radeon_ddc_probe
  *
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index 8f2f4a3..129f069 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -628,6 +628,10 @@ struct atom_voltage_table
 	struct atom_voltage_table_entry entries[MAX_VOLTAGE_ENTRIES];
 };
 
+int radeon_atom_hw_i2c_xfer(struct i2c_adapter *i2c_adap,
+			    struct i2c_msg *msgs, int num);
+u32 radeon_atom_hw_i2c_func(struct i2c_adapter *adap);
+
 void
 radeon_atom_backlight_init(struct radeon_encoder *radeon_encoder,
 			   struct drm_connector *drm_connector);
-- 
1.7.9.5

