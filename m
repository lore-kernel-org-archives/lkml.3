Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaCYTgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:36:07 -0400
Received: from smtprelay0193.hostedemail.com ([216.40.44.193]:33900 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754764AbaCYTf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:35:26 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:857:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3870:3871:3872:3874:4250:4321:4605:5007:6117:6261:7903:10004:10026:10848:11026:11232:11233:11473:11657:11658:11914:12043:12517:12519:12555:12663,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spade93_120ec21d13e56
X-Filterd-Recvd-Size: 3553
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 4/5] i915: Convert last uses of __FUNCTION__ to __func__
Date: Tue, 25 Mar 2014 12:35:06 -0700
Message-Id: <f73fada74a8320ec33f21ed29e21ee47fb016a42.1395775901.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1395775901.git.joe@perches.com>
References: <cover.1395775901.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just about all of these have been converted to __func__,
so convert the last uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/i915/dvo_ns2501.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/dvo_ns2501.c b/drivers/gpu/drm/i915/dvo_ns2501.c
index 954acb2..e40cd26 100644
--- a/drivers/gpu/drm/i915/dvo_ns2501.c
+++ b/drivers/gpu/drm/i915/dvo_ns2501.c
@@ -234,7 +234,7 @@ static enum drm_mode_status ns2501_mode_valid(struct intel_dvo_device *dvo,
 {
 	DRM_DEBUG_KMS
 	    ("%s: is mode valid (hdisplay=%d,htotal=%d,vdisplay=%d,vtotal=%d)\n",
-	     __FUNCTION__, mode->hdisplay, mode->htotal, mode->vdisplay,
+	     __func__, mode->hdisplay, mode->htotal, mode->vdisplay,
 	     mode->vtotal);
 
 	/*
@@ -262,7 +262,7 @@ static void ns2501_mode_set(struct intel_dvo_device *dvo,
 
 	DRM_DEBUG_KMS
 	    ("%s: set mode (hdisplay=%d,htotal=%d,vdisplay=%d,vtotal=%d).\n",
-	     __FUNCTION__, mode->hdisplay, mode->htotal, mode->vdisplay,
+	     __func__, mode->hdisplay, mode->htotal, mode->vdisplay,
 	     mode->vtotal);
 
 	/*
@@ -277,8 +277,7 @@ static void ns2501_mode_set(struct intel_dvo_device *dvo,
 		if (mode->hdisplay == 800 && mode->vdisplay == 600) {
 			/* mode 277 */
 			ns->reg_8_shadow &= ~NS2501_8_BPAS;
-			DRM_DEBUG_KMS("%s: switching to 800x600\n",
-				      __FUNCTION__);
+			DRM_DEBUG_KMS("%s: switching to 800x600\n", __func__);
 
 			/*
 			 * No, I do not know where this data comes from.
@@ -341,8 +340,7 @@ static void ns2501_mode_set(struct intel_dvo_device *dvo,
 
 		} else if (mode->hdisplay == 640 && mode->vdisplay == 480) {
 			/* mode 274 */
-			DRM_DEBUG_KMS("%s: switching to 640x480\n",
-				      __FUNCTION__);
+			DRM_DEBUG_KMS("%s: switching to 640x480\n", __func__);
 			/*
 			 * No, I do not know where this data comes from.
 			 * It is just what the video bios left in the DVO, so
@@ -406,8 +404,7 @@ static void ns2501_mode_set(struct intel_dvo_device *dvo,
 
 		} else if (mode->hdisplay == 1024 && mode->vdisplay == 768) {
 			/* mode 280 */
-			DRM_DEBUG_KMS("%s: switching to 1024x768\n",
-				      __FUNCTION__);
+			DRM_DEBUG_KMS("%s: switching to 1024x768\n", __func__);
 			/*
 			 * This might or might not work, actually. I'm silently
 			 * assuming here that the native panel resolution is
@@ -459,7 +456,7 @@ static void ns2501_dpms(struct intel_dvo_device *dvo, bool enable)
 	unsigned char ch;
 
 	DRM_DEBUG_KMS("%s: Trying set the dpms of the DVO to %i\n",
-		      __FUNCTION__, enable);
+		      __func__, enable);
 
 	ch = ns->reg_8_shadow;
 
-- 
1.8.1.2.459.gbcd45b4.dirty

