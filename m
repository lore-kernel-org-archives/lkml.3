Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab3IEUmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:42:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756948Ab3IEU2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeremy Moles <cubicool@gmail.com>, Imre Deak <imre.deak@intel.com>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 17/36] drm/i915: ivb: fix edp voltage swing reg val
Date: Thu,  5 Sep 2013 13:27:46 -0700
Message-Id: <20130905202704.291448302@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202702.289738686@linuxfoundation.org>
References: <20130905202702.289738686@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -4246,7 +4246,7 @@
 #define EDP_LINK_TRAIN_600MV_0DB_IVB		(0x30 <<22)
 #define EDP_LINK_TRAIN_600MV_3_5DB_IVB		(0x36 <<22)
 #define EDP_LINK_TRAIN_800MV_0DB_IVB		(0x38 <<22)
-#define EDP_LINK_TRAIN_800MV_3_5DB_IVB		(0x33 <<22)
+#define EDP_LINK_TRAIN_800MV_3_5DB_IVB		(0x3e <<22)
 
 /* legacy values */
 #define EDP_LINK_TRAIN_500MV_0DB_IVB		(0x00 <<22)


