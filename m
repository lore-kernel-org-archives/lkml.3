Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab3JJQIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:08:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52663 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab3JJPo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:44:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 050/104] drm/i915: Don't enable the cursor on a disable pipe
Date: Thu, 10 Oct 2013 08:41:38 -0700
Message-Id: <1381419752-29733-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

commit f2f5f771c5fc0fa252cde3d0d0452dcc785cc17a upstream.

On HSW enabling a plane on a disabled pipe may hang the entire system.
And there's no good reason for doing it ever, so just don't.

v2: Move the crtc active checks to intel_crtc_cursor_{set,move} to
    avoid confusing people during modeset

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Reviewed-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 3e4e629..a38cbdc 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6519,7 +6519,8 @@ static int intel_crtc_cursor_set(struct drm_crtc *crtc,
 	intel_crtc->cursor_width = width;
 	intel_crtc->cursor_height = height;
 
-	intel_crtc_update_cursor(crtc, true);
+	if (intel_crtc->active)
+		intel_crtc_update_cursor(crtc, true);
 
 	return 0;
 fail_unpin:
@@ -6538,7 +6539,8 @@ static int intel_crtc_cursor_move(struct drm_crtc *crtc, int x, int y)
 	intel_crtc->cursor_x = x;
 	intel_crtc->cursor_y = y;
 
-	intel_crtc_update_cursor(crtc, true);
+	if (intel_crtc->active)
+		intel_crtc_update_cursor(crtc, true);
 
 	return 0;
 }
-- 
1.8.1.2

