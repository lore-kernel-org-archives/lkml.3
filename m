Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbaAFPiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:38:13 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:60140 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaAFPiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:38:11 -0500
Date: Mon, 6 Jan 2014 21:08:06 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Damien Lespiau <damien.lespiau@intel.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 32/85] drivers: gpu: Move prototype declarations to header
 file atombios.h
Message-ID: <f4d1b2f307e9ebd14d9f397913298d22ffc464f7.1389018325.git.rashika.kheria@gmail.com>
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

Move prototype declarations of functions radeon_atom_get_tv_timings()
and radeon_atombios_connected_scratch_regs() to header file
drm/radeon/atombios.h because they are used by more than one file.

Include the header file in atombios_encoders.c, radeon_atombios.c and
radeon_connectors.c because they use the function whose prototype
declarations are present in it.

This eliminates the following warnings in drm/radeon/radeon_atombios.c:
drivers/gpu/drm/radeon/radeon_atombios.c:1766:6: warning: no previous prototype for ‘radeon_atom_get_tv_timings’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_atombios.c:4012:1: warning: no previous prototype for ‘radeon_atombios_connected_scratch_regs’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/atombios.h          |    8 ++++++++
 drivers/gpu/drm/radeon/atombios_encoders.c |    6 +-----
 drivers/gpu/drm/radeon/radeon_atombios.c   |    1 +
 drivers/gpu/drm/radeon/radeon_connectors.c |    5 +----
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios.h b/drivers/gpu/drm/radeon/atombios.h
index 92be50c..72a3aa7c 100644
--- a/drivers/gpu/drm/radeon/atombios.h
+++ b/drivers/gpu/drm/radeon/atombios.h
@@ -193,6 +193,14 @@
 #define	OFFSET_TO_GET_ATOMBIOS_STRINGS_NUMBER		0x002f
 #define	OFFSET_TO_GET_ATOMBIOS_STRINGS_START		0x006e
 
+bool radeon_atom_get_tv_timings(struct radeon_device *rdev, int index,
+				struct drm_display_mode *mode);
+void
+radeon_atombios_connected_scratch_regs(struct drm_connector *connector,
+				       struct drm_encoder *encoder,
+				       bool connected);
+
+
 /* Common header for all ROM Data tables.
   Every table pointed  _ATOM_MASTER_DATA_TABLE has this common header. 
   And the pointer actually points to this header. */
diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index a42d615..641298d 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -28,6 +28,7 @@
 #include <drm/radeon_drm.h>
 #include "radeon.h"
 #include "atom.h"
+#include "atombios.h"
 #include <linux/backlight.h>
 
 extern int atom_debug;
@@ -283,11 +284,6 @@ static void radeon_atom_backlight_exit(struct radeon_encoder *encoder)
 
 #endif
 
-/* evil but including atombios.h is much worse */
-bool radeon_atom_get_tv_timings(struct radeon_device *rdev, int index,
-				struct drm_display_mode *mode);
-
-
 static inline bool radeon_encoder_is_digital(struct drm_encoder *encoder)
 {
 	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 5c39bf7..39f1fd6 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -28,6 +28,7 @@
 #include "radeon.h"
 
 #include "atom.h"
+#include "atombios.h"
 #include "atom-bits.h"
 
 /* from radeon_encoder.c */
diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index 20a768a..9070487 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -30,6 +30,7 @@
 #include <drm/radeon_drm.h>
 #include "radeon.h"
 #include "atom.h"
+#include "atombios.h"
 
 #include <linux/pm_runtime.h>
 
@@ -37,10 +38,6 @@ extern void
 radeon_combios_connected_scratch_regs(struct drm_connector *connector,
 				      struct drm_encoder *encoder,
 				      bool connected);
-extern void
-radeon_atombios_connected_scratch_regs(struct drm_connector *connector,
-				       struct drm_encoder *encoder,
-				       bool connected);
 
 void radeon_connector_hotplug(struct drm_connector *connector)
 {
-- 
1.7.9.5

