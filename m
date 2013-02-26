Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713Ab3B0BDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:03:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760082Ab3BZX5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Adam Jackson <ajax@redhat.com>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 072/150] drm: dont add inferred modes for monitors that dont support them
Date: Tue, 26 Feb 2013 15:55:29 -0800
Message-Id: <20130226235531.663384042@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_edid.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -2020,7 +2020,8 @@ int drm_add_edid_modes(struct drm_connec
 	num_modes += add_cvt_modes(connector, edid);
 	num_modes += add_standard_modes(connector, edid);
 	num_modes += add_established_modes(connector, edid);
-	num_modes += add_inferred_modes(connector, edid);
+	if (edid->features & DRM_EDID_FEATURE_DEFAULT_GTF)
+		num_modes += add_inferred_modes(connector, edid);
 	num_modes += add_cea_modes(connector, edid);
 
 	if (quirks & (EDID_QUIRK_PREFER_LARGE_60 | EDID_QUIRK_PREFER_LARGE_75))


