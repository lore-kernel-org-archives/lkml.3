Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3IISuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:50:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57097 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab3IISpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:45:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Imre Deak <imre.deak@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 21/24] drm/i915: ivb: fix edp voltage swing reg val
Date: Mon,  9 Sep 2013 11:45:11 -0700
Message-Id: <1378752314-2416-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378752314-2416-1-git-send-email-kamal@canonical.com>
References: <1378752314-2416-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 77fa4cbd5fa389e28419bbe8ac491b5fdd54840d upstream.

Fix the typo introduced in

commit 1a2eb4604b85c5efb343da8a4dcf41288fcfca85
Author: Keith Packard <keithp@keithp.com>
Date:   Wed Nov 16 16:26:07 2011 -0800

    drm/i915: Hook up Ivybridge eDP

This fixes eDP link-training failures and cases where all voltage swing
/pre-emphasis levels were tried and failed during clock recovery and -
as a fallback - we go on to do channel equalization with the last voltage
swing/pre-emphasis level which will succeed. Both issues can lead to a
blank screen.

v2:
- improve commit message

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=64880
Tested-by: Jeremy Moles <cubicool@gmail.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_reg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 8028dcf..7924166 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -4144,7 +4144,7 @@
 #define EDP_LINK_TRAIN_600MV_0DB_IVB		(0x30 <<22)
 #define EDP_LINK_TRAIN_600MV_3_5DB_IVB		(0x36 <<22)
 #define EDP_LINK_TRAIN_800MV_0DB_IVB		(0x38 <<22)
-#define EDP_LINK_TRAIN_800MV_3_5DB_IVB		(0x33 <<22)
+#define EDP_LINK_TRAIN_800MV_3_5DB_IVB		(0x3e <<22)
 
 /* legacy values */
 #define EDP_LINK_TRAIN_500MV_0DB_IVB		(0x00 <<22)
-- 
1.8.1.2

