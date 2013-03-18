Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245Ab3CRV1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:27:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab3CRVIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:08:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?ISO-8859-15?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 36/48] drm/i915: Increase the RC6p threshold.
Date: Mon, 18 Mar 2013 14:08:44 -0700
Message-Id: <20130318210812.797825940@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210810.247845918@linuxfoundation.org>
References: <20130318210810.247845918@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stéphane Marchesin <marcheu@chromium.org>

commit 0920a48719f1ceefc909387a64f97563848c7854 upstream.

This increases GEN6_RC6p_THRESHOLD from 100000 to 150000. For some
reason this avoids the gen6_gt_check_fifodbg.isra warnings and
associated GPU lockups, which makes my ivy bridge machine stable.

Signed-off-by: Stéphane Marchesin <marcheu@chromium.org>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8364,7 +8364,7 @@ void gen6_enable_rps(struct drm_i915_pri
 	I915_WRITE(GEN6_RC_SLEEP, 0);
 	I915_WRITE(GEN6_RC1e_THRESHOLD, 1000);
 	I915_WRITE(GEN6_RC6_THRESHOLD, 50000);
-	I915_WRITE(GEN6_RC6p_THRESHOLD, 100000);
+	I915_WRITE(GEN6_RC6p_THRESHOLD, 150000);
 	I915_WRITE(GEN6_RC6pp_THRESHOLD, 64000); /* unused */
 
 	rc6_mode = intel_enable_rc6(dev_priv->dev);


