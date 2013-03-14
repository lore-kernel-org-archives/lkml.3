Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab3CNKjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:39:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52111 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab3CNKiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 83/88] drm/i915: Increase the RC6p threshold.
Date: Thu, 14 Mar 2013 10:36:16 +0000
Message-Id: <1363257381-15900-84-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>

commit 0920a48719f1ceefc909387a64f97563848c7854 upstream.

This increases GEN6_RC6p_THRESHOLD from 100000 to 150000. For some
reason this avoids the gen6_gt_check_fifodbg.isra warnings and
associated GPU lockups, which makes my ivy bridge machine stable.

Signed-off-by: Stéphane Marchesin <marcheu@chromium.org>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index b40ce63..b4cc672 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -2397,7 +2397,7 @@ void gen6_enable_rps(struct drm_i915_private *dev_priv)
 	I915_WRITE(GEN6_RC_SLEEP, 0);
 	I915_WRITE(GEN6_RC1e_THRESHOLD, 1000);
 	I915_WRITE(GEN6_RC6_THRESHOLD, 50000);
-	I915_WRITE(GEN6_RC6p_THRESHOLD, 100000);
+	I915_WRITE(GEN6_RC6p_THRESHOLD, 150000);
 	I915_WRITE(GEN6_RC6pp_THRESHOLD, 64000); /* unused */
 
 	rc6_mode = intel_enable_rc6(dev_priv->dev);
-- 
1.8.1.2

