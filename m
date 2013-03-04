Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3CDEBe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:01:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32931 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756569Ab3CDDnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:51 -0500
Message-Id: <20130304033715.343516170@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:26 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Adam Jackson <ajax@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 079/153] drm: dont add inferred modes for monitors that dont support them
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/drm_edid.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -1740,7 +1740,8 @@ int drm_add_edid_modes(struct drm_connec
 	num_modes += add_cvt_modes(connector, edid);
 	num_modes += add_standard_modes(connector, edid);
 	num_modes += add_established_modes(connector, edid);
-	num_modes += add_inferred_modes(connector, edid);
+	if (edid->features & DRM_EDID_FEATURE_DEFAULT_GTF)
+		num_modes += add_inferred_modes(connector, edid);
 
 	if (quirks & (EDID_QUIRK_PREFER_LARGE_60 | EDID_QUIRK_PREFER_LARGE_75))
 		edid_fixup_preferred(connector, quirks);


