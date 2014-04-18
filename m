Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaDRJYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:24:06 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45901 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbaDRJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
        Dave Airlie <airlied@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 22/72] drm: add drm_set_preferred_mode
Date: Fri, 18 Apr 2014 11:21:55 +0200
Message-Id: <1d2fa7e7e9182bbd085e314d6c804ab34d068e47.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3cf70dafd7bbbc91df0a9ecb081d46f9f3d867f6 upstream.

New helper function to set the preferred video mode.  Can be called
after drm_add_modes_noedid if you don't want the largest supported
video mode be used by default.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/drm_edid.c | 13 +++++++++++++
 include/drm/drm_crtc.h     |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index d0d3eae05a1a..1cb50268a224 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -3296,6 +3296,19 @@ int drm_add_modes_noedid(struct drm_connector *connector,
 }
 EXPORT_SYMBOL(drm_add_modes_noedid);
 
+void drm_set_preferred_mode(struct drm_connector *connector,
+			   int hpref, int vpref)
+{
+	struct drm_display_mode *mode;
+
+	list_for_each_entry(mode, &connector->probed_modes, head) {
+		if (drm_mode_width(mode)  == hpref &&
+		    drm_mode_height(mode) == vpref)
+			mode->type |= DRM_MODE_TYPE_PREFERRED;
+	}
+}
+EXPORT_SYMBOL(drm_set_preferred_mode);
+
 /**
  * drm_hdmi_avi_infoframe_from_display_mode() - fill an HDMI AVI infoframe with
  *                                              data from a DRM display mode
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 24f499569a2f..ec5d737f93c5 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -1108,6 +1108,8 @@ extern struct drm_display_mode *drm_gtf_mode_complex(struct drm_device *dev,
 				int GTF_2C, int GTF_K, int GTF_2J);
 extern int drm_add_modes_noedid(struct drm_connector *connector,
 				int hdisplay, int vdisplay);
+extern void drm_set_preferred_mode(struct drm_connector *connector,
+				   int hpref, int vpref);
 
 extern int drm_edid_header_is_valid(const u8 *raw_edid);
 extern bool drm_edid_block_valid(u8 *raw_edid, int block, bool print_bad_edid);
-- 
1.9.2

