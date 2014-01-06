Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaAFPlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:41:04 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:32891 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaAFPlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:41:01 -0500
Date: Mon, 6 Jan 2014 21:10:56 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Damien Lespiau <damien.lespiau@intel.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        josh@joshtriplett.org
Subject: [PATCH 34/85] drivers: gpu: Move prototype declaration to
 appropriate header file radeon_mode.h
Message-ID: <b2d64dcf28678c0efceb2621929e08aabe25ebe5.1389018325.git.rashika.kheria@gmail.com>
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

Move prototype declaration of function
radeon_combios_connected_scratch_regs() to header file
drm/radeon/radeon_mode.h from drm/radeon/radeon_connectors.c because it
is used by more than one file.

This eliminates the following warning in drm/radeon/radeon_combios.c:
drivers/gpu/drm/radeon/radeon_combios.c:3449:1: warning: no previous prototype for ‘radeon_combios_connected_scratch_regs’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/radeon_connectors.c |    5 -----
 drivers/gpu/drm/radeon/radeon_mode.h       |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index 9070487..c12eca0 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -34,11 +34,6 @@
 
 #include <linux/pm_runtime.h>
 
-extern void
-radeon_combios_connected_scratch_regs(struct drm_connector *connector,
-				      struct drm_encoder *encoder,
-				      bool connected);
-
 void radeon_connector_hotplug(struct drm_connector *connector)
 {
 	struct drm_device *dev = connector->dev;
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index 3f0dd66..b2b556b 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -46,6 +46,11 @@ struct radeon_device;
 #define to_radeon_encoder(x) container_of(x, struct radeon_encoder, base)
 #define to_radeon_framebuffer(x) container_of(x, struct radeon_framebuffer, base)
 
+void
+radeon_combios_connected_scratch_regs(struct drm_connector *connector,
+				      struct drm_encoder *encoder,
+				      bool connected);
+
 enum radeon_rmx_type {
 	RMX_OFF,
 	RMX_FULL,
-- 
1.7.9.5

