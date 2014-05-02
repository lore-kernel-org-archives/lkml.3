Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaEBPnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:43:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43982 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbaEBPnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:43:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 030/151] drm/i915: Don't clobber CHICKEN_PIPESL_1 on BDW
Date: Fri,  2 May 2014 08:36:58 -0700
Message-Id: <1399045139-4531-31-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

commit c7c656226842679bcd9f39dc24441b4ff398a850 upstream.

Misplaced parens cause us to totally clobber the CHICKEN_PIPESL_1
registers with 0xffffffff. Move the parens to the correct place
to avoid this.

In particular this caused bit 30 of said registers to be set, which
caused the sprite CSC to produce incorrect results.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=72220
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Damien Lespiau <damien.lespiau@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ kamal: backport to 3.13 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_pm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 26c29c1..e2d10ce 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -5314,8 +5314,8 @@ static void gen8_init_clock_gating(struct drm_device *dev)
 	/* WaPsrDPRSUnmaskVBlankInSRD */
 	for_each_pipe(i) {
 		I915_WRITE(CHICKEN_PIPESL_1(i),
-			   I915_READ(CHICKEN_PIPESL_1(i) |
-				     DPRS_MASK_VBLANK_SRD));
+			   I915_READ(CHICKEN_PIPESL_1(i)) |
+			   DPRS_MASK_VBLANK_SRD);
 	}
 }
 
-- 
1.9.1

