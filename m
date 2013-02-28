Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967Ab3B1PBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:01:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42412 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759070Ab3B1OuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:50:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>, Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 103/139] drm: don't add inferred modes for monitors that don't support them
Date: Thu, 28 Feb 2013 14:44:13 +0000
Message-Id: <1362062689-2567-104-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Zanoni <paulo.r.zanoni@intel.com>

commit 196e077dc165a307efbd9e7569f81bbdbcf18f65 upstream.

If bit 0 of the features byte (0x18) is set to 0, then, according to
the EDID spec, "the display is non-continuous frequency (multi-mode)
and is only specified to accept the video timing formats that are
listed in Base EDID and certain Extension Blocks".

For more information, please see the EDID spec, check the notes of the
table that explains the "Feature Support" byte (18h) and also the
notes on the tables of the section that explains "Display Range Limits
& Additional Timing Description Definition (tag #FDh)".

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=45729
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Adam Jackson <ajax@redhat.com>
Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/drm_edid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index a8743c3..74f2421 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -1921,7 +1921,8 @@ int drm_add_edid_modes(struct drm_connector *connector, struct edid *edid)
 	num_modes += add_cvt_modes(connector, edid);
 	num_modes += add_standard_modes(connector, edid);
 	num_modes += add_established_modes(connector, edid);
-	num_modes += add_inferred_modes(connector, edid);
+	if (edid->features & DRM_EDID_FEATURE_DEFAULT_GTF)
+		num_modes += add_inferred_modes(connector, edid);
 	num_modes += add_cea_modes(connector, edid);
 
 	if (quirks & (EDID_QUIRK_PREFER_LARGE_60 | EDID_QUIRK_PREFER_LARGE_75))
-- 
1.8.1.2

