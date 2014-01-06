Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbaAFQjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:39:06 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:61940 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbaAFQjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:39:03 -0500
Date: Mon, 6 Jan 2014 22:08:55 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Jerome Glisse <jglisse@redhat.com>, dri-devel@lists.freedesktop.org,
        josh@joshtriplett.org
Subject: [PATCH 74/85] drivers: gpu: Move prototype declarations to header
 file radeon.h from evergreen_hdmi.c
Message-ID: <b54c6fe3b4a4ea6a5010022de9fd59ebf1ae0b9c.1389018325.git.rashika.kheria@gmail.com>
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

Move prototype declarations of function
dce6_afmt_write_speaker_allocation(), dce6_afmt_write_sad_regs(),
dce6_afmt_select_pin() and dce6_afmt_write_latency_fields() to header
file drm/radeon/radeon.h because they are used by more than one file.

This eliminates the following warnings in drm/radeon/dce6_afmt.c:
drivers/gpu/drm/radeon/dce6_afmt.c:91:6: warning: no previous prototype for ‘dce6_afmt_select_pin’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/dce6_afmt.c:107:6: warning: no previous prototype for ‘dce6_afmt_write_latency_fields’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/dce6_afmt.c:150:6: warning: no previous prototype for ‘dce6_afmt_write_speaker_allocation’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/dce6_afmt.c:196:6: warning: no previous prototype for ‘dce6_afmt_write_sad_regs’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/evergreen_hdmi.c |    6 ------
 drivers/gpu/drm/radeon/radeon.h         |    5 +++++
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen_hdmi.c b/drivers/gpu/drm/radeon/evergreen_hdmi.c
index aa695c4..af896ac 100644
--- a/drivers/gpu/drm/radeon/evergreen_hdmi.c
+++ b/drivers/gpu/drm/radeon/evergreen_hdmi.c
@@ -32,12 +32,6 @@
 #include "evergreend.h"
 #include "atom.h"
 
-extern void dce6_afmt_write_speaker_allocation(struct drm_encoder *encoder);
-extern void dce6_afmt_write_sad_regs(struct drm_encoder *encoder);
-extern void dce6_afmt_select_pin(struct drm_encoder *encoder);
-extern void dce6_afmt_write_latency_fields(struct drm_encoder *encoder,
-					   struct drm_display_mode *mode);
-
 /*
  * update the N and CTS parameters for a given pixel clock rate
  */
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 8e0b9dd..b0687fa 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -2741,6 +2741,11 @@ int radeon_vm_bo_rmv(struct radeon_device *rdev,
 void r600_audio_update_hdmi(struct work_struct *work);
 struct r600_audio_pin *r600_audio_get_pin(struct radeon_device *rdev);
 struct r600_audio_pin *dce6_audio_get_pin(struct radeon_device *rdev);
+void dce6_afmt_select_pin(struct drm_encoder *encoder);
+void dce6_afmt_write_speaker_allocation(struct drm_encoder *encoder);
+void dce6_afmt_write_sad_regs(struct drm_encoder *encoder);
+void dce6_afmt_write_latency_fields(struct drm_encoder *encoder,
+				    struct drm_display_mode *mode);
 
 /*
  * R600 vram scratch functions
-- 
1.7.9.5

