Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab3LSMZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:25:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45059 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab3LSL63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 132/208] drm/i915: Fix pipe CSC post offset calculation
Date: Thu, 19 Dec 2013 11:53:50 +0000
Message-Id: <1387454106-19326-133-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

commit 32cf0cb0294814cb1ee5d8727e9aac0e9aa80d2e upstream.

We were miscalculating the pipe CSC post offset for the full->limited
range conversion. The resulting post offset was double what it was
supposed to be, which caused blacks to come out grey when using
limited range output on HSW+.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=71769
Tested-by: Lauri Mylläri <lauri.myllari@gmail.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 449ec09..9d39620 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5466,7 +5466,7 @@ static void intel_set_pipe_csc(struct drm_crtc *crtc)
 		uint16_t postoff = 0;
 
 		if (intel_crtc->config.limited_color_range)
-			postoff = (16 * (1 << 13) / 255) & 0x1fff;
+			postoff = (16 * (1 << 12) / 255) & 0x1fff;
 
 		I915_WRITE(PIPE_CSC_POSTOFF_HI(pipe), postoff);
 		I915_WRITE(PIPE_CSC_POSTOFF_ME(pipe), postoff);
-- 
1.8.3.2

