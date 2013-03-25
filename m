Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab3CYBj1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:39:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33797 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755442Ab3CYBPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:04 -0400
Message-Id: <20130325010526.051241417@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:05:41 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 017/104] drm/i915: Increase the RC6p threshold.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stéphane Marchesin <marcheu@chromium.org>

commit 0920a48719f1ceefc909387a64f97563848c7854 upstream.

This increases GEN6_RC6p_THRESHOLD from 100000 to 150000. For some
reason this avoids the gen6_gt_check_fifodbg.isra warnings and
associated GPU lockups, which makes my ivy bridge machine stable.

Signed-off-by: Stéphane Marchesin <marcheu@chromium.org>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8059,7 +8059,7 @@ void gen6_enable_rps(struct drm_i915_pri
 	I915_WRITE(GEN6_RC_SLEEP, 0);
 	I915_WRITE(GEN6_RC1e_THRESHOLD, 1000);
 	I915_WRITE(GEN6_RC6_THRESHOLD, 50000);
-	I915_WRITE(GEN6_RC6p_THRESHOLD, 100000);
+	I915_WRITE(GEN6_RC6p_THRESHOLD, 150000);
 	I915_WRITE(GEN6_RC6pp_THRESHOLD, 64000); /* unused */
 
 	if (intel_enable_rc6(dev_priv->dev))


