Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab3I2Tm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:42:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab3I2T3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 27/71] drm/i915: Dont enable the cursor on a disable pipe
Date: Sun, 29 Sep 2013 12:27:39 -0700
Message-Id: <20130929192645.371419141@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit f2f5f771c5fc0fa252cde3d0d0452dcc785cc17a upstream.

On HSW enabling a plane on a disabled pipe may hang the entire system.
And there's no good reason for doing it ever, so just don't.

v2: Move the crtc active checks to intel_crtc_cursor_{set,move} to
    avoid confusing people during modeset

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Reviewed-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6572,7 +6572,8 @@ static int intel_crtc_cursor_set(struct
 	intel_crtc->cursor_width = width;
 	intel_crtc->cursor_height = height;
 
-	intel_crtc_update_cursor(crtc, intel_crtc->cursor_bo != NULL);
+	if (intel_crtc->active)
+		intel_crtc_update_cursor(crtc, intel_crtc->cursor_bo != NULL);
 
 	return 0;
 fail_unpin:
@@ -6591,7 +6592,8 @@ static int intel_crtc_cursor_move(struct
 	intel_crtc->cursor_x = x;
 	intel_crtc->cursor_y = y;
 
-	intel_crtc_update_cursor(crtc, intel_crtc->cursor_bo != NULL);
+	if (intel_crtc->active)
+		intel_crtc_update_cursor(crtc, intel_crtc->cursor_bo != NULL);
 
 	return 0;
 }


